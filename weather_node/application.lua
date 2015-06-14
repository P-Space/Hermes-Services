-- Create telnet server for remote CLI
tsrv=net.createServer(net.TCP,180)
tsrv:listen(2323,function(c)
  function s_output(str)
    if(c~=nil)
      then c:send(str)
    end
  end
  node.output(s_output, 0)
  c:on("receive",function(c,l)
    node.input(l)
  end)
  c:on("disconnection",function(c)
    node.output(nil)
  end)
  print("Welcome to nodemcu.\n>")
end)

dht = require("dht_lib")
mc = mqtt.Client("weathernode", 120, nil, nil)


function mqttopen()
  dht.read22(2) -- Sensor is on Pin 2
  mc:connect("192.168.1.5", 1883, 0, sendtemp) -- mosquitto server
end

function sendtemp()
  local temp = dht.getTemperature()
  if temp ~= nil then
    mc:publish("room1/temperature", temp / 10.0, 0, 0, sendhum)
  else
    mc:close()
  end
end

function sendhum()
  local hum = dht.getHumidity()
  if hum ~= nil then
    mc:publish("room1/humidity", hum / 10.0, 0 ,0 , mqttclose)
  else
    mc:close()
  end
end

function mqttclose()
  mc:close()
end

tmr.alarm(0, 60000, 1, mqttopen)
