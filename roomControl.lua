function roomOn()
  httpGet(config.roomOnUrl, 'roomOn')
end

function roomOff()
  httpGet(config.roomOffUrl, 'roomOff')
end

function getSp3State(callback)
  httpGet(config.sp3StateUrl, 'get SP3 state', function(data)
    local on = string.find(data, '"on_off_status":1') and true or false
    print('on', on)
    callback(on)
  end)
end
