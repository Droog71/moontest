--[[
    Moon Habitat Simulator
    Version: 1.01
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

gravity_failed = false
airlock_failed = false
oxygen_failed = false
hvac_failed = false
drill_failed = false
pump_failed = false
local simulation_timer = 0

--simulates equipment failures
function update_simulation()
    simulation_timer = simulation_timer + 1
    if simulation_timer > 100 then
        local stability = 92
        if gravity_on() and generated_gravity > 100 then
            stability = stability - (generated_gravity - 100)
        else
            stability = 8 + (bool_to_number(gravity_on()) * (generated_gravity - 16))
        end
        if stability > 92 then stability = 92 end
        if math.random(0, 100) > stability then
            local machine = math.random(1, 6)
            if machine == 1 and oxygen_on() then
                minetest.sound_play('oxygen_start_stop', {
                  pos = oxygen_generator_pos,
                  max_hear_distance = 16
                })
                minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_off"})
                add_hud_message("Oxygen generator: failed")
                oxygen_failed = true
            elseif machine == 2 and hvac_on() then
                minetest.sound_play('hvac_off', {
                  pos = hvac_pos,
                  max_hear_distance = 16
                })
                minetest.set_node(hvac_pos, {name = "moontest:hvac_off"})
                add_hud_message("HVAC: failed")
                minetest.get_meta(hvac_pos):set_string("formspec",
                    "size[5,5]"..
                    "label[1.5,1;HVAC System]"..
                    "field[1.8,3;2,1;Thermostat;Thermostat;]")
                hvac_failed = true
            elseif machine == 3 and pump_on() then
                minetest.set_node(pump_pos, {name = "moontest:pump_off"})
                add_hud_message("Coolant pump: failed")
                minetest.get_meta(pump_pos):set_string("formspec",
                    "size[5,5]"..
                    "label[1.5,1;Coolant Pump]"..
                    "field[1.8,3;2,1;Speed;Speed;]")
                pump_failed = true
            elseif machine == 4 and power_on() and airlock_closed() and airlock_failed == false then                
                open_airlock()
                minetest.set_node(airlock_controller_pos, {name = "moontest:airlock_controller_off"})
                add_hud_message("Airlock: failed")
                airlock_failed = true
            elseif machine == 5 and gravity_on() then
                minetest.set_node(gravity_generator_pos, {name = "moontest:gravity_generator_off"})
                add_hud_message("Gravity generator: failed")
                gravity_failed = true
            elseif machine == 6 and drill_on() then
                minetest.set_node(drill_pos, {name = "moontest:drill_off"})
                add_hud_message("Drill: failed")
                drill_failed = true
            end
        end
        simulation_timer = 0
    end
end