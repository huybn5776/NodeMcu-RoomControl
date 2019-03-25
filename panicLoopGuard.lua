------------------------------------------------------------------------------
-- Preventing bootloop if restart within 1 second.
-- You will have as least one second to do something wile PANIC loop happen.
-- file.remove('init.lua')
------------------------------------------------------------------------------

if file.open('booting', "r") then
  print('PanicLoopGuard: Last boot fail, stopping ')
  file.remove('booting', "w")
  return true
end

file.open('booting', "w")
file.write('')
file.close()
tmr.alarm(1, 1000, tmr.ALARM_SINGLE, function()
  file.remove('booting', "w")
end)
return false
