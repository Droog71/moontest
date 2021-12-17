--[[
    Moon Habitat Simulator
    Version: 1
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

oxygen_output = 100
oxygen_levels = {}
local oxygen_timer = 0

--initializes the oxygen variable
minetest.register_on_joinplayer(function(player)
    if player then
        oxygen_levels[player:get_player_name()] = 100       
    end
end)

--changes the oxygen output setting
function set_oxygen_output(value)
   oxygen_output = value
end

--manages oxygen for all players
function update_oxygen()
    oxygen_timer = oxygen_timer + 1
    if oxygen_timer >= 100 then
        if oxygen_on() == false or airlock_closed() == false then
            suffocate_players()      
        else
            supply_air()
        end
        oxygen_timer = 0
    end
end

--attempts to decrease oxygen for all players
function suffocate_players()
    for name, oxygen_level in pairs(oxygen_levels) do
        suffocate_player(name)
    end
end

--attempts to increase oxygen for all players
function supply_air()
    for name, oxygen_level in pairs(oxygen_levels) do
        give_air_to_player(name)
    end
end

--attempts to decrease the oxygen of the given player
function suffocate_player(name)
    if oxygen_levels[name] > 0 then
        if minetest.get_player_by_name(name):get_hp() > 0 then
            oxygen_levels[name] = oxygen_levels[name] - 1        
            update_oxygen_hud(name)
        end
    else
        if minetest.get_player_by_name(name):get_hp() > 0 then
            hurt_player(name)
        end
    end
end

--attempts to increase the oxygen of the given player
function give_air_to_player(name)
    if inside_habitat(name) then
        if oxygen_levels[name] < oxygen_output then
            oxygen_levels[name] = oxygen_levels[name] + 1
            update_oxygen_hud(name)
        else
            if oxygen_levels[name] >= 200 then
                if minetest.get_player_by_name(name):get_hp() > 0 then
                    hurt_player(name)
                end
            else
                suffocate_player(name)
            end
        end
    else
        suffocate_player(name)
    end
end