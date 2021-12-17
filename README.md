Moontest: _Moon Habitat Simulator_
==================================
<h2>Introduction</h2>
You are a prospector on a newly discovered moon.</br>
Your habitat has been constructed and your mining systems are operational.</br>
</br>
As a resident engineer, you must manage life support systems and</br>
mining equipment to ensure your income is adequate for survival.</br>
</br>
Expenses are deducted from your balance at regular intervals.</br>
The amount deducted increases as time goes on, increasing the</br>
difficulty of the game the longer you play.</br>
</br>
You can win the game by earning $30,000 and lose if you reach $10,000 in debt.</br>
These limits can be removed with the /unlimited console command.</br>
You must be granted server privileges to use this command, (ie: /grantme server)</br>
</br>
Moontest is playable in both single player and multiplayer game modes.</br>
</br>
<h2>Gameplay</h2>
<img src="https://i.imgur.com/C8vUbjb.png"></br>
This is your __nuclear reactor__, the power source for your habitat.</br>
Left click the reactor to turn it on or off. If the reactor is overloaded</br>
or you turn it off, all of your equipment will have to be manually restarted.</br>
</br>
</br>
<img src="https://i.imgur.com/Nhk7dFc.png"></br>
This is your __gravity generator__. Without it, other machines become unstable.</br>
Left click the generator to turn it on or off. Right click to adjust the intensity.</br>
The gravity gravity generator's power consumption is dependent on the intensity.</br>
Lower values allow you to divert power elsewhere. Higher values provide more stability.</br>
Any value over 100 will also cause your machines to become unstable.</br></br>
</br>
The formula used to calculate gravity's effect on machine stability is below.</br></br>
</br>
__if gravity_on() and generated_gravity > 100 then__ _--intensity is too high_</br>
   __stability = 92 - (generated_gravity - 100)__ _--stability is reduced_</br>
__else__</br>
   __stability = 8 + (gravity_on() _ (generated_gravity - 16))__ _--stability is increased_</br>
__end__</br>
__if stability > 92 then stability = 92 end__ _--stability limit_</br>
__if math.random(0, 100) > stability then something_fails() end__ _--failures occur_</br>
</br>
</br>
<img src="https://i.imgur.com/DKEuwe0.png"></br>
This is your __oxygen generator__. Without it, you cannot survive. Left click the</br>
generator to turn it on or off. Right click the generator to adjust it's output.</br>
The oxygen generator's power consumption is dependent on it's output.</br>
Lower values allow you to divert power elsewhere. Higher values provide more safety.</br>
Extremely high oxygen output settings can be dangerous.</br>
</br>
</br>
<img src="https://i.imgur.com/w9zg6Wa.png"></br>
This is your __hvac system__. Without it, you cannot survive. Left click the</br>
box on top to turn it on or off. Right click the box to adjust the thermostat.</br>
The hvac system's power consumption is dependent on the thermostat setting.</br>
Lower values allow you to divert power elsewhere. Higher values provide more safety.</br>
Extremely high thermostat settings can be dangerous.</br>
</br>
</br>
<img src="https://i.imgur.com/86vFPBM.png"></br>
This is your __mining drill__; your primary source of passive income.</br>
Left click the drill to turn it on or off. Right click to adjust it's speed.</br>
The drill's power consumption is dependent on the speed setting. Be careful</br>
about increasing this without adjusting the speed of your coolant pump.</br>
If not, you will experience greater fluctuations in power consumption and</br>
may overload your reactor.</br>
</br>
</br>
<img src="https://i.imgur.com/yjbRGCg.png"></br>
This is your __coolant system__. This prevents the mining drill from overloading the reactor.</br>
Left click the coolant pump to turn it on or off. Right click the pump to adjust it's speed.</br>
The coolant system's power consumption is dependent on the pump speed.</br>
The speed setting should be set with reference to the drill's speed setting.</br>
</br>
The formula used to calculate the pump's effect on the drill is below.</br>
</br>
__resistance = math.random(drill_speed _ 2, drill_speed _ 3)__ _--the resistance_</br>
__digging = drill_speed + resistance__ _--the amount of ore mined_</br>
__cooling = pump_is_on _ pump_speed _ 3__ _--cooling provided_</br>
__if cooling > resistance _ 0.9 then cooling = resistance _ 0.9 end__ _--cooling limit_</br>
__drill_power = digging - cooling__ _--the power consumption of the drill_</br>
__money = money + digging__ _--the amount of money earned from the ore_</br>
</br>
</br>
<img src="https://i.imgur.com/CyTmGYz.png"></br>
This is your __space food vending machine__. Without it, you cannot survive.</br>
Restocking fees are a part of your regular expenses. Left click to buy food.</br>
Left click with the food in your hand to eat it. Space food replenishes your</br>
hunger if you are hungry and heals you if you are full.</br>
</br>
</br>
<img src="https://i.imgur.com/lyr1Sxg.png"></br>
These are your __sleeping quarters__. Without sleep, you will eventually die.</br>
Keep an eye on your energy level and when you need to sleep, left click the</br>
middle of the bottom bunk on one of the bunk beds. You will sleep until your</br>
energy is full then you will be moved to the lobby of the space habitat.</br>
</br>
</br>
<img src="https://i.imgur.com/mo5QWX0.png"></br>
This is your __research station__. Here, you can conduct research on organic matter</br>
'harvested' on the moon's surface. Organic matter is worth $10 each early in the game.</br>
This value increase each time you process research data. The limit is $50.</br>
To conduct research, left click the research station while holding the organic matter.