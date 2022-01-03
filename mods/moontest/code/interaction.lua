--[[
    Moon Habitat Simulator
    Version: 1.0.2
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--handles all interactions based on left clicking static objects in the world
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
        
    if node.name == "moontest:food_vending_top" or node.name == "moontest:food_vending_bottom" then
        if money >= 10 and power_on() then
            buy_space_food(puncher)
        end
    end
        
    if node.name == "moontest:reactor_collider" and power_on() then
        reactor_stop()     
    elseif node.name == "moontest:reactor_collider" and power_on() == false then
        reactor_start()
    end    
    
    if node.name == "moontest:drill_collider" and drill_on() then
        minetest.set_node(drill_pos, {name = "moontest:drill_off"})
        add_hud_message("Drill: off") 
    elseif node.name == "moontest:drill_collider" and drill_on() == false and power_on() == true then
        minetest.set_node(drill_pos, {name = "moontest:drill_on"})
        add_hud_message("Drill: on")
    end
        
    if node.name == "moontest:hvac_on" then
        minetest.sound_play('hvac_off', {
            pos = hvac_pos,
            max_hear_distance = 16
        })
        minetest.set_node(pos, {name = "moontest:hvac_off"})
        add_hud_message("HVAC: off")
        minetest.get_meta(hvac_pos):set_string("formspec",
            "size[5,5]"..
            "label[1.5,1;HVAC System]"..
            "field[1.8,3;2,1;Thermostat;Thermostat;]") 
    end
        
    if node.name == "moontest:hvac_off" and power_on() then
        minetest.sound_play('hvac_on', {
            pos = hvac_pos,
            max_hear_distance = 16
        })
        minetest.set_node(pos, {name = "moontest:hvac_on"})
            add_hud_message("HVAC: on")
        minetest.get_meta(hvac_pos):set_string("formspec",
            "size[5,5]"..
            "label[1.5,1;HVAC System]"..
            "field[1.8,3;2,1;Thermostat;Thermostat;]")
    end
        
    if node.name == "moontest:oxygen_generator_collider" and oxygen_on() then
        minetest.sound_play('oxygen_start_stop', {
            pos = oxygen_generator_pos,
            max_hear_distance = 16
        })
        minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_off"})
        add_hud_message("Oxygen generator: off")     
    elseif node.name == "moontest:oxygen_generator_collider" and oxygen_on() == false and power_on() then
        minetest.sound_play('oxygen_start_stop', {
            pos = oxygen_generator_pos,
            max_hear_distance = 16
        })
        minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_on"})
        add_hud_message("Oxygen generator: on")
    end
        
    if node.name == "moontest:gravity_generator_collider" and gravity_on() then
        minetest.set_node(gravity_generator_pos, {name = "moontest:gravity_generator_off"})
        add_hud_message("Gravity generator: off")     
    elseif node.name == "moontest:gravity_generator_collider" and gravity_on() == false and power_on() then
        minetest.set_node(gravity_generator_pos, {name = "moontest:gravity_generator_on"})
        add_hud_message("Gravity generator: on")
    end
     
    if node.name == "moontest:pump_on" then
        minetest.set_node(pos, {name = "moontest:pump_off"})
        add_hud_message("Coolant pump: off")
        minetest.get_meta(pump_pos):set_string("formspec",
            "size[5,5]"..
            "label[1.5,1;Coolant Pump]"..
            "field[1.8,3;2,1;Speed;Speed;]") 
    end
        
    if node.name == "moontest:pump_off" and power_on() then
        minetest.set_node(pos, {name = "moontest:pump_on"})
        add_hud_message("Coolant pump: on")
        minetest.get_meta(pump_pos):set_string("formspec",
            "size[5,5]"..
            "label[1.5,1;Coolant Pump]"..
            "field[1.8,3;2,1;Speed;Speed;]") 
    end
        
    if node.name == "moontest:bunkbed" then
        sleep(puncher, pos)
    end
        
    if node.name == "moontest:airlock_controller_on" then
        if airlock_closed() then
            open_airlock()
            add_hud_message("Airlock: open")
        else
            close_airlock()
            add_hud_message("Airlock: closed")
        end
    end
        
    if node.name == "moontest:airlock_controller_off" and power_on() then
        minetest.set_node(airlock_controller_pos, {name = "moontest:airlock_controller_on"})
        airlock_failed = false
    end       
end)