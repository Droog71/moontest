--[[
    Moon Habitat Simulator
    Version: 1.0.6
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

tutorial_active = false
tutorial_step = 1
local hud_img = nil
local tutorial_timer = 0
local current_fs_string = 1
local tutorial_step_complete = 1
local tutorial_fs_strings = {
  "size[8,8]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,0.5;" .. "Welcome to the moon habitat simulator!\n\n" ..
  "The first step of this tutorial is about food.\n" ..
  "You will need to eat to survive on the moon.\n" ..
  "Make your way to the space food vending machine\n" ..
  "in the habitat and buy some food.\n\n" .. "]" ..
  "image[1.5,3.5;6,3.375;readme__10.png]" ..
  "button[3,7;2,0.5;ok;OK]",
  
  "size[8,6]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,0.5;" .. "Well done!\n\n" ..
  "Left click with the food in your hand to eat.\n" ..
  "This will reduce your hunger. Pay close attention to\n" ..
  "the hunger variable on the left side of the screen.\n" ..
  "Next, we will talk about sleep.\n\n" .. "]" ..
  "button[3,4.5;2,0.5;next;Next]",
  
  "size[8,8]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,0.5;" .. "Your energy is displayed on the\n" ..
  "left side of the screen. If this gets too low,\n" ..
  "you will die. You will need sleep to survive.\n" ..
  "Make your way to the sleeping quarters and click\n" ..
  "on the bottom bunk of a bunk bed to sleep.\n\n" .. "]" ..
  "image[1.5,3.5;6,3.375;readme__11.png]" ..
  "button[3,7;2,0.5;ok;OK]",
  
  "size[8,11]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" .. "This is your hvac system. Without it,\n" .. 
  "you cannot survive. Left click the box on top to turn\n" .. 
  "it on or off. Right click the box to adjust the thermostat.\n\n" ..
  "The hvac system's power consumption is dependent on the\n" .. 
  "thermostat setting. Lower values allow you to divert power\n" .. 
  "elsewhere. Higher values provide more safety.\n" ..
  "Extremely high thermostat settings can be dangerous.\n" ..
  "This machine is not helpful when the airlock is open.\n" ..
  "Go ahead and try adjusting the thermostat now.]" ..
  "image[1.5,6;6,3.375;readme__6.png]" ..
  "button[3,10;2,0.5;ok;OK]",
  
  "size[8,11]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" .. "This is your oxygen generator. Without it,\n" .. 
  "you cannot survive. Left click the generator to turn\n" .. 
  "it on or off. Right click the generator to adjust the output.\n\n" ..
  "This machine's power consumption is dependent on the\n" .. 
  "output setting. Lower values allow you to divert power\n" .. 
  "elsewhere. Higher values provide more safety.\n" ..
  "Extremely high output settings can be dangerous.\n" ..
  "This machine is not helpful when the airlock is open.\n" ..
  "Go ahead and try adjusting the output now.]" ..
  "image[1.5,6;6,3.375;readme__5.png]" ..
  "button[3,10;2,0.5;ok;OK]",
  
  "size[8,11]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" .. "This is your gravity generator.\nWithout it, " .. 
  "other machines become unstable.\nLeft click the generator to turn " .. 
  "it on or off.\nRight click the generator to adjust the intensity.\n\n" ..
  "This machine's power consumption is dependent on the\n" .. 
  "intensity setting. Lower values allow you to divert power\n" .. 
  "elsewhere. Higher values provide more stability but values\n" ..
  "over 100 will cause your machines to become unstable.\n" ..
  "Go ahead and try adjusting the output now.]" ..
  "image[1.5,6;6,3.375;readme__4.png]" ..
  "button[3,10;2,0.5;ok;OK]",
  
  "size[8,9]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" .. 
  "This is your nuclear reactor.\n" .. 
  "The power source for your habitat.\n" .. 
  "Left click the reactor to turn it on or off.\n" .. 
  "If the reactor is overloaded or you turn it off,\n" .. 
  "all of your equipment will have to be restarted.]" ..
  "image[1.5,4;6,3.375;readme__2.png]" ..
  "button[3,8;2,0.5;next;Next]",
  
  "size[8,11]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" .. 
  "This is your mining drill.\n" .. 
  "Your primary source of passive income.\n" .. 
  "Left click the drill to turn it on or off.\n" ..
  "Right click the drill to adjust the it's speed.\n" .. 
  "Power consumption is dependent on the speed setting.\n" ..
  "When changed, you must also adjust the coolant pump.\n" .. 
  "Otherwise, you will experience fluctuations in power\n" .. 
  "consumption and may overload your reactor.\n" .. 
  "Go ahead and try adjusting the drill speed now.]" ..
  "image[1.5,6;6,3.375;readme__7.png]" ..
  "button[3,10;2,0.5;ok;OK]",
  
  "size[8,9]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" .. 
  "This is your coolant system which prevents\n" .. 
  "the mining drill from overloading the reactor.\n" .. 
  "Left click the pump to turn it on or off.\n" ..
  "Right click the pump to adjust it's speed.\n" .. 
  "Power consumption is dependent on the speed setting.\n" ..
  "Go ahead and try adjusting the pump speed now.]" ..
  "image[1.5,4;6,3.375;readme__8.png]" ..
  "button[3,8;2,0.5;ok;OK]",
  
  "size[8,9]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" ..
  "This is the habitat computer.\n" ..
  "Here you can view the result of the current\n" ..
  "drill and coolant pump settings, as well as\n" ..
  "the gravity generator's affect on machine stability.]" ..
  "image[1.5,4;6,3.375;readme__16.png]" ..
  "button[3,8;2,0.5;next;Next]",
  
  "size[8,9]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" ..
  "This is your research station.\n" ..
  "Here you can exchange items for money,\n" ..
  "increase your research level \n" ..
  "and unlock new items in the shop.\n" ..
  "Left click the research station with the\n" ..
  "green goo in your hand to continue.]" ..
  "image[1.5,4;6,3.375;readme__12.png]" ..
  "button[3,8;2,0.5;ok;OK]",
  
  "size[8,11]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" ..
  "Research data can be gathered using\n" ..
  "research probes outside the habitat.\n" ..
  "A generator with fuel must be placed within 10\n" ..
  "meters of the probe. The farther probes are\n" .. 
  "from the habitat and each other, the more data\n" .. 
  "they will collect. You can monitor all of your\n" ..
  "generators from the power window accessed via\n" .. 
  "your inventory window. Work lights are also powered\n" ..
  "by generators and can be helpful when setting up\n" .. 
  "research probes. See the image below for example.\n" .. 
  "Go ahead and try setting up a research probe now.]" ..
  "image[1.5,6;6,3.375;readme__17.png]" ..
  "button[3,10;2,0.5;ok;OK]",
  
  "size[8,11]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" ..
  "This is an auto-restart circuit.\n" ..
  "A sensor is placed directly next to the machine.\n" ..
  "A relay is placed directly next to the sensor.\n" ..
  "From there, wire is used to connect the relay to\n" ..
  "a microcontroller programmed to operate as a NOT gate.\n" ..
  "Wire is then ran through a delayer back to the machine.\n" ..
  "This will restart a machine if it fails\n" ..
  "but will not do so after a power outage.\n" .. 
  "Go ahead and try building one of these\n" ..
  "for your oxygen generator now.]" ..
  "image[1.5,6;6,3.375;readme__13.png]" ..
  "button[3,10;2,0.5;ok;OK]",
  
  "size[8,11]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1.5,1;" ..
  "These are reactor boosters.\n" ..
  "Boosters increase reactor output by 100 each.\n" ..
  "They must be placed within 20 meters of the reactor.\n" ..
  "Boosters cannot be ran continuously.\n" .. 
  "After 10 seconds, they will overload the reactor.\n" ..
  "When disabled, the booster has a 10 second cooldown.\n" ..
  "Boosters can be operated by pulsing logic or 'clocks'.\n" ..
  "The best way to configure boosters is to stagger\n" ..
  "circuits so one group is on while the other is off.\n" ..
  "This way your reactor output has a steady value.\n" ..
  "Go ahead and try setting one of these up now.]" ..
  "image[1.5,6;6,3.375;readme__15.png]" ..
  "button[3,10;2,0.5;ok;OK]",
  
  "size[6,4]" ..
  "bgcolor[#2d2d2d;false]" ..
  "label[1,0.5;" .. "Congratulations!\n\n" ..
  "You have completed the tutorial.\n" ..
  "Click ok to resume normal gameplay.]" ..
  "button[2,3;2,0.5;ok;OK]"
}

--empties the inventory
local function empty_inventory(player)
    local inv = player:get_inventory()
    for name, list in pairs(inv:get_lists()) do
        inv:set_list(name, {})
    end  
end

--restarts the game
local function restart_game()
    money = 1000
    max_power = 600
    thermostat = 100
    oxygen_output = 100
    drill_speed = 100
    pump_speed = 100
    tf_work = 0
    generated_gravity = 100
    aggro = 0.3
    research_progress = 1
    for index, alien in pairs(aliens) do
        alien:remove()
        aliens[index] = nil
    end
    alien_count = 0
    build_habitat()
    gravity_failed = false
    airlock_failed = false
    oxygen_failed = false
    hvac_failed = false
    drill_failed = false
    pump_failed = false
    update_airlock_hud()
    update_gravity_hud()
    update_oxygen_output_hud()
    update_thermostat_hud()
    update_drill_hud()
    update_coolant_hud()
    update_money_hud()
    update_message_hud()
    for _,player in pairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        oxygen_levels[player_name] = 100
        hunger_levels[player_name] = 100
        energy_levels[player_name] = 100
        temperature_levels[player_name] = 100
        update_energy_hud(player_name)
        update_hunger_hud(player_name)
        update_oxygen_hud(player_name)
        update_temperature_hud(player_name)
        empty_inventory(player)
        player:set_hp(20)
        player:set_pos(vector.new(0, 1, 5))
    end
end

--defines the warning formspec
local function warning_formspec(player)
    local name = player:get_player_name()
    local formspec = {
        "size[9,4]",
        "bgcolor[#2d2d2d;false]",
        "label[1.5,1;Starting the tutorial will interrupt any progress you have made!\n" ..
        "Are you sure you want to continue?]",
        "button_exit[5,3;2,0.5;start;Continue]",
        "button_exit[2,3;2,0.5;cancel;Cancel]"
    }
    return formspec
end

--defines the denied formspec
local function denied_formspec(player)
    local name = player:get_player_name()
    local formspec = {
        "size[8.5,4]",
        "bgcolor[#2d2d2d;false]",
        "label[2,1;The tutorial is only available in single player.]",
        "button_exit[3,3;2,0.5;OK;OK]"
    }
    return formspec
end

--checks if the current tutorial step has been completed
local function check_tutorial_conditions(player)
    local name = player:get_player_name()
    if tutorial_step == 2 and tutorial_step_complete == 1 then 
        if player:get_inventory():contains_item("main", "moontest:space_food") then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 4 and tutorial_step_complete == 3 then 
        if is_sleeping(name) then
            wake_up(player, name)
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 5 and tutorial_step_complete == 4 then 
        if thermostat ~= 100 then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 6 and tutorial_step_complete == 5 then 
        if oxygen_output ~= 100 then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 7 and tutorial_step_complete == 6 then 
        if generated_gravity ~= 100 then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 9 and tutorial_step_complete == 8 then 
        if drill_speed ~= 100 then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 10 and tutorial_step_complete == 9 then 
        if pump_speed ~= 100 then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 11 and tutorial_step_complete == 11 then 
        if not player:get_inventory():contains_item("main", "moontest:splat") then
            local stack = ItemStack("moontest:splat")
            stack:set_count(50)
            player:get_inventory():add_item("main", stack)
        end
    elseif tutorial_step == 12 and tutorial_step_complete == 11 then 
        if research_progress ~= 1 then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 12 and tutorial_step_complete == 12 then 
        if not player:get_inventory():contains_item("main", "moontest:research_probe") then
            local stack1 = ItemStack("moontest:research_probe")
            stack1:set_count(1)
            player:get_inventory():add_item("main", stack1)
            
            local stack2 = ItemStack("moontest_power:generator")
            stack2:set_count(1)
            player:get_inventory():add_item("main", stack2)
            
            local stack3 = ItemStack("moontest_lights:work_light_off")
            stack3:set_count(1)
            player:get_inventory():add_item("main", stack3)
            
            local stack4 = ItemStack("moontest_lights:flashlight")
            stack4:set_count(1)
            player:get_inventory():add_item("main", stack4)
            
            local stack5 = ItemStack("moontest_power:fuel")
            stack5:set_count(10)
            player:get_inventory():add_item("main", stack5)
            
            hud_img = player:hud_add({
                hud_elem_type = "image",
                position = {x = 0.5, y = 0.15},
                offset = {x = 0, y = 0},
                scale = {x = 0.25, y = 0.25},
                text = "green.png"
            })
        end
    elseif tutorial_step == 13 and tutorial_step_complete == 12 then
        local producers = get_size(power_producers)
        local consumers = get_size(power_consumers)
        if producers > 0 and consumers > 0 then
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 13 and tutorial_step_complete == 13 then
        if not player:get_inventory():contains_item("main", "moontest:sensor") then
            local stack1 = ItemStack("moontest:sensor")
            stack1:set_count(10)
            player:get_inventory():add_item("main", stack1)
            
            local stack2 = ItemStack("moontest:relay_off")
            stack2:set_count(10)
            player:get_inventory():add_item("main", stack2)
            
            local stack3 = ItemStack("moontest_mesecons_delayer:delayer_off_1")
            stack3:set_count(10)
            player:get_inventory():add_item("main", stack3)
            
            local stack4 = ItemStack("moontest_mesecons_microcontroller:microcontroller0000")
            stack4:set_count(10)
            player:get_inventory():add_item("main", stack4)
            
            local stack5 = ItemStack("moontest_mesecons:wire_00000000_off")
            stack5:set_count(50)
            player:get_inventory():add_item("main", stack5)
            
            minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_off"})
            
            hud_img = player:hud_add({
                hud_elem_type = "image",
                position = {x = 0.5, y = 0.15},
                offset = {x = 0, y = 0},
                scale = {x = 0.25, y = 0.25},
                text = "readme__13.png"
            })
        end
    elseif tutorial_step == 14 and tutorial_step_complete == 13 then 
        if minetest.get_node(oxygen_generator_pos).name == "moontest:oxygen_generator_on" then
            player:hud_remove(hud_img)
            tutorial_step_complete = tutorial_step_complete + 1
        end
    elseif tutorial_step == 14 and tutorial_step_complete == 14 then 
        if not player:get_inventory():contains_item("main", "moontest:reactor_booster") then
            local stack1 = ItemStack("moontest:reactor_booster")
            stack1:set_count(10)
            player:get_inventory():add_item("main", stack1)
            
            local stack2 = ItemStack("moontest_mese_button:button_off")
            stack2:set_count(10)
            player:get_inventory():add_item("main", stack2)
            
            hud_img = player:hud_add({
                hud_elem_type = "image",
                position = {x = 0.5, y = 0.15},
                offset = {x = 0, y = 0},
                scale = {x = 0.25, y = 0.25},
                text = "readme__15.png"
            })
        end
    elseif tutorial_step == 15 and tutorial_step_complete == 14 then
        if max_power > 600 then
            tutorial_step_complete = tutorial_step_complete + 1
            player:hud_remove(hud_img)
        end
    elseif tutorial_step == 16 and tutorial_step_complete == 15 then 
        empty_inventory(player)
        player:set_physics_override({gravity = 0})
        for x = -50, 50, 1 do
            for z = -50, 50, 1 do
                for y = 1, 20, 1 do
                    minetest.remove_node(vector.new(x, y, z))
                end
            end
        end
        restart_game()
        tutorial_active = false
    end
end

--starts the tutorial in singleplayer or shows a denial message in multiplayer
function start_tutorial(player)
    local name = player:get_player_name()
    if get_size(minetest.get_connected_players()) < 2 then
        minetest.show_formspec(name,"warning",table.concat(warning_formspec(player)))
    else
        minetest.show_formspec(name,"denied",table.concat(denied_formspec(player)))
    end
end

--prevents cheating by exiting the game with free tutorial items
minetest.register_on_shutdown(function()
    if tutorial_active then
        for _,player in pairs(minetest.get_connected_players()) do
            empty_inventory(player)
        end
        for x = -50, 50, 1 do
            for z = -50, 50, 1 do
                for y = 1, 20, 1 do
                    minetest.remove_node(vector.new(x, y, z))
                end
            end
        end
        restart_game()
    end
end)

--updates the tutorial formspecs and completion status
minetest.register_globalstep(function(dtime)
    if tutorial_active == true then
        tutorial_timer = tutorial_timer + 1
        if tutorial_timer > 10 then
            for _,player in pairs(minetest.get_connected_players()) do
                local name = player:get_player_name()
                if tutorial_step_complete == tutorial_step then
                    if tutorial_step <= get_size(tutorial_fs_strings) then
                        current_fs_string = tutorial_fs_strings[tutorial_step]
                        minetest.show_formspec(name,"tutorial", current_fs_string)
                    end
                end
                energy_levels[name] = 75
                check_tutorial_conditions(player)
            end
            tutorial_timer = 0
        end
    end
end)

--handles all button clicks
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()
    if formname == "tutorial" then
        for key, val in pairs(fields) do  
            if key == "ok" then
                minetest.close_formspec(name, "tutorial")
                tutorial_step = tutorial_step + 1
            end
            if key == "next" then
                minetest.close_formspec(name, "tutorial")
                tutorial_step = tutorial_step + 1
                tutorial_step_complete = tutorial_step_complete + 1
            end
        end
    end
    if formname == "warning" then
        for key, val in pairs(fields) do  
            if key == "start" then
                tutorial_step = 1
                tutorial_step_complete = 1
                for x = -50, 50, 1 do
                    for z = -50, 50, 1 do
                        for y = 1, 20, 1 do
                            minetest.remove_node(vector.new(x, y, z))
                        end
                    end
                end
                build_enclosure()
                restart_game()
                tutorial_active = true
            end
        end
    end
end)

function build_enclosure()
    for x = -48, 48, 1 do
        for y = 1, 20, 1 do
            minetest.set_node(vector.new(x, y, -48), { name = "moontest:invisible_unlit" })
        end
    end
    for x = -48, 48, 1 do
        for y = 1, 20, 1 do
            minetest.set_node(vector.new(x, y, 48), { name = "moontest:invisible_unlit" })
        end
    end
    for z = -48, 48, 1 do
        for y = 1, 20, 1 do
            minetest.set_node(vector.new(-48, y, z), { name = "moontest:invisible_unlit" })
        end
    end
    for z = -48, 48, 1 do
        for y = 1, 20, 1 do
            minetest.set_node(vector.new(48, y, z), { name = "moontest:invisible_unlit" })
        end
    end
    for x = -48, 48, 1 do
        for z = -48, 48, 1 do
            minetest.set_node(vector.new(x, 20, z), { name = "moontest:invisible_unlit" })
        end
    end
end