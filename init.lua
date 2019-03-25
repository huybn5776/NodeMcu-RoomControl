dofile("_init.lua") -- For LFS
if dofile('panicLoopGuard.lua') then
  return -- Stop loading
end

config = dofile('config.lua')
dofile('utils.lua')
dofile('wifiConn.lua')
dofile('lcd1602_setup.lua')
lcd = dofile('lcd1602.lua')()
lcd:showBootText()

print('heap remain = ' .. node.heap())

function afterWifiConnected()
  dofile('roomControl.lua')
  dofile('gpioTrig.lua')
  dofile('ide.lua')
end
