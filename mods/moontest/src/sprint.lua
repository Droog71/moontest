--[[
    Moon Habitat Simulator
    Version: 1.0.6
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local energy_timers = {}
 
--sets up the player character and loads the world
minetest.register_on_joinplayer(function(player)
    if player then
        energy_timers[player:get_player_name()] = 0
    end
end)
 
--removes the player from list
minetest.register_on_leaveplayer(function(player)
    if player then
        energy_timers[player:get_player_name()] = nil
    end
end)
 
--handles sprinting and energy
minetest.register_globalstep(function(dtime)  
    for _,player in pairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
        if player:get_player_control().aux1 then
            if energy_levels[name] > 0 then
                player:set_physics_override({speed = 1.8})
                energy_timers[name] = energy_timers[name] + 1
                if energy_timers[name] >= 150 then
                    energy_levels[name] = energy_levels[name] - 1
                    energy_timers[name] = 0
                    update_energy_hud(name)
                end
            else
                player:set_physics_override({speed = 1})
            end
        else
            player:set_physics_override({speed = 1})
        end
    end
end)