-- Register trigger on both high and low level.
function regIoTrig(pin)
  do
    gpio.mode(pin, gpio.INT)
    local function pinCallback(level)
      level = gpio.read(pin)
      if level == gpio.HIGH then
        onTrigHigh(pin)
      else
        onTrigLow(pin)
      end
      lcd:print('D' .. pin .. ':' .. level, 0, 4 + (pin - 1) * 5)
      gpio.trig(pin, level == gpio.HIGH and 'down' or 'up')
    end
    gpio.trig(pin, gpio.read(pin) == gpio.HIGH and 'down' or 'up', pinCallback)
  end
end

regIoTrig(1)
regIoTrig(2)

trigHighTimes = {}
trigLowTimes = {}
ignoreOneTrigUntil = nil

-- Check is whether entering/leaving the room on high level.
function onTrigHigh(pin)
  trigHighTimes[pin] = tmr.now()
  trigLowTimes[pin] = nil

  local pinHighTimeSpan = trigHighTimes[pin % 2 + 1] and
      (trigHighTimes[pin] - trigHighTimes[pin % 2 + 1]) or nil
  if pinHighTimeSpan then
    log('high', pin, math.floor(pinHighTimeSpan / usPerMs))
  else
    log('high', pin)
  end

  if (trigHighTimes[1] and trigHighTimes[2])
      and math.abs(trigHighTimes[1] - trigHighTimes[2]) < 10 * usPerSecond then

    if needIgnoreTrig() then
      return
    end

    if trigHighTimes[1] < trigHighTimes[2] then
      roomOff()
    end
    if trigHighTimes[1] > trigHighTimes[2] then
      roomOn()
      trigLowTimes[1], trigLowTimes[2] = nil, nil
    end
    trigHighTimes[1], trigHighTimes[2] = nil, nil
  end
end

function onTrigLow(pin)
  log('low ', pin)
  trigHighTimes[1], trigHighTimes[2] = nil, nil
end

-- If someone others entering your room and you don't want esp turn off light for him, then call this function immediately.
function ignoreOneTrig(passSecond)
  ignoreOneTrigUntil = tmr.now() + (passSecond or 10) * usPerSecond
end

function needIgnoreTrig()
  local timeRemain = (ignoreOneTrigUntil or 0) - tmr.now()
  if timeRemain > 0 then
    ignoreOneTrigUntil, trigHighTimes[1], trigHighTimes[2],
    trigLowTimes[1], trigLowTimes[2] = nil, nil, nil, nil, nil
    log('Trig ignored, remain ' .. math.floor(timeRemain / 1000) .. 'ms.')
    return true
  end
  return false
end
