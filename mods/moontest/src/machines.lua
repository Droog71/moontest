--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

generated_gravity = 100
drill_speed = 100
pump_speed = 100
drill_resistance = 0
drill_cooling = 0
drill_digging = 0
drill_power = 0
max_power = 600
total_ore_mined = 0
local drill_mining_timer = 0
local drill_power_timer = 0
local hvac_sound
local reactor_sound
local oxygen_sound
local gravity_sound
local drill_sound
local pump_sound
local hvac_sound_playing = false
local reactor_sound_playing = false
local oxygen_sound_playing = false
local gravity_sound_playing = false
local drill_sound_playing = false
local pump_sound_playing = false

--returns the total power consumption of the habitat
function power_consumption()
    local drill_load = bool_to_number(drill_on()) * drill_power
    local hvac_load = bool_to_number(hvac_on()) * thermostat
    local oxygen_load = bool_to_number(oxygen_on()) * oxygen_output
    local gravity_load = bool_to_number(gravity_on()) * 100
    local pump_load = bool_to_number(pump_on()) * pump_speed
    local total_load = drill_load + hvac_load + oxygen_load + gravity_load + pump_load
    return math.floor(total_load)
end

--calls the dig function and handles any subsequent reactor overloads
function update_machines()  
    if power_on() then
        if drill_on() then          
            dig()
        else
            drill_power = 0
            drill_digging = 0
            drill_resistance = 0
        end
        if power_consumption() >= max_power then
            add_hud_message("Reactor overloaded!")
            reactor_stop()
        end
    else
        drill_power = 0
    end  
    for _,player in pairs(minetest.get_connected_players()) do
        update_gravity(player:get_player_name())
    end
    update_power_hud()
end

--determines the amount of ore mined and power consumed with each cycle of the drill
function dig()
    drill_resistance = math.random(drill_speed * 2, drill_speed * 3)
    drill_mining_timer = drill_mining_timer + 1
    if drill_mining_timer >= 500 then
        local mined = drill_speed + drill_resistance
        money = money + mined
        total_ore_mined = total_ore_mined + mined
        add_hud_message("Drill mined $" .. mined .. " worth of ore.")
        drill_mining_timer = 0
    end           
    drill_power_timer = drill_power_timer + 1
    if drill_power_timer >= 100 then
        drill_digging = drill_speed + drill_resistance
        drill_cooling = (bool_to_number(pump_on()) * pump_speed) * 3
        if drill_cooling > drill_resistance * 0.9 then
            drill_cooling = drill_resistance * 0.9
        end
        drill_power = drill_digging - drill_cooling
        drill_power_timer = 0
    end
end

--updates gravity for the given player
function update_gravity(name)
    local player = minetest.get_player_by_name(name) 
    if inside_habitat(name) then
        if gravity_on() == true then
            minetest.get_player_by_name(name):set_physics_override({gravity = generated_gravity * 0.01})
        else
            minetest.get_player_by_name(name):set_physics_override({gravity = 0.25})
        end
    else
        minetest.get_player_by_name(name):set_physics_override({gravity = 0.25})
    end
end

--changes the speed of the drill
function set_drill_speed(value)
    if value ~= nil then
        drill_speed = value 
    end
end

--changes the speed of the coolant pump
function set_pump_speed(value)
    if value ~= nil then
        pump_speed = value 
    end
end

--changes the speed of the coolant pump
function set_gravity(value)
    if value ~= nil then
        generated_gravity = value 
    end
end

--opens the airlock
function open_airlock()
    if power_on() then
        for i = 1,7,1 do
            for j = -25,25,1 do
                local node_pos = vector.new(j, i, 25)
                if i >= 1 and i <= 5 then
                    if j >= -2 and j <= 2 then
                        minetest.remove_node(node_pos)
                    end
                end
            end
            minetest.sound_play('airlock', {
                gain = 0.1,
                pos = airlock_controller_pos,
                max_hear_distance = 16
            })
        end
    end
end

--closes the airlock
function close_airlock()
    if power_on() then
        for i = 1,7,1 do
            for j = -25,25,1 do
                local node_pos = vector.new(j, i, 25)
                if i >= 1 and i <= 5 then
                    if j >= -2 and j <= 2 then
                        minetest.set_node(node_pos, {name = "moontest:airlock"})
                    end
                end
            end
            minetest.sound_play('airlock', {
                gain = 0.1,
                pos = airlock_controller_pos,
                max_hear_distance = 16
            })
        end
    end
end

--starts the reactor and turns on the lights
function reactor_start()
    minetest.sound_play('power_up', {
        pos = reactor_pos,
        max_hear_distance = 64
    })
    minetest.set_node(reactor_pos, {name = "moontest:reactor_on"})
    if airlock_failed == false then
        minetest.set_node(airlock_controller_pos, {name = "moontest:airlock_controller_on"})
        close_airlock()
    end
    add_hud_message("Reactor: on")
    for z = -22,22,4 do
        for x = -22,22,6 do
            if x ~= -10 and x ~= 8 and not (x == -16 and z == -18) then
                if minetest.get_node(vector.new(x, 5, z)).name == "moontest:light_off" then
                    minetest.set_node(vector.new(x, 5, z), {name = "moontest:light_on"})
                end
            end
        end
    end
    minetest.set_node(vector.new(-7,5,26), {name = "moontest:exterior_light_on"})
    minetest.set_node(vector.new(7,5,26), {name = "moontest:exterior_light_on"})
end

--stops the reactor, shuts down all of the equipment and turns off the lights
function reactor_stop()
    minetest.sound_play('power_down', {
        pos = reactor_pos,
        max_hear_distance = 64
    })
    open_airlock()
    minetest.set_node(drill_pos, {name = "moontest:drill_off"})
    minetest.set_node(hvac_pos, {name = "moontest:hvac_off"})
    minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_off"})
    minetest.set_node(gravity_generator_pos, {name = "moontest:gravity_generator_off"})
    minetest.set_node(airlock_controller_pos, {name = "moontest:airlock_controller_off"})
    minetest.set_node(pump_pos, {name = "moontest:pump_off"})
    minetest.set_node(reactor_pos, {name = "moontest:reactor_off"})
    add_hud_message("Reactor: off")
    minetest.get_meta(hvac_pos):set_string("formspec",
        "size[5,5]"..
        "label[1.5,1;HVAC System]"..
        "field[1.8,3;2,1;Thermostat;Thermostat;]") 
    minetest.get_meta(pump_pos):set_string("formspec",
        "size[5,5]"..
        "label[1.5,1;Coolant Pump]"..
        "field[1.8,3;2,1;Speed;Speed;]") 
    for z = -22,22,4 do
        for x = -22,22,6 do
            if x ~= -10 and x ~= 8 and not (x == -16 and z == -18) then
                if minetest.get_node(vector.new(x, 5, z)).name == "moontest:light_on" then
                    minetest.set_node(vector.new(x, 5, z), {name = "moontest:light_off"})
                end
            end
        end
    end
    minetest.set_node(vector.new(-7,5,26), {name = "moontest:exterior_light_off"})
    minetest.set_node(vector.new(7,5,26), {name = "moontest:exterior_light_off"})
end

--returns true if the power is on, determines sound effects played
function power_on()
    local result =  minetest.get_node(reactor_pos).name == "moontest:reactor_on"
    if reactor_sound_playing == false and result == true and player_in_range(reactor_pos) then       
        reactor_sound_playing = true
        minetest.after(3,function()
            reactor_sound = minetest.sound_play('reactor', {
                pos = reactor_pos,
                loop = true,
                max_hear_distance = 16
            })    
        end)
    else 
        if reactor_sound and result == false and reactor_sound_playing == true then
            minetest.sound_stop(reactor_sound)
            reactor_sound_playing = false
        end
    end
    return result
end

--returns true if the drill is on, determines sound effects played
function drill_on()
    local result = minetest.get_node(drill_pos).name == "moontest:drill_on"
    if drill_sound_playing == false and result == true and player_in_range(drill_pos) then       
        drill_sound = minetest.sound_play('drill', {
            pos = drill_pos,
            loop = true,
            max_hear_distance = 16
        })  
        drill_sound_playing = true
    else 
        if result == false and drill_sound_playing == true then
            minetest.sound_stop(drill_sound)
            drill_sound_playing = false
        end
    end
    if result then drill_failed = false end
    return result
end

--returns true if the pump is on, determines sound effects played
function pump_on()
    local result = minetest.get_node(pump_pos).name == "moontest:pump_on"
    if pump_sound_playing == false and result == true and player_in_range(pump_pos) then       
        pump_sound = minetest.sound_play('pump', {
            pos = pump_pos,
            loop = true,
            max_hear_distance = 16
        })  
        pump_sound_playing = true
    else 
        if result == false and pump_sound_playing == true then
            minetest.sound_stop(pump_sound)
            pump_sound_playing = false
        end
    end
    if result then pump_failed = false end
    return result
end

--returns true if the hvac system is on, determines sound effects played
function hvac_on()
    local result = minetest.get_node(hvac_pos).name == "moontest:hvac_on"
    if hvac_sound_playing == false and result == true and player_in_range(hvac_pos) then       
        hvac_sound_playing = true
        minetest.after(3,function()
            hvac_sound = minetest.sound_play('hvac_running', {
                pos = hvac_pos,
                loop = true,
                max_hear_distance = 16
            })    
        end)
    else 
        if hvac_sound and result == false and hvac_sound_playing == true then
            minetest.sound_stop(hvac_sound)
            hvac_sound_playing = false
        end
    end
    if result then hvac_failed = false end
    return result
end

--returns true if the oxygen generator is on, determines sound effects played
function oxygen_on()
    local result = minetest.get_node(oxygen_generator_pos).name == "moontest:oxygen_generator_on"
    if oxygen_sound_playing == false and result == true and player_in_range(oxygen_generator_pos) then
        oxygen_sound_playing = true
        minetest.after(2,function()
            oxygen_sound = minetest.sound_play('oxygen', {
                pos = oxygen_generator_pos,
                loop = true,
                max_hear_distance = 16
            })    
        end)
    else 
        if oxygen_sound and result == false and oxygen_sound_playing == true then
            minetest.sound_stop(oxygen_sound)
            oxygen_sound_playing = false
        end
    end
    if result then oxygen_failed = false end
    return result
end

--returns true if the gravity generator is on, determines sound effects played
function gravity_on()
    local result = minetest.get_node(gravity_generator_pos).name == "moontest:gravity_generator_on"
    if gravity_sound_playing == false and result == true and player_in_range(gravity_generator_pos) then       
        gravity_sound = minetest.sound_play('gravity', {
            pos = gravity_generator_pos,
            loop = true,
            gain = 2.0,
            max_hear_distance = 16
        })  
        gravity_sound_playing = true
    else 
        if result == false and gravity_sound_playing == true then
            minetest.sound_stop(gravity_sound)
            gravity_sound_playing = false
        end
    end
    if result then gravity_failed = false end
    return result
end

--returns true if the airlock is closed
function airlock_closed()
    local result = minetest.get_node(airlock_pos).name == "moontest:airlock"
    if result then airlock_failed = false end
    return result
end