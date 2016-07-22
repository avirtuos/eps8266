# EPS8266

The EPS8266 is an excellent lower power, low cost wifi module capable of acting as both an AP and a Station. It also has sufficient capability to run Lua scripts with nearly a dozen GPIO ports operating at 3.3v. 

All of the examples in this repo were testing using the NodeMCU found on Amazon, buy it here <a href='https://www.amazon.com/gp/product/B010O1G1ES'>HiLetgo NodeMCU Development Board</a>

# Scripts


## Init.lua

This basic script does two things:

1. It setups up a WIFI AP.
2. It connects to your existing wifi network.

## dht11_thinkspeak.lua

This script uses a <a href='https://www.amazon.com/uxcell-Sensitivity-Temperature-Humidity-20-90%25RH/dp/B00BXWUWRA'>DHT11 Temperature and Humidity Sensory</a> to read temperature and humidity and then post the results to a ThingSpeak Channel that is then visible as a graph.

You can sign up for a free ThingSpeak account at <a href='https://thingspeak.com'> https://thingspeak.com </a> or view some of my channels at <a href='https://thingspeak.com/channels/138103'> NodeMCU Channel </a>.

This script uses a couple special features of the EPS8266, namely analog read via GPIO pin D1 and then also the ability to deep sleep the chip and wake up again. This requires that pin D0 be wired to the rst pin so that when the sleep timer expires and we set D0 high it will trigger a reset that then restarts the chip and runs our init.lua followed by dht11_thinkspeak.lua.

In my testing I ran these scrupts on the above mentioned NodeMCU using a 500Mah 3.3v Lipo for X days. (I'll update this once my test actually completes.)