ledPin = 4
usPerMs = 1000
usPerSecond = 1000 * usPerMs

function led(on)
  gpio.write(ledPin, on == 1 and gpio.LOW or gpio.HIGH)
end

-- Example:
-- coroutine.wrap(function()
--   local result = await(functionThatFirstArgIsCallback)
--   -- will wait for callback then continue.
-- end)
function await(func, ...)
  local current = coroutine.running()
  func(function(...)
    coroutine.resume(current, ...)
  end, ...)
  return coroutine.yield(result)
end

function setTimeout(callback, time)
  if (callback == nil or time == nil) then
    return
  end
  tmr.alarm(6, time, tmr.ALARM_SINGLE, function()
    callback(data)
  end)
end

function printTableSorted(tablePairs)
  local tKeys = {}
  local maxKeyLength = 0
  local maxValueLength = 0
  for k, _ in pairs(tablePairs) do
    table.insert(tKeys, k)
    maxKeyLength = math.max(#k, maxKeyLength)
    maxValueLength = math.max(#tostring(tablePairs[k]), maxValueLength)
  end
  table.sort(tKeys)
  for _, k in ipairs(tKeys) do
    local spacing = string.rep(" ", maxKeyLength - #k) .. "  "
        .. string.rep(" ", maxValueLength - #tostring(tablePairs[k]))
    print(k .. spacing .. tablePairs[k])
  end
end

function fileList()
  printTableSorted(file.list())
end

function writeFile(fileName, str)
  if file.open(fileName, "a+") then
    file.write(str .. "\r\n")
    file.close()
  end
end

function printFile(fileName)
  if file.open(fileName, "r") then
    while true do
      local line = file.readline()
      if line == nil then
        break
      end
      line = line:gsub("[\r\n]", '')
      print(line)
    end
    file.close()
  end
end

function writeLog(...)
  writeFile('log.txt', getTime() .. '\t'
      .. table.concat(arg, '\t'))
end

function printLog()
  printFile('log.txt')
end

disableLog = nil
function log(...)
  print(unpack(arg))
  if disableLogOnce == true then
    disableLogOnce = nil
  else
    writeLog(unpack(arg))
  end
end

function getTime()
  local sec, uSec = rtctime.get()
  if (sec == 0 and uSec == 0) then
    updateTime()
  end
  local tm = rtctime.epoch2cal(sec)
  return string.format('%02d-%02d %02d:%02d:%02d.%03d',
      tm['mon'], tm['day'], tm['hour'], tm['min'], tm['sec'],
      math.floor(uSec / 1000)
  )
end

-- Schedule an load LFS image task, then load it after restart to prevent "not enough memory" issue.
function loadImg(imageFileName)
  file.open('readImg', "w")
  file.write(imageFileName or 'lfs.img')
  file.close()
  node.restart()
end

-- Download LFS image from file server (ex:json-server on your pc) then apply it.
function lfsOta()
  local fileName = 'lfs.img'
  download(config.fileServerIp, 3000, '/' .. fileName, fileName,
      function()
        print('File downloaded: ' .. fileName, file.list(fileName)[fileName])
        loadImg(fileName)
      end
  )
end

function printRam()
  file.remove('ram.txt')
  file.open('ram.txt', 'w')
  local a = debug.getstrings 'RAM'
  print('total', #a)
  for i = 1, #a do
    a[i] = file.write(('%q,\r\n'):format(a[i]):gsub('"', "'"))
  end
  file.close()
end

function mod(a, b)
  return a - (math.floor(a/b)*b)
end
