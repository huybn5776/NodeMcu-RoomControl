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

httpTasks = {}

function httpGet(url, name, callback)
  if lcd then
    lcd:printInfo((name and name or 'httpGet') .. ' . . .')
  end

  print('httpGet', name and name or url)

  http.get(url, nil, function(code, data)
    if (code < 0) then
      print('HTTP request failed: ', name and name or url)
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
  end)
end

wifiInit()
