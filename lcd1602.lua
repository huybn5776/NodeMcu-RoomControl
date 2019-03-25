------------------------------------------------------------------------------
-- Modify from https://github.com/dvv/nodemcu-thingies/blob/master/lcd1602.lua
------------------------------------------------------------------------------

local tmrId = 6
local tmrId2 = 5

local _offsets = { [0] = 0x80, 0xC0, 0x94, 0xD4 } -- 20x4

--[[
i2c.setup(0, 6, 7, i2c.SLOW)
i2cWrite = function(self, b, mode)
  i2c.start(0)
  i2c.address(0, self._adr, i2c.TRANSMITTER)
  local bh = bit.band(b, 0xF0) + self._ctl + mode
  local bl = bit.lshift(bit.band(b, 0x0F), 4) + self._ctl + mode
  i2c.write(0, bh + 4, bh, bl + 4, bl)
  i2c.stop(0)
end
]]--

-- Back light on/off.
local function light  (self, on)
  self._ctl = on and 0x08 or 0x00
  i2cWrite(self, 0x00, 0)
end

-- Clear screen.
local function clear (self)
  i2cWrite(self, 0x01, 0)
end

-- Return command to set cursor at row/col.
local function locate(_, row, col)
  return col + _offsets[row]
end

-- Define custom char 0-7.
-- NB: e.g. use "\003" in argument to .put to display custom char 3
local function define_char (self, index, bytes)
  i2cWrite(self, 0x40 + 8 * bit.band(index, 0x07), 0)
  for i = 1, #bytes do
    i2cWrite(self, bytes[i], 1)
  end
end

-- Write to lcd.
local function put(self, ...)
  for _, x in ipairs({ ... }) do
    -- number?
    if type(x) == "number" then
      -- direct command
      i2cWrite(self, x, 0)
      -- string?
    elseif type(x) == "string" then
      -- treat as data
      for i = 1, #x do
        i2cWrite(self, x:byte(i), 1)
      end
    end
    tmr.delay(800)
  end
end

-- Show a running string s of width cols at row/col.
-- Shift delay is _delay using timer, on completion spawn callback if any.
local function run (self, row, col, cols, s, _delay, timer, callback)
  _delay = _delay or 150
  tmr.stop(timer)
  local i = cols
  local runner = function()
    self:put(
        locate(self, row, (i >= 0 and i or 0) + col),
        s:sub(i >= 0 and 1 or 1 - i, cols - i),
        " "
    )
    if i == -#s then
      if type(callback) == "function" then
        tmr.stop(timer)
        callback(self)
      else
        i = cols
      end
    else
      i = i - 1
    end
  end
  tmr.alarm(timer, _delay, 1, runner)
end

bootTextDisplaying = false
local function checkBootText (self)
  if bootTextDisplaying == true then
    self:clear()
    bootTextDisplaying = false
  end
end

local function showBootText (self)
  local majorVer, minorVer, devVer = node.info()
  self:print("NodeMCU", 0, 4)
  self:print('Version ' .. majorVer .. '.' .. minorVer .. '.' .. devVer, 1)
  bootTextDisplaying = true
end

local function clearRow(self, row)
  self:put(lcd:locate(row, 0), "                ")
end

local function print(self, text, row, col)
  self:checkBootText()
  self:put(lcd:locate(row or 0, col or 0), text)
  self:lightOnAWhile()
end

-- Print an auto-clear info.
local function printInfo(self, text, timeout)
  self:print(text, 1)
  if timeout then
    tmr.alarm(tmrId2, timeout, tmr.ALARM_SINGLE, function()
      self:clearRow(1)
    end)
  end
end

local function lightOnAWhile(self)
  self:light(true)
  tmr.alarm(tmrId, 10000, tmr.ALARM_SINGLE, function()
    self:light(false)
  end)
end

-- start lcd
local function init(self)
  i2cWrite(self, 0x33, 0)
  i2cWrite(self, 0x32, 0)
  i2cWrite(self, 0x28, 0)
  i2cWrite(self, 0x0C, 0)
  i2cWrite(self, 0x06, 0)
  i2cWrite(self, 0x01, 0)
  i2cWrite(self, 0x02, 0)
end

-- Instance metatable.
local meta = {
  __index = {
    clear = clear,
    define_char = define_char,
    init = init,
    light = light,
    lightOnAWhile = lightOnAWhile,
    locate = locate,
    put = put,
    run = run,
    print = print,
    printInfo = printInfo,
    showBootText = showBootText,
    checkBootText = checkBootText,
    clearRow = clearRow,
  },
}

-- Create new LCD1602 instance.
return function(adr)
  local self = setmetatable({
    _adr = adr or 0x27,
    _ctl = 0x08,
  }, meta)
  self:init()
  return self
end
