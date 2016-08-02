--provides some basic boot up sleep so you can update scripts
local cnt = 0
tmr.alarm(0, 1000, 1, function() 
   if (cnt < 15) then 
      print("waiting to run...")
      cnt = cnt + 1 
   else 
      tmr.stop(0);
      print("Running user script...")
      dofile ("dht11_thinkspeak.lua")
   end 
end)