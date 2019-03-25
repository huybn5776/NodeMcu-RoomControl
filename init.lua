config = dofile('config.lua')
dofile('utils.lua')
dofile('wifiConn.lua')
lcd = dofile('lcd1602.lua')()
lcd:showBootText()

print('heap remain = ' .. node.heap())

function afterWifiConnected()
  dofile('roomControl.lua')
  dofile('gpioTrig.lua')
end
