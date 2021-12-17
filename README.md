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
This is your **nuclear reactor**, the power source for your habitat.</br>
Left click the reactor to turn it on or off. If the reactor is overloaded</br>
or you turn it off, all of your equipment will have to be manually restarted.</br>
</br>
</br>
<img src="https://i.imgur.com/Nhk7dFc.png"></br>
This is your **gravity generator**. Without it, other machines become unstable.</br>
Left click the generator to turn it on or off. Right click to adjust the intensity.</br>
The gravity gravity generator's power consumption is dependent on the intensity.</br>
Lower values allow you to divert power elsewhere. Higher values provide more stability.</br>
Any value over 100 will also cause your machines to become unstable.</br></br>
</br>
The formula used to calculate gravity's effect on machine stability is below.</br></br>
</br>
**if gravity_on() and generated_gravity > 100 then** *--intensity is too high*</br>
   **stability = 92 - (generated_gravity - 100)** *--stability is reduced*</br>
**else**</br>
   **stability = 8 + (gravity_on() * (generated_gravity - 16))** *--stability is increased*</br>
**end**</br>
**if stability > 92 then stability = 92 end** *--stability limit*</br>
**if math.random(0, 100) > stability then something_fails() end** *--failures occur*</br>
</br>
</br>
<img src="https://i.imgur.com/DKEuwe0.png"></br>
This is your **oxygen generator**. Without it, you cannot survive. Left click the</br>
generator to turn it on or off. Right click the generator to adjust it's output.</br>
The oxygen generator's power consumption is dependent on it's output.</br>
Lower values allow you to divert power elsewhere. Higher values provide more safety.</br>
Extremely high oxygen output settings can be dangerous.</br>
</br>
</br>
<img src="https://i.imgur.com/w9zg6Wa.png"></br>
This is your **hvac system**. Without it, you cannot survive. Left click the</br>
box on top to turn it on or off. Right click the box to adjust the thermostat.</br>
The hvac system's power consumption is dependent on the thermostat setting.</br>
Lower values allow you to divert power elsewhere. Higher values provide more safety.</br>
Extremely high thermostat settings can be dangerous.</br>
</br>
</br>
<img src="https://i.imgur.com/86vFPBM.png"></br>
This is your **mining drill**; your primary source of passive income.</br>
Left click the drill to turn it on or off. Right click to adjust it's speed.</br>
The drill's power consumption is dependent on the speed setting. Be careful</br>
about increasing this without adjusting the speed of your coolant pump.</br>
If not, you will experience greater fluctuations in power consumption and</br>
may overload your reactor.</br>
</br>
</br>
<img src="https://i.imgur.com/yjbRGCg.png"></br>
This is your **coolant system**. This prevents the mining drill from overloading the reactor.</br>
Left click the coolant pump to turn it on or off. Right click the pump to adjust it's speed.</br>
The coolant system's power consumption is dependent on the pump speed.</br>
The speed setting should be set with reference to the drill's speed setting.</br>
</br>
The formula used to calculate the pump's effect on the drill is below.</br>
</br>
**resistance = math.random(drill_speed * 2, drill_speed * 3)** *--the resistance*</br>
**digging = drill_speed + resistance** *--the amount of ore mined*</br>
**cooling = pump_is_on * pump_speed * 3** *--cooling provided*</br>
**if cooling > resistance * 0.9 then cooling = resistance * 0.9 end** *--cooling limit*</br>
**drill_power = digging - cooling** *--the power consumption of the drill*</br>
**money = money + digging** *--the amount of money earned from the ore*</br>
</br>
</br>
<img src="https://i.imgur.com/CyTmGYz.png"></br>
This is your **space food vending machine**. Without it, you cannot survive.</br>
Restocking fees are a part of your regular expenses. Left click to buy food.</br>
Left click with the food in your hand to eat it. Space food replenishes your</br>
hunger if you are hungry and heals you if you are full.</br>
</br>
</br>
<img src="https://i.imgur.com/lyr1Sxg.png"></br>
These are your **sleeping quarters**. Without sleep, you will eventually die.</br>
Keep an eye on your energy level and when you need to sleep, left click the</br>
middle of the bottom bunk on one of the bunk beds. You will sleep until your</br>
energy is full then you will be moved to the lobby of the space habitat.</br>
</br>
</br>
<img src="https://i.imgur.com/mo5QWX0.png"></br>
This is your **research station**. Here, you can conduct research on organic matter</br>
'harvested' on the moon's surface. Organic matter is worth $10 each early in the game.</br>
This value increase each time you process research data. The limit is $50.</br>
To conduct research, left click the research station while holding the organic matter.