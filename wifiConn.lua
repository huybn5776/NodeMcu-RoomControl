local function wifiInit()
  wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
    print('\n\tSTA - CONNECTED' ..
        '\n\tSSID:  ' .. T.SSID ..
        '\n\tBSSID: ' .. T.BSSID ..
        '\n\tChannel: ' .. T.channel)
    connectedWifi = T.SSID
  end)

  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
    updateWifiStatusLcd(T.SSID)
    print('\n\tSTA - GOT IP: ' .. T.IP)
    updateTime()
    afterWifiConnected()
  end)

  wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
    print('\n\tSTA - DISCONNECTED' ..
        '\n\tSSID:   ' .. T.SSID ..
        '\n\tBSSID:  ' .. T.BSSID ..
        '\n\treason: ' .. T.reason)
    connectedWifi = nil
    updateWifiStatusLcd(T.SSID)
  end)

  wifi.setmode(wifi.STATION)

  if wifi.sta.status() ~= wifi.STA_GOTIP then
    wifi.sta.config({ ssid = config.ssid, pwd = config.pwd })
    if config.ip then
      wifi.sta.setip({
        ip = config.ip,
        netmask = config.netmask or '255.255.255.0',
        gateway = config.gateway or '192.168.1.1',
      })
    end
    connectedWifi = nil
  end
end

function afterWifiConnected()
  -- Override this function to do something after wifi connected.
end

function updateWifiStatusLcd()
  if lcd then
    lcd:print('W:' .. string.sub((connectedWifi or ""), 1, 1))
  end
end

function updateTime()
  httpGet('http://worldtimeapi.org/api/timezone/Asia/Taipei', 'getTime',
      function(data)
        local _, indexFrom = data:find('"unixtime":"')
        data = data:sub(indexFrom + 1);
        local indexTo = data:find('"')
        local offsetSecond = 1
        local unixTime = tonumber(data:sub(1, indexTo - 1))
        rtctime.set(unixTime + 28800 + offsetSecond, 0)
        tmr.alarm(0, 100, tmr.ALARM_SINGLE, function()
          print('Time updated: ' .. getTime())
          writeLog('System ON')
        end)
      end)
end

httpTasks = {}

-- Run http GET, or schedule it if have multiple task to be done.
function httpGet(url, name, callback)
  if #httpTasks and url then
    table.insert(httpTasks, { url, name, callback })
    return
  end

  if url == nil then
    task = table.remove(httpTasks, 1)
    url, name, callback = task[1], task[2], task[3]
  end

  if lcd then
    lcd:printInfo((name and name or 'httpGet') .. ' . . .')
  end

  log('httpGet', name and name or url)

  http.get(url, nil, function(code, data)
    if (code < 0) then
      log('HTTP request failed: ', name and name or url)
      if lcd then
        lcd:printInfo('httpGet Failed')
      end
    else
      print(code, data)
    end
    if not (callback == nil) then
      callback(data)
    end
    if lcd then
      lcd:clearRow(1)
    end

    if #httpTasks > 0 then
      httpGet()
    end

  end)
end

-- Download file to specific path.
-- Modify From https://github.com/Manawyrm/ESP8266-HTTP/blob/master/httpDL.lua
function download(host, port, url, path, callback)
  file.remove(path);
  file.open(path, 'w+')

  payloadFound = false
  conn = net.createConnection(net.TCP)
  conn:on('receive', function(_, payload)

    if (payloadFound == true) then
      file.write(payload)
      file.flush()
    else
      if (string.find(payload, '\r\n\r\n') ~= nil) then
        file.write(string.sub(payload, string.find(payload, '\r\n\r\n') + 4))
        file.flush()
        payloadFound = true
      end
    end

    payload = nil
    collectgarbage()
  end)

  conn:on('disconnection', function(conn)
    conn = nil
    file.close()
    callback('ok')
  end)

  conn:on('connection', function(conn)
    conn:send('GET /' .. url .. ' HTTP/1.0\r\n' ..
        'Host: ' .. host .. '\r\n' ..
        'Connection: close\r\n' ..
        'Accept-Charset: utf-8\r\n' ..
        'Accept-Encoding: \r\n' ..
        'User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n' ..
        'Accept: */*\r\n\r\n')
  end)
  conn:connect(port, host)
end

wifiInit()
