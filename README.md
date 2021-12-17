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
<img src="https://i.imgur.com/C8vUbjb.png">
This is your <b>nuclear reactor</b>, the power source for your habitat.</br>
Left click the reactor to turn it on or off. If the reactor is overloaded</br>
or you turn it off, all of your equipment will have to be manually restarted.</br>
</br>
</br>
<img src="https://i.imgur.com/Nhk7dFc.png">
This is your <b>gravity generator</b>. Without it, other machines become unstable.</br>
Left click the generator to turn it on or off. Right click to adjust the intensity.</br>
The gravity gravity generator's power consumption is dependent on the intensity.</br>
Lower values allow you to divert power elsewhere. Higher values provide more stability.</br>
Any value over 100 will also cause your machines to become unstable.</br></br>
</br>
The formula used to calculate gravity's effect on machine stability is below.</br></br>
</br>
<b>if gravity_on() and generated_gravity > 100 then</b> <i>--intensity is too high</i></br>
   <b>stability = 92 - (generated_gravity - 100)</b> <i>--stability is reduced</i></br>
<b>else</b></br>
   <b>stability = 8 + (gravity_on() * (generated_gravity - 16))</b> <i>--stability is increased</i></br>
<b>end</b></br>
<b>if stability > 92 then stability = 92 end</b> <i>--stability limit</i></br>
<b>if math.random(0, 100) > stability then something_fails() end</b> <i>--failures occur</i></br>
</br>
</br>
<img src="https://i.imgur.com/DKEuwe0.png">
This is your <b>oxygen generator</b>. Without it, you cannot survive. Left click the</br>
generator to turn it on or off. Right click the generator to adjust it's output.</br>
The oxygen generator's power consumption is dependent on it's output.</br>
Lower values allow you to divert power elsewhere. Higher values provide more safety.</br>
Extremely high oxygen output settings can be dangerous.</br>
</br>
</br>
<img src="https://i.imgur.com/w9zg6Wa.png">
This is your <b>hvac system</b>. Without it, you cannot survive. Left click the</br>
box on top to turn it on or off. Right click the box to adjust the thermostat.</br>
The hvac system's power consumption is dependent on the thermostat setting.</br>
Lower values allow you to divert power elsewhere. Higher values provide more safety.</br>
Extremely high thermostat settings can be dangerous.</br>
</br>
</br>
<img src="https://i.imgur.com/86vFPBM.png">
This is your <b>mining drill</b>; your primary source of passive income.</br>
Left click the drill to turn it on or off. Right click to adjust it's speed.</br>
The drill's power consumption is dependent on the speed setting. Be careful</br>
about increasing this without adjusting the speed of your coolant pump.</br>
If not, you will experience greater fluctuations in power consumption and</br>
may overload your reactor.</br>
</br>
</br>
<img src="https://i.imgur.com/yjbRGCg.png">
This is your <b>coolant system</b>. This prevents the mining drill from overloading the reactor.</br>
Left click the coolant pump to turn it on or off. Right click the pump to adjust it's speed.</br>
The coolant system's power consumption is dependent on the pump speed.</br>
The speed setting should be set with reference to the drill's speed setting.</br>
</br>
The formula used to calculate the pump's effect on the drill is below.</br>
</br>
<b>resistance = math.random(drill_speed * 2, drill_speed * 3)</b> <i>--the resistance</i></br>
<b>digging = drill_speed + resistance</b> <i>--the amount of ore mined</i></br>
<b>cooling = pump_is_on * pump_speed * 3</b> <i>--cooling provided</i></br>
<b>if cooling > resistance * 0.9 then cooling = resistance * 0.9 end</b> <i>--cooling limit</i></br>
<b>drill_power = digging - cooling</b> <i>--the power consumption of the drill</i></br>
<b>money = money + digging</b> <i>--the amount of money earned from the ore</i></br>
</br>
</br>
<img src="https://i.imgur.com/CyTmGYz.png">
This is your <b>space food vending machine</b>. Without it, you cannot survive.</br>
Restocking fees are a part of your regular expenses. Left click to buy food.</br>
Left click with the food in your hand to eat it. Space food replenishes your</br>
hunger if you are hungry and heals you if you are full.</br>
</br>
</br>
<img src="https://i.imgur.com/lyr1Sxg.png">
These are your <b>sleeping quarters</b>. Without sleep, you will eventually die.</br>
Keep an eye on your energy level and when you need to sleep, left click the</br>
middle of the bottom bunk on one of the bunk beds. You will sleep until your</br>
energy is full then you will be moved to the lobby of the space habitat.</br>
</br>
</br>
<img src="https://i.imgur.com/mo5QWX0.png">
This is your <b>research station</b>. Here, you can conduct research on organic matter</br>
'harvested' on the moon's surface. Organic matter is worth $10 each early in the game.</br>
This value increase each time you process research data. The limit is $50.</br>
To conduct research, left click the research station while holding the organic matter.