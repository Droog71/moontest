--[[
    Moon Habitat Simulator
    Version: 1.0.6
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local text_list = {"\n\nYou are a prospector on a newly discovered moon.\n" ..
    "Your habitat has been constructed and your mining systems are operational.\n\n" ..
    "As a resident engineer, you must manage life support systems and\n" ..
    "mining equipment to ensure your income is adequate for survival.\n\n" ..
    "Expenses are deducted from your balance at regular intervals and\n" ..
    "are increased based on the total amount of ore you have mined.",

    "\n\n\n\n        This is your nuclear reactor, the power source for your habitat.\n" ..
    "        Left click the reactor to turn it on or off.\n\n        If the reactor is overloaded" ..
    " or you turn it off,\n        all of your equipment will have to be manually restarted.",

    "\n\n\n\nThis is your gravity generator. Without it, other machines become unstable.\n" ..
    "Left click the generator to turn it on or off. Right click to adjust the intensity.\n\n" ..
    "The gravity gravity generator's power consumption is dependent on the intensity.\n\n" ..
    "Lower values allow you to divert power elsewhere.\nHigher values provide more stability.\n" ..
    "Any value over 100 will also cause your machines to become unstable.",

    "\n\n\nThe formula used to calculate gravity's effect on machine stability is below.\n\n" ..
    "if gravity_on() and generated_gravity > 100 then   --intensity is too high\n" ..
    "       stability = 95 - (generated_gravity - 100)    --stability is reduced\n" ..
    "else\n" ..
    "       stability = 5 + (gravity_on() * (generated_gravity - 10))   --stability is increased\n" ..
    "end\n" ..
    "if stability > 95 then stability = 95 end    --stability limit\n" ..
    "if math.random(0, 100) > stability then something_fails() end    --failures occur",

    "\n\n\n\nThis is your oxygen generator. Without it, you cannot survive. Left click the\n" ..
    "generator to turn it on or off. Right click the generator to adjust it's output.\n\n" ..
    "The oxygen generator's power consumption is dependent on it's output.\n\n" ..
    "Lower values allow you to divert power elsewhere.\nHigher values provide more safety.\n" ..
    "Extremely high oxygen output settings can be dangerous.",

    "\n\n\n\nThis is your hvac system. Without it, you cannot survive. Left click the\n" ..
    "box on top to turn it on or off. Right click the box to adjust the thermostat.\n\n" ..
    "The hvac system's power consumption is dependent on the thermostat setting.\n\n" ..
    "Lower values allow you to divert power elsewhere.\nHigher values provide more safety.\n" ..
    "Extremely high thermostat settings can be dangerous.",

    "\n\n\n\nThis is your mining drill, your primary source of passive income.\n" ..
    "Left click the drill to turn it on or off. Right click to adjust it's speed.\n" ..
    "The drill's power consumption is dependent on the speed setting.\n\nBe mindful " ..
    "of your coolant pump speed or you may experience\n" ..
    "greater fluctuations in power consumption and may overload your reactor.",

    "\n\n\n\n\nThis is your coolant system. This prevents the mining drill from overloading the reactor.\n" ..
    "Left click the coolant pump to turn it on or off. Right click the pump to adjust it's speed.\n" ..
    "The coolant system's power consumption is dependent on the pump speed.\n" ..
    "The speed setting should be set with reference to the drill's speed setting.",

    "\n\n\nThe formula used to calculate the pump's effect on the drill is below.\n\n" ..
    "resistance = math.random(drill_speed * 2, drill_speed * 3)   --the resistance\n" ..
    "digging = drill_speed + resistance   --the amount of ore mined\n" ..
    "cooling = pump_on() * pump_speed * 3   --cooling provided\n" ..
    "if cooling > resistance * 0.9 then cooling = resistance * 0.9    --cooling limit\n" ..
    "drill_power = digging - cooling    --the power consumption of the drill\n" ..
    "money = money + digging    --the amount of money earned from the ore",

    "\n\n\n\nThis is your space food vending machine. Without it, you cannot survive.\n" ..
    "Restocking fees are a part of your regular expenses. Left click to buy food.\n" ..
    "Left click with the food in your hand to eat it. Space food replenishes your\n" ..
    "hunger if you are hungry and heals you if you are full.",

    "\n\n\n\nThese are your sleeping quarters. Without sleep, you will eventually die.\n" ..
    "Keep an eye on your energy level and when you need to sleep, left click the\n" ..
    "middle of the bottom bunk on one of the bunk beds. You will sleep until your\n" ..
    "energy is full then you will be moved to the lobby of the space habitat.",
      
    "\n\nThis is your research station. Here you can exchange items for money,\n" ..
    "increase your research level and unlock new items in the shop.\n\n" ..
    "Left click the research station with organic matter or research data to\n" ..
    "process the item. Research data can be gathered using research probes outside of\n" .. 
    "the habitat. A power source must be placed within 10 meters of the probe.\n" .. 
    "The farther probes are from the habitat and each other, the more data they will collect.\n\n" .. 
    "You can monitor the status of all your generators in the power window accessed\n" .. 
    "from your inventory. Work lights are also powered by generators and can be helpful when\n" ..
    "setting up research probes. Research and REM extraction can be automated with robots.",
    
    "\n\n\n\nThis is an auto-restart circuit. A sensor is placed directly next to the machine.\n" ..
    "A relay is placed directly next to the sensor. From there, wire is used to connect\n" .. 
    "the relay to a microcontroller programmed to operate as a NOT gate.\n" ..
    "Wire is then ran through a delayer back to the machine. This will restart a machine\n" ..
    "if it fails but will not do so after a power outage.",
    
    "\n\n\n\nThis circuit is optimized to use as little material as possible.\n" ..
    "A sensor is placed directly next to the machine.\n" ..
    "A relay is placed directly next to the sensor.\n" ..
    "Wire is used to connect the relay to the microcontroller.\n" ..
    "The microcontroller is directly connected to a delayer and the delayer\n" ..
    "leads immediately back to the machine without using any wire.",
    
    "\n\n\n\nThese are reactor boosters. Boosters increase reactor output by 100 each.\n" ..
    "They must be placed within 20 meters of the reactor and cannot be ran continuously.\n" .. 
    "After 10 seconds, they will overload the reactor. When disabled, the booster has a\n" .. 
    "10 second cooldown. Boosters can be operated by pulsing logic circuits or 'clocks'.\n" ..
    "The best way to configure boosters is to stagger circuits so one group is on while\n" .. 
    "the other is off. This way your reactor output has a steady value.",
    
    "\n\n\n\n\n\nThis is the habitat computer. Here you can view the result of the current\n" ..
    "drill and coolant pump settings as well as gravity's affect on machine stability."
}
local index = 1
local text = text_list[1]
local border = "form_border.png"
local image = "readme__" .. index .. ".png"

--defines the help formspec
function manual_formspec(player)
    local formspec = {
        "size[30,22]",
        "bgcolor[#2d2d2d;false]",
        "image[-1,-1;40,28;"..border.."]",
        "image[5.5,0.5;24,13.5;"..image.."]",
        "label[8.5,12;"..text.."]",
        "button[11.5,18;3,0.75;<-;<-]",
        "button[15.5,18;3,0.75;->;->]",
        "button[13.5,20;3,0.75;Back;Back]"
    }
    return formspec
end

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local manual_fs = manual_formspec(player)
    local current_fs = player:get_inventory_formspec()
    if current_fs == table.concat(manual_fs, "") then
        for key, val in pairs(fields) do
            if key == "Back" then
                local formspec = inventory_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "->" then
                if index < 16 then
                      index = index + 1
                else
                    index = 1
                end
                text = text_list[index]
                image = "readme__" .. index .. ".png"
                local formspec = manual_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "<-" then
                if index > 1 then
                      index = index - 1
                else
                    index = 16
                end
                text = text_list[index]
                image = "readme__" .. index .. ".png"
                local formspec = manual_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            end
        end
    end
end)