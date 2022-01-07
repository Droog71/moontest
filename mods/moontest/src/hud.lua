--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local messages = ""
local message_count = 0
local shared_hud_timer = 0
local message_list = {}
hud_bg_ids = {}
money_hud_ids = {}
hunger_hud_ids = {}
energy_hud_ids = {}
oxygen_hud_ids = {}
temperature_hud_ids = {}
airlock_hud_ids = {}
gravity_hud_ids = {}
thermostat_hud_ids = {}
oxygen_output_hud_ids = {}
power_hud_ids = {}
drill_hud_ids = {}
coolant_hud_ids = {}
message_bg_hud_ids = {}
message_hud_ids = {}

--initializes all of the HUD elements
minetest.register_on_joinplayer(function(player)
    if player then
        hud_bg_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "image",
            position = {x = 0, y = 0},
            offset = {x = 163, y = 430},
            scale = {x = 1, y = 1},
            text = "hud_bg_transparent.png"
        })
        oxygen_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 250},
            scale = {x = 1, y = 1},
            text = "Oxygen: " .. oxygen_levels[player:get_player_name()],
            number = 0xFFFFFF
        })
        hunger_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 280},
            scale = {x = 1, y = 1},
            text = "Hunger: " .. hunger_levels[player:get_player_name()],
            number = 0xFFFFFF
        })
        temperature_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 310},
            scale = {x = 1, y = 1},
            text = "Temperature: " .. temperature_levels[player:get_player_name()],
            number = 0xFFFFFF
        })
        energy_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 340},
            scale = {x = 1, y = 1},
            text = "Energy: " .. energy_levels[player:get_player_name()] .. sleep_display(player:get_player_name()),
            number = 0xFFFFFF
        })
        airlock_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 400},
            scale = {x = 1, y = 1},
            text = "Airlock: " .. bool_to_open_closed(airlock_closed()),
            number = 0xFFFFFF
        })
        gravity_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 430},
            scale = {x = 1, y = 1},
            text = "Gravity generator: " .. bool_to_on_off(gravity_on()) .. "; Intensity: " .. generated_gravity,
            number = 0xFFFFFF
        })
        thermostat_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 460},
            scale = {x = 1, y = 1},
            text = "HVAC: " .. bool_to_on_off(hvac_on()) .. "; Thermostat: " .. thermostat,
            number = 0xFFFFFF
        })
        oxygen_output_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 490},
            scale = {x = 1, y = 1},
            text = "Oxygen generator: " .. bool_to_on_off(oxygen_on()) .. "; Output: " .. oxygen_output,
            number = 0xFFFFFF
        })
        drill_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 520},
            scale = {x = 1, y = 1},
            text = "Drill: " .. bool_to_on_off(drill_on()) .. "; Speed: " .. drill_speed,
            number = 0xFFFFFF
        })
        coolant_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 550},
            scale = {x = 1, y = 1},
            text = "Coolant pump: " .. bool_to_on_off(pump_on()) .. "; Speed: " .. pump_speed,
            number = 0xFFFFFF
        })
        power_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 580},
            scale = {x = 1, y = 1},
            text = "Power consumption: " .. power_consumption() .. "/" .. max_power,
            number = 0xFFFFFF
        })
        money_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 610},
            scale = {x = 1, y = 1},
            text = "Money: $" .. money,
            number = 0xFFFFFF
        })
        message_bg_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "image",
            position = {x = 1, y = 0.38},
            offset = {x = -210, y = 0},
            scale = {x = 1, y = 1},
            text = "message_background_transparent.png"
        })
        message_hud_ids[player:get_player_name()] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 1, y = 0.4},
            offset = {x = -210, y = 0},
            scale = {x = 1, y = 1},
            text = messages,
            number = 0xFFFFFF
        })
    end
end)

--updates HUD info that is shared among all players
function update_shared_hud()
    shared_hud_timer = shared_hud_timer + 1
    if shared_hud_timer >= 10 then
        update_airlock_hud()
        update_gravity_hud()
        update_oxygen_output_hud()
        update_thermostat_hud()
        update_drill_hud()
        update_coolant_hud()
        update_money_hud()
        update_message_hud()
        shared_hud_timer = 0
    end
end

--updates the oxygen variable on the HUD
function update_oxygen_hud(name)
    local player = minetest.get_player_by_name(name)
    if player then
        player:hud_remove(oxygen_hud_ids[name])
        local display = "Oxygen: " .. oxygen_levels[name]
        local color = 0xFFFFFF
        if oxygen_levels[name] == 0 then
            display = display .. " (SUFFOCATING)"
            color = 0xFF0000
        elseif oxygen_levels[name] >= 200 then
            display = display .. " (POISONED)"
        end
        oxygen_hud_ids[name] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 250},
            scale = {x = 1, y = 1},
            text = display,
            number = color
        })
    end
end

--updates hunger variable on the HUD
function update_hunger_hud(name)
    local player = minetest.get_player_by_name(name)
    if player then
        player:hud_remove(hunger_hud_ids[name])
        local display = "Hunger: " .. hunger_levels[name]
        local color = 0xFFFFFF
        if hunger_levels[name] == 0 then
            display = display .. " (STARVING)"
            color = 0xFF0000
        end
        hunger_hud_ids[name] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 280},
            scale = {x = 1, y = 1},
            text = display,
            number = color
        })
    end
end

--updates temperature variable on the HUD
function update_temperature_hud(name)
    local player = minetest.get_player_by_name(name)
    if player then
        player:hud_remove(temperature_hud_ids[name])
        local display = "Temperature: " .. temperature_levels[name]
        local color = 0xFFFFFF
        if temperature_levels[name] == 0 then
            display = display .. " (FREEZING)"
            color = 0xFF0000
        elseif temperature_levels[name] >= 200 then
            display = display .. " (OVERHEATED)"
            color = 0xFF0000
        end
        temperature_hud_ids[name] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 310},
            scale = {x = 1, y = 1},
            text = display,
            number =  color
        })
    end
end

--updates energy variable on the HUD
function update_energy_hud(name)
    local player = minetest.get_player_by_name(name)
    if player then
        player:hud_remove(energy_hud_ids[name])
        local display = "Energy: " .. energy_levels[name]
        local color = 0xFFFFFF
        if energy_levels[name] == 0 then
            display = display .. " (EXHAUSTED)"
            color = 0xFF0000
        else
           display = display .. sleep_display(player:get_player_name())
        end
        energy_hud_ids[name] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 0},
            offset = {x = 150, y = 340},
            scale = {x = 1, y = 1},
            text = display,
            number = color
        })
    end
end

--updates airlock status on the HUD for all players
function update_airlock_hud()
    for name, id in pairs(thermostat_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(airlock_hud_ids[name])
            local display = "Airlock: " .. bool_to_open_closed(airlock_closed())
            local color = 0xFFFFFF
            if airlock_failed then
                display = "Airlock: (FAILED)"
                color = 0xFF0000
            end
            airlock_hud_ids[name] = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0, y = 0},
                offset = {x = 150, y = 400},
                scale = {x = 1, y = 1},
                text = display,
                number = color
            })
        end
    end
end

--updates gravity status on the HUD for all players
function update_gravity_hud()
    for name, id in pairs(gravity_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(gravity_hud_ids[name])
            local display = "Gravity generator: " .. bool_to_on_off(gravity_on()) .. "; Intensity: " .. generated_gravity
            local color = 0xFFFFFF
            if gravity_failed then
                display = "Gravity generator: (FAILED)"
                color = 0xFF0000
            elseif gravity_on() == false then
                color = 0xFFFF00
            end
            gravity_hud_ids[name] = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0, y = 0},
                offset = {x = 150, y = 430},
                scale = {x = 1, y = 1},
                text = display,
                number = color
            })
        end
    end
end

--updates hvac status on the HUD for all players
function update_thermostat_hud()
    for name, id in pairs(thermostat_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(thermostat_hud_ids[name])
            local display = "HVAC: " .. bool_to_on_off(hvac_on()) .. "; Thermostat: " .. thermostat
            local color = 0xFFFFFF
            if hvac_failed then
                display = "HVAC: (FAILED)"
                color = 0xFF0000
            elseif hvac_on() == false then
                color = 0xFFFF00
            end
            thermostat_hud_ids[name] = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0, y = 0},
                offset = {x = 150, y = 460},
                scale = {x = 1, y = 1},
                text = display,
                number = color
            })
        end
    end
end

--updates oxygen generator status on the HUD for all players
function update_oxygen_output_hud()
    for name, id in pairs(oxygen_output_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(oxygen_output_hud_ids[name])
            local display = "Oxygen generator: " .. bool_to_on_off(oxygen_on()) .. "; Output: " .. oxygen_output
            local color = 0xFFFFFF
            if oxygen_failed then
                display = "Oxygen generator: (FAILED)"
                color = 0xFF0000
            elseif oxygen_on() == false then
                color = 0xFFFF00
            end
            oxygen_output_hud_ids[name] = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0, y = 0},
                offset = {x = 150, y = 490},
                scale = {x = 1, y = 1},
                text = display,
                number = color
            })
        end
    end
end

--updates drill information on the HUD for all players
function update_drill_hud()
    for name, id in pairs(drill_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(drill_hud_ids[name])
            local display = "Drill: " .. bool_to_on_off(drill_on()) .. "; Speed: " .. drill_speed
            local color = 0xFFFFFF
            if drill_failed then
                display = "Drill: (FAILED)"
                color = 0xFF0000
            elseif drill_on() == false then
                color = 0xFFFF00
            end
            drill_hud_ids[name] = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0, y = 0},
                offset = {x = 150, y = 520},
                scale = {x = 1, y = 1},
                text = display,
                number = color
            })
        end
    end
end

--updates coolant system status on the HUD for all players
function update_coolant_hud()
    for name, id in pairs(coolant_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(coolant_hud_ids[name])
            local display = "Coolant pump: " .. bool_to_on_off(pump_on()) .. "; Speed: " .. pump_speed
            local color = 0xFFFFFF
            if pump_failed then
                display = "Coolant pump: (FAILED)"
                color = 0xFF0000
            elseif pump_on() == false then
                color = 0xFFFF00
            end
            coolant_hud_ids[name] = player:hud_add({
              hud_elem_type = "text",
                  position = {x = 0, y = 0},
                  offset = {x = 150, y = 550},
                  scale = {x = 1, y = 1},
                  text = display,
                  number = color
            })
        end
    end
end

--updates power consumption on the HUD for all players
function update_power_hud()
    for name, id in pairs(money_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(power_hud_ids[name])
            power_hud_ids[name] = player:hud_add({
            hud_elem_type = "text",
                position = {x = 0, y = 0},
                offset = {x = 150, y = 580},
                scale = {x = 1, y = 1},
                text = "Power consumption: " .. power_consumption() .. "/" .. max_power,
                number = 0xFFFFFF
            })
        end
    end
end

--updates money info on the HUD for all players
function update_money_hud()
    for name, id in pairs(money_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
            player:hud_remove(money_hud_ids[name])
            money_hud_ids[name] = player:hud_add({
                hud_elem_type = "text",
                position = {x = 0, y = 0},
                offset = {x = 150, y = 610},
                scale = {x = 1, y = 1},
                text = "Money: $" .. money,
                number = 0xFFFFFF
            })
            local spec = player:get_inventory_formspec()
            local str = string.sub(spec,48,51)
            if str == "Shop" then
                local formspec = shop_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            end
        end
    end
end

--updates messages on the HUD for all players
function update_message_hud()
    for name, id in pairs(message_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
          player:hud_remove(message_hud_ids[name])
          message_hud_ids[name] = player:hud_add({
              hud_elem_type = "text",
              position = {x = 1, y = 0.4},
              offset = {x = -210, y = 0},
              scale = {x = 1, y = 1},
              text = messages,
              number = 0xFFFFFF
          })
        end
    end
end

--adds a message to the HUD
function add_hud_message(message)
    table.insert(message_list, message)
    message_count = message_count + 1
    if message_count >= 16 then
        messages = ""
        for index, msg in pairs(message_list) do
            if index == 1 then
                table.remove(message_list, 1)
                message_count = message_count - 1
            else
                messages = messages .. msg .. "\n"
            end
        end
    else
        messages = messages .. message .. "\n"
    end
    update_message_hud()
end