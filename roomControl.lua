function roomOn()
  httpGet(config.roomOnUrl, 'roomOn')
end

function roomOff()
  httpGet(config.roomOffUrl, 'roomOff')
end
