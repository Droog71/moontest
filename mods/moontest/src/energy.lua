--[[
    Moon Habitat Simulator
    Version: 1.0.4
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

energy_levels = {}
sleeping = {}
local fatigue_timer = 0
local sleep_timer = 0

--initializes the energy variable
minetest.register_on_joinplayer(function(player)
    if player then
        energy_levels[player:get_player_name()] = 100
    end
end)

--manages fatigue and sleeping
function update_energy()
    fatigue_timer = fatigue_timer + 1
    if fatigue_timer >= 300 then
        for name, energy_level in pairs(energy_levels) do
            local player = minetest.get_player_by_name(name)
            if energy_levels[name] > 0 and player:get_hp() > 0 then				
                energy_levels[name] = energy_levels[name] - 1   
            elseif minetest.get_player_by_name(name):get_hp() > 0 then
                hurt_player(name)
            end
            update_energy_hud(name)
        end
        fatigue_timer = 0
    end
	
    sleep_timer = sleep_timer + 1
    if sleep_timer >= 100 then
        for name, pos in pairs(sleeping) do
            local player = minetest.get_player_by_name(name)
            if energy_levels[name] ~= nil then
                if energy_levels[name] <= 90 then
                    energy_levels[name] = energy_levels[name] + 10
                end
            end
            update_energy_hud(name)
        end
        sleep_timer = 0
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
                wake_up(player, name)
            end
        end
    end
end

--puts the player to sleep in the bed at the given position
function sleep(player, pos)
    local name = player:get_player_name()
    local sleep_pos = vector.new(pos.x, 1.5, pos.z)
    sleeping[name] = sleep_pos
    local formspec = sleep_formspec(player)
    local formspec_string = table.concat(formspec)
    minetest.show_formspec(name, "sleep", formspec_string)
    player:set_inventory_formspec(table.concat(formspec, ""))
end

--wakes the player up
function wake_up(player, name)
    sleeping[name] = nil
    player:set_properties({
        visual_size = { x = 1, y = 2 },
        textures = { "player.png", "player_back.png" },
        visual = "upright_sprite",
    })
    player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
    player:set_pos(vector.new(0, 2, 0))
    minetest.close_formspec(name, "sleep")
    minetest.close_formspec(name, "")
    local formspec = inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
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