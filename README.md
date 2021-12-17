Moontest: _Moon Habitat Simulator_
==================================
<pre>
<h1>Introduction</h1>
You are a prospector on a newly discovered moon.
Your habitat has been constructed and your mining systems are operational.

As a resident engineer, you must manage life support systems and
mining equipment to ensure your income is adequate for survival.

Expenses are deducted from your balance at regular intervals.
The amount deducted increases as time goes on, increasing the
difficulty of the game the longer you play.

You can win the game by earning $30,000 and lose if you reach $10,000 in debt.
These limits can be removed with the /unlimited console command.
You must be granted server privileges to use this command, (ie: /grantme server)

Moontest is playable in both single player and multiplayer game modes.

<h1>Gameplay</h1>
<img src="https://i.imgur.com/ISomiAN.png" alt="Moontest" width="427" height="240">
This is your <b>nuclear reactor</b>, the power source for your habitat.
Left click the reactor to turn it on or off. If the reactor is overloaded
or you turn it off, all of your equipment will have to be manually restarted.


<img src="https://i.imgur.com/AVnMmdr.png" alt="Moontest" width="427" height="240">
This is your <b>gravity generator</b>. Without it, other machines become unstable.
Left click the generator to turn it on or off. Right click to adjust the intensity.
The gravity gravity generator's power consumption is dependent on the intensity.
Lower values allow you to divert power elsewhere. Higher values provide more stability.
Any value over 100 will also cause your machines to become unstable.

The formula used to calculate gravity's effect on machine stability is below.

<b>if gravity_on() and generated_gravity > 100 then</b> <i>--intensity is too high</i>
   <b>stability = 92 - (generated_gravity - 100)</b> <i>--stability is reduced</i>
<b>else</b>
   <b>stability = 8 + (gravity_on() * (generated_gravity - 16))</b> <i>--stability is increased</i>
<b>end</b>
<b>if stability > 92 then stability = 92 end</b> <i>--stability limit</i>
<b>if math.random(0, 100) > stability then something_fails() end</b> <i>--failures occur</i>


<img src="https://i.imgur.com/yYaS4Pk.png" alt="Moontest" width="427" height="240">
This is your <b>oxygen generator</b>. Without it, you cannot survive. Left click the
generator to turn it on or off. Right click the generator to adjust it's output.
The oxygen generator's power consumption is dependent on it's output.
Lower values allow you to divert power elsewhere. Higher values provide more safety.
Extremely high oxygen output settings can be dangerous.


<img src="https://i.imgur.com/I25ZDqd.png" alt="Moontest" width="427" height="240">
This is your <b>hvac system</b>. Without it, you cannot survive. Left click the
box on top to turn it on or off. Right click the box to adjust the thermostat.
The hvac system's power consumption is dependent on the thermostat setting.
Lower values allow you to divert power elsewhere. Higher values provide more safety.
Extremely high thermostat settings can be dangerous.


<img src="https://i.imgur.com/gZ95JqW.png" alt="Moontest" width="427" height="240">
This is your <b>mining drill</b>; your primary source of passive income.
Left click the drill to turn it on or off. Right click to adjust it's speed.
The drill's power consumption is dependent on the speed setting. Be careful
about increasing this without adjusting the speed of your coolant pump.
If not, you will experience greater fluctuations in power consumption and
may overload your reactor.


<img src="https://i.imgur.com/6VF6ktQ.png" alt="Moontest" width="427" height="240">
This is your <b>coolant system</b>. This prevents the mining drill from overloading the reactor.
Left click the coolant pump to turn it on or off. Right click the pump to adjust it's speed.
The coolant system's power consumption is dependent on the pump speed.
The speed setting should be set with reference to the drill's speed setting.

The formula used to calculate the pump's effect on the drill is below.

<b>resistance = math.random(drill_speed * 2, drill_speed * 3)</b> <i>--the resistance</i>
<b>digging = drill_speed + resistance</b> <i>--the amount of ore mined</i>
<b>cooling = pump_is_on * pump_speed * 3</b> <i>--cooling provided</i>
<b>if cooling > resistance * 0.9 then cooling = resistance * 0.9 end</b> <i>--cooling limit</i>
<b>drill_power = digging - cooling</b> <i>--the power consumption of the drill</i>
<b>money = money + digging</b> <i>--the amount of money earned from the ore</i>


<img src="https://i.imgur.com/6Llfvtm.png" alt="Moontest" width="427" height="240">
This is your <b>space food vending machine</b>. Without it, you cannot survive.
Restocking fees are a part of your regular expenses. Left click to buy food.
Left click with the food in your hand to eat it. Space food replenishes your
hunger if you are hungry and heals you if you are full.


<img src="https://i.imgur.com/iobKYQy.png" alt="Moontest" width="427" height="240">
These are your <b>sleeping quarters</b>. Without sleep, you will eventually die.
Keep an eye on your energy level and when you need to sleep, left click the
middle of the bottom bunk on one of the bunk beds. You will sleep until your
energy is full then you will be moved to the lobby of the space habitat.


<img src="https://i.imgur.com/VhMXVYq.png" alt="Moontest" width="427" height="240">
This is your <b>research station</b>. Here, you can conduct research on organic matter
'harvested' on the moon's surface. Organic matter is worth $10 each early in the game.
This value increase each time you process research data. The limit is $50.
To conduct research, left click the research station while holding the organic matter.
</pre>
