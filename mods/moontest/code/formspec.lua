--[[
    Moon Habitat Simulator
    Version: 1.0.2
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local text_list = {"\n\nYou are a prospector on a newly discovered moon.\n" ..
    "Your habitat has been constructed and your mining systems are operational.\n" ..
    "As a resident engineer, you must manage life support systems and\n" ..
    "mining equipment to ensure your income is adequate for survival.\n\n" ..
    "Expenses are deducted from your balance at regular intervals.\n" ..
    "The amount deducted increases as time goes on, increasing the difficulty of the game.\n\n" ..
    "You can win the game by earning $30,000 and lose if you reach $10,000 in debt.\n" ..
    "These limits can be removed with the /unlimited console command.\n" ..
    "You must be granted server privileges to use this command, (ie: /grantme server)\n",

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
    "       stability = 92 - (generated_gravity - 100)    --stability is reduced\n" ..
    "else\n" ..
    "       stability = 8 + (gravity_on() * (generated_gravity - 16))   --stability is increased\n" ..
    "end\n" ..
    "if stability > 92 then stability = 92 end    --stability limit\n" ..
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
      
    "\n\n\n\nThis is your research station. Here, you can conduct research on organic matter\n" ..
    "'harvested' on the moon's surface. Organic matter is worth $10 each early in the game.\n" ..
    "This value increase each time you process research data. The limit is $50.\n" ..
    "To conduct research, left click the research station while holding the organic matter."
}

local index = 1
local text = text_list[1]
local image = "readme__" .. index .. ".png"
local background = "form_bg.png"
local border = "form_border.png"
local computer_drill = "computer_drill.png"
local computer_gravity = "computer_gravity.png"
local red = "red.png"
local green = "green.png"
local blue = "blue.png"

--defines the inventory formspec
function inventory_formspec(player)
    local formspec = {
        "size[8,7.5]",
        "bgcolor[#2d2d2d;false]",
        "list[current_player;main;0,3.5;8,4;]",
        "button[3,0.9;2,0.5;Help;Help]",
        "button[3,1.9;2,0.5;Shop;Shop]"
    }
    return formspec
end

--defines the help formspec
function help_formspec(player)
    local formspec = {
        "size[30,22]",
        "bgcolor[#2d2d2d;false]",
        "image[-1,-1;40,28;"..border.."]",
        "image[5.5,0.5;24,13.5;"..image.."]",
        "label[9,12;"..text.."]",
        "button[11.5,18;3,0.75;<-;<-]",
        "button[15.5,18;3,0.75;->;->]",
        "button[13.5,20;3,0.75;Back;Back]"
    }
    return formspec
end

--defines the sleep formspec
function sleep_formspec(player)
    local formspec = {
        "size[2,0.5]",
        "bgcolor[#2d2d2d;false]",
        "button[0,0.1;2,0.5;wakeup;Wake Up]"
    }
    return formspec
end

--defines the computer formspec
function computer_formspec()
    local drill_active = bool_to_number(drill_on())
    local gravity_active = bool_to_number(gravity_on())
    local on_formspec = {
        "size[30,22]",
        "bgcolor[#2d2d2d;false]",
        "image[-1,-1;40,28;"..background.."]",
        "label[6,1;Drill]",
        "image[4.25,2;5.51,6.61;"..computer_drill.."]",
        "label[3,9.15;Speed: ]",
        "label[3,11.15;Resistance: ]",
        "label[3,13.15;Cooling: ]",
        "label[3,15.15;Production: ]",
        "label[3,17.15;Electrical load: ]",
        "image[6,9;" .. drill_active * drill_speed * 0.01 .. ",1;"..green.."]",
        "image[6,11;" .. drill_resistance * 0.005 .. ",1;"..red.."]",
        "image[6,13;" .. drill_cooling * 0.005 .. ",1;"..blue.."]",
        "image[6,15;" .. drill_digging * 0.005 .. ",1;"..green.."]",
        "image[6,17;" .. drill_power * 0.01 .. ",1;"..red.."]",
        "label[20.65,1;Gravity Generator]",
        "image[20.25,2;4.824,6.633;"..computer_gravity.."]",
        "label[19,9.15;Intensity: ]",
        "image[22,9;" .. gravity_active * generated_gravity * 0.05 .. ",1;"..green.."]",
        "image[22,11;" .. stability * 0.05 .. ",1;"..blue.."]",
        "label[19,11.15;Habitat stability: ]",
        "label[13.5,20;Press escape to exit.]",
    }
      local off_formspec = {
        "size[30,22]",
        "bgcolor[#2d2d2d;false]",
        "label[14,19.9;Computer has lost power.]",
        "label[14,20;Press escape to exit.]",
    }
    if power_on() then 
        return on_formspec
    end
    return off_formspec
end

--updates the computer formspec
function update_computer_formspec()
    local formspec = table.concat(computer_formspec())
    minetest.get_meta(computer_pos):set_string("formspec", formspec)
end

--sets the inventory formspec
minetest.register_on_joinplayer(function(player)
    local formspec = inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end)

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()
    if formname == "" then
        for key, val in pairs(fields) do
            if key == "Help" then
                local formspec = help_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Shop" then
                local formspec = shop_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Back" then
                local formspec = inventory_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "->" then
                if index < 12 then
                      index = index + 1
                else
                    index = 1
                end
                text = text_list[index]
                image = "readme__" .. index .. ".png"
                local formspec = help_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "<-" then
                if index > 1 then
                      index = index - 1
                else
                    index = 12
                end
                text = text_list[index]
                image = "readme__" .. index .. ".png"
                local formspec = help_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "wakeup" then
                wake_up(player, name)
            end
        end
    elseif formname == "sleep" then
        for key, val in pairs(fields) do
            if key == "wakeup" then
                wake_up(player, name)
            end
        end
    end
end)