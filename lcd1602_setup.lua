i2c.setup(0, 3, 4, i2c.SLOW)

-- Don't declare this function in LFS to prevent lcd1602 display garbled.
i2cWrite = function(self, b, mode)
  local i2c = i2c
  i2c.start(0)
  i2c.address(0, self._adr, i2c.TRANSMITTER)
  local bh = bit.band(b, 0xF0) + self._ctl + mode
  local bl = bit.lshift(bit.band(b, 0x0F), 4) + self._ctl + mode
  i2c.write(0, bh + 4, bh, bl + 4, bl)
  i2c.stop(0)
end
