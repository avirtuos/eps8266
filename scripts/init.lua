print("Ready to start soft ap AND station")

wifi.setmode(wifi.STATIONAP)

local cfg={}
cfg.ssid="EPS8266_SSID";
cfg.pwd="EPS8266_PWD"
wifi.ap.config(cfg)
cfg={}
cfg.ip="192.168.2.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.2.1";
wifi.ap.setip(cfg);
dhcp_config ={}
dhcp_config.start = "192.168.2.100"
wifi.ap.dhcp.config(dhcp_config)
wifi.ap.dhcp.start()

    wifi.sta.config("YOUR_WIFI_SSID","YOUR_WIFI_PWD")
    wifi.sta.connect()
    
    local cnt = 0
    --gpio.mode(0,gpio.OUTPUT);
    tmr.alarm(0, 1000, 1, function() 
        if (wifi.sta.getip() == nil) and (cnt < 20) then 
            print("Trying Connect to Router, Waiting...")
            cnt = cnt + 1 
                 --if cnt%2==1 then gpio.write(0,gpio.LOW);
                 --else gpio.write(0,gpio.HIGH); end
        else 
            tmr.stop(0);
            print("Soft AP started")
            print("MAC:"..wifi.ap.getmac().."\r\nIP:"..wifi.ap.getip());
            print("IP:"..wifi.ap.getip());
            if (cnt < 20) then 
                print("Conected to Router\r\nMAC:"..wifi.sta.getmac().."\r\nIP:"..wifi.sta.getip())
                --script to run, here I'm using our thingspeak example
                dofile ("dht11_thinkspeak.lua")
            else 
                print("Conected to Router Timeout")
            end
            --gpio.write(0,gpio.LOW);
            cnt = nil;cfg=nil;str=nil;ssidTemp=nil;
            collectgarbage()
        end 
    end)

    
