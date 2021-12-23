--[[
    Moon Habitat Simulator
    Version: 1.01
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

thermostat = 100
temperature_levels = {}
local temperature_timer = 0

--initializes temperature variable
minetest.register_on_joinplayer(function(player)
    if player then
        temperature_levels[player:get_player_name()] = 100
    end
end)

--changes the thermostat setting for the hvac system
function set_thermostat(value)
   thermostat = value 
end

--manages temperature changes
function update_climate()
    temperature_timer = temperature_timer + 1
    if temperature_timer >= 100 then
        if hvac_on() == false or airlock_closed() == false then
            freeze_players()      
        else
            heat_players()
        end
        temperature_timer = 0
    end
end

--attempts to decrease temperature for all players
function freeze_players()
    for name, temperature_level in pairs(temperature_levels) do
        freeze_player(name)
    end
end

--attempts to increase temperature for all players
function heat_players()
    for name, temperature_level in pairs(temperature_levels) do
        heat_player(name)
    end
end

--attempts to decrease the temperature of the given player
function freeze_player(name)
    if temperature_levels[name] > 0 and minetest.get_player_by_name(name):get_hp() > 0 then
        temperature_levels[name] = temperature_levels[name] - 1        
        update_temperature_hud(name)
    else
        if minetest.get_player_by_name(name):get_hp() > 0 then
            hurt_player(name)
        end
    end
end

--attempts to increase the temperature of the given player
function heat_player(name)
    if inside_habitat(name) then
        if temperature_levels[name] < thermostat then
            temperature_levels[name] = temperature_levels[name] + 1
            update_temperature_hud(name)
        else
            if temperature_levels[name] >= 200 then
                player:set_hp(0)
                temperature_levels[name] = 100
                hunger_levels[name] = 100
            else
                freeze_player(name)
            end
        end
    else
        freeze_player(name)
    end
end