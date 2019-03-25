ledPin = 4
usPerMs = 1000
usPerSecond = 1000 * usPerMs

function led(on)
  gpio.write(ledPin, on == 1 and gpio.LOW or gpio.HIGH)
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
