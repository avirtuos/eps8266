sensor_pin = 1

temperature = -1000
humidity = -1000

status, temp, humi, temp_dec, humi_dec = dht.read(sensor_pin)
if status == dht.OK then
    temp = (temp * (9/5)) + 32;
    print(string.format("T%f;H:%f\r\n",temp,humi))
    temperature = temp
    humidity = humi
elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
end

wifi.sta.config("wifi_ssd","wifi_pwd")
wifi.sta.connect()

local count = 0
local inProgress = nil
tmr.alarm(0, 1000, 1, function() 
    count = count + 1
    if (wifi.sta.getip() == nil) and (count < 30) then 
        print("Waiting on IP...")
    elseif(wifi.sta.getip() ~= nil and inProgress == nil) then
        url = string.format("http://api.thingspeak.com/update?api_key=API_KEY&field1=%f&field2=%f",temperature, humidity)
        print(url)
        inProgress = 1
        http.get(url, nil, function(code, data)
            if (code < 0) then
                print("HTTP request failed")
                inProgress = -1
            else
                print("Success...", code, data)
                inProgress = -1
            end
        end)
    elseif(wifi.sta.getip() ~= nil and inProgress == 1 and count < 30) then
        print("Waiting on HTTP call to complete")
    elseif(wifi.sta.getip() ~= nil and inProgress == -1) then
        tmr.stop(0)
        print("Script done, Going to deep sleep for "..(300).." seconds")
        node.dsleep(300000000)   
    else
        tmr.stop(0)
        print("Script failed, Going to deep sleep for "..(300).." seconds")
        node.dsleep(300000000)   
    end
end)

