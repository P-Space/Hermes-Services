print('*** INIT ***')
--set station mode
wifi.setmode(wifi.STATION)
print('MODE: ', wifi.getmode())
print('MAC : ', wifi.sta.getmac())
print('CHIP: ', node.chipid())
print('HEAP: ', node.heap())
-- wifi config
wifi.sta.config("SSID", "PASSWORD")
tmr.alarm(0, 5000, 0, function()
    print('IP  : ', wifi.sta.getip())
    print("*** APPLICATION ***")
    dofile("application.lua")
end)
