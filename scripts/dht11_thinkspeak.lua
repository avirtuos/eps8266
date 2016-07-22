sensor_pin = 1

function publish(temperature, humidity)

    if temperature == -1000 or humidity == -1000 then
        print("Invalid data")
        return
    end
    
    url = string.format("http://api.thingspeak.com/update?api_key=API_KEY&field1=%d&field2=%d",
    temperature, humidity)
    http.get(url, nil, function(code, data)
        if (code < 0) then
          print("HTTP request failed")
        else
          print("Success...", code, data)
        end
      end)
end



local cnt = 0
local temperature = -1000
local humidity = -1000
tmr.alarm(0, 1000, 1, function() 

    --We loop 12 times and read the sensor because the sensor can give weird results initially, seems to have a 'warm up issue'
    status, temp, humi, temp_dec, humi_dec = dht.read(sensor_pin)
    if status == dht.OK then
        print(string.format("%d T:%d;H:%d\r\n",
              cnt,
              temp,
              humi
        ))

        temperature = temp
        humidity = humi
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end

    if(cnt == 8) then
        publish(temperature, humidity)
    end
    
    cnt = cnt + 1
    if(cnt > 12) then
         tmr.stop(0);
         print("Script done, Going to deep sleep for "..(300).." seconds")
         node.dsleep(300000000)   
    end
end)

