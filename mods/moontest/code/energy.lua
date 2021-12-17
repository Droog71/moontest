--[[
    Moon Habitat Simulator
    Version: 1
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

energy_levels = {}
sleeping = {}
local energy_timer = 0

--initializes the energy variable
minetest.register_on_joinplayer(function(player)
    if player then
        energy_levels[player:get_player_name()] = 100
    end
end)

--manages fatigue and sleeping
function update_energy()
    energy_timer = energy_timer + 1
    if energy_timer >= 100 then
        for name, energy_level in pairs(energy_levels) do
            local player = minetest.get_player_by_name(name)
            if energy_levels[name] > 0 and player:get_hp() > 0 then				
                energy_levels[name] = energy_levels[name] - 1   
                update_energy_hud(name)
            elseif minetest.get_player_by_name(name):get_hp() > 0 then
                hurt_player(name)
            end
        end
        for name, pos in pairs(sleeping) do
            local player = minetest.get_player_by_name(name)
            if energy_levels[name] ~= nil then
                if energy_levels[name] <= 90 then
                    energy_levels[name] = energy_levels[name] + 10
                    update_energy_hud(name)
                end
            end
        end	
        energy_timer = 0
    end
	
    for name, pos in pairs(sleeping) do
        local player = minetest.get_player_by_name(name)
        if energy_levels[name] ~= nil then
            if energy_levels[name] <= 90 then
                player:set_pos(pos)
                player:set_properties({
                    visual_size = { x = 2, y = 1 },
                    textures = { "player_sleep.png", "player_back_sleep.png" },
                    visual = "sprite",
                })
                player:set_eye_offset({x=0,y=-12,z=0},{x=0,y=0,z=0})
            else
                sleeping[name] = nil
                player:set_properties({
                    visual_size = { x = 1, y = 2 },
                    textures = { "player.png", "player_back.png" },
                    visual = "upright_sprite",
                })
                player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
                player:set_pos(vector.new(0, 2, 0))
            end
        end
    end
end

--puts the player to sleep in the bed at the given position
function sleep(player, pos)
    local sleep_pos = vector.new(pos.x, 1.5, pos.z)
    sleeping[player:get_player_name()] = sleep_pos
end

--returns true if the player is sleeping
function is_sleeping(player)
    for name, pos in pairs(sleeping) do
        if name == player then
            return true
        end
    end	
    return false
end

--used to display sleeping status on the HUD
function sleep_display(name)
    if is_sleeping(name) then
        return " (Sleeping)"
    end
    return ""
end