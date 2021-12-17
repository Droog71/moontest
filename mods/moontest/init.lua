--[[
    Moon Habitat Simulator
    Version: 1
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

money = 1000
progress = 0.3
unlimited = 0
game_over = false
game_over_timer = 0
success = false
local expense_timer = 0
local save_timer = 0

minetest.settings:set_bool("menu_clouds", false)
minetest.settings:set_bool("smooth_lighting", true)
minetest.register_item(":", { type = "none", wield_image = "hand.png"})

dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "nodes.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "habitat.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "oxygen.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "climate.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "hunger.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "energy.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "machines.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "interaction.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "simulation.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "aliens.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "research.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "sprint.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "hud.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "formspec.lua")

minetest.register_entity("moontest:alien", alien_definition)

--disables creative mode and invulnerability
minetest.register_on_prejoinplayer(function(pname)
    if minetest.settings:get_bool("creative_mode") == true then
        return "This game does not support creative mode."
    end
        if minetest.settings:get_bool("enable_damage") == false then
        return "Damage must be enabled to play this game."
    end
end)

--sets up the player character and loads the world
minetest.register_on_joinplayer(function(player)
    if player then
        player:hud_set_flags({
            hotbar = true,
            healthbar = true
        })
        player:set_clouds({
            density = 0            
        })
        player:set_properties({
            textures = { "player.png", "player_back.png" },
            visual = "upright_sprite",
            visual_size = { x = 1, y = 2 },
            collisionbox = {-0.49, 0, -0.49, 0.49, 2, 0.49 },
            initial_sprite_basepos = {x = 0, y = 0}
        })
        if habitat_built == false then
            if minetest.get_gametime() < 10 then
                player:set_pos(vector.new(0, 20, 0))
                minetest.after(10, function()         
                    build_habitat()
                    player:set_pos(vector.new(0, 2, 5))
                    habitat_built = true	
                end)
            else
                load_world()
            end
        end
    end
end)

--removes the player from lists
minetest.register_on_leaveplayer(function(player)
    if player then
        local name = player:get_player_name()
        hunger_levels[name] = nil
        oxygen_levels[name] = nil
        temperature_levels[name] = nil
        energy_levels[name] = nil
        hud_bg_ids[name] = nil
        game_over_hud_ids[name] = nil
        money_hud_ids[name] = nil
        hunger_hud_ids[name] = nil
        energy_hud_ids[name] = nil
        oxygen_hud_ids[name] = nil
        temperature_hud_ids[name] = nil
        airlock_hud_ids[name] = nil
        gravity_hud_ids[name] = nil
        thermostat_hud_ids[name] = nil
        oxygen_output_hud_ids[name] = nil
        power_hud_ids[name] = nil
        drill_hud_ids[name] = nil
        coolant_hud_ids[name] = nil
        message_bg_hud_ids[name] = nil
        message_hud_ids[name] = nil
    end
end)

--resets all player variables on death
minetest.register_on_dieplayer(function(player)
    local player_name = player:get_player_name()
    empty_inventory(player)
    oxygen_levels[player_name] = 100
    hunger_levels[player_name] = 100
    temperature_levels[player_name] = 100
    energy_levels[player_name] = 100
    money = money - 2000
    add_hud_message(player_name .. " is being cloned for $2000.")            
end)

--loads saved game data from file
function load_world()
    local save_data = {}
    local filepath = minetest.get_worldpath()
    local file = io.open(minetest.get_worldpath() .. DIR_DELIM .. "moontest_save.txt", "r")
    io.input(file)    
    
    for str in string.gmatch(io.read(), "([^".."}".."]+)") do
        table.insert(save_data, str)
    end
    
    local loaded_money = save_data[1]
    local loaded_thermostat = save_data[2]
    local loaded_oxygen_output = save_data[3]
    local loaded_drill_speed = save_data[4]
    local loaded_pump_speed = save_data[5]
    local loaded_gravity = save_data[6]
    local loaded_progress = save_data[7]
    local loaded_research_progress = save_data[8]
    local loaded_alien_count = save_data[9]
    local loaded_unlimited = save_data[10]
    
    if loaded_money then
        money = tonumber(loaded_money)
    end
    
    if loaded_thermostat then
        set_thermostat(tonumber(loaded_thermostat))
    end
    
    if loaded_oxygen_output then
        set_oxygen_output(tonumber(loaded_oxygen_output))
    end
    
    if loaded_drill_speed then
        set_drill_speed(tonumber(loaded_drill_speed))
    end
    
    if loaded_pump_speed then
       set_pump_speed(tonumber(loaded_pump_speed)) 
    end
    
    if loaded_gravity then
       set_gravity(tonumber(loaded_gravity)) 
    end
    
    if loaded_progress then
       progress = tonumber(loaded_progress)
    end
    
    if loaded_research_progress then
       research_progress = tonumber(loaded_research_progress) 
    end
    
    if loaded_alien_count then
       alien_count = tonumber(loaded_alien_count) 
    end
    
    if loaded_unlimited then
       unlimited = tonumber(loaded_unlimited) 
    end
    
    io.close(file)
end

--prevents cheating by exiting to the menu to avoid payments
minetest.register_on_shutdown(function()
    money = money - math.floor(2000 * progress)
    save_game()
end)

--generates terrain
minetest.register_on_generated(function(minp, maxp, blockseed)
    if minp.y > 0 or maxp.y < 0 then return end
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
    local data = vm:get_data()
    for z = minp.z, maxp.z do
        for x = minp.x, maxp.x do
            local vi = area:index(x, 0, z)
            data[area:index(x, 0, z)] = minetest.get_content_id("moontest:moon_surface")
        end
    end
    vm:set_data(data)
    vm:write_to_map(data)
end)

--main game loop
minetest.register_globalstep(function(dtime)  
	minetest.set_timeofday(0)
    update_oxygen()
    update_hunger()
    update_energy()
    update_climate()
    update_machines()
    update_simulation()
    update_shared_hud()
     
    if minetest.get_gametime() > 10 then
        spawn_aliens()
    end
        
    expense_timer = expense_timer + 1
    if expense_timer >= 1000 then
        money = money - math.floor(2000 * progress)
        update_money_hud()
        add_hud_message("Expenses paid: " .. "$" .. math.floor(2000 * progress))    
        expense_timer = 0
        if progress < 1 then
            progress = progress + 0.01
            add_hud_message("Expenses increased to: " .. "$" .. math.floor(2000 * progress))
        end
    end
        
    save_timer = save_timer + 1
    if save_timer > 100 then
        save_game()
    end
        
    if money >= 30000 and unlimited == 0 then
        success = true
        game_over = true
    end
        
    if money <= -10000 and unlimited == 0 then
        success = false
        game_over = true
    end
    
    if game_over == true then
        game_over_timer = game_over_timer + 1
        if game_over_timer >= 200 then
            restart_game()
            reset_game_over_hud()
            game_over_timer = 0
        end
    end
end)

--saves game data to file
function save_game()
    local save_path = minetest.get_worldpath() .. DIR_DELIM .. "moontest_save.txt"
    minetest.safe_file_write(save_path, money .. "}"
        .. thermostat .. "}"
        .. oxygen_output .. "}"
        .. drill_speed .. "}"
        .. pump_speed .. "}"
        .. generated_gravity .. "}"
        .. progress .. "}"
        .. research_progress .. "}"
        .. alien_count .. "}"
        .. unlimited)
end

--restarts the game
function restart_game()
    game_over = false
    success = false
    money = 1000
    thermostat = 100
    oxygen_output = 100
    drill_speed = 100
    pump_speed = 100
    generated_gravity = 100
    progress = 0.3
    research_progress = 1
    expense_timer = 0
    for index, alien in pairs(aliens) do
        alien:remove()
        aliens[index] = nil
    end
    alien_count = 0
    build_habitat()
    for _,player in pairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        oxygen_levels[player_name] = 100
        hunger_levels[player_name] = 100
        energy_levels[player_name] = 100
        temperature_levels[player_name] = 100
        empty_inventory(player)
        player:set_hp(20)
        player:set_pos(vector.new(0, 2, 5))
    end
end

--removes the success and failure conditions
minetest.register_chatcommand("unlimited", {
	privs = {
      server = true
	},
	func = function(name, param)
      if param then
          local input = tonumber(param)
          if input then
              if input == 0 or input == 1 then
                  unlimited = input
                  return true, "Endless game = " .. unlimited
              else
                  return true, "Usage: '/unlimited 0' or '/unlimited 1'"
              end
          else
              return true, "Usage: '/unlimited 0' or '/unlimited 1'"
          end
      else
          return true, "Usage: '/unlimited 0' or '/unlimited 1'"
      end
	end
})

--handles player damage and death
function hurt_player(name)
    local player = minetest.get_player_by_name(name)
    player:set_hp(player:get_hp() - 1)
end

--empties the player's inventory
function empty_inventory(player)
    local items = {ItemStack("moontest:splat"), ItemStack("moontest:space_food")}
    local inventories = player:get_inventory():get_lists()
    for name, list in pairs(inventories) do
        for index, item in pairs(items) do
            while player:get_inventory():contains_item(name, items[index]) do
                player:get_inventory():remove_item(name, items[index])
            end                 
        end
    end  
end

--returns true if the given player is inside the habitat
function inside_habitat(name)
    local player = minetest.get_player_by_name(name)
    local pos = player:get_pos()
    if pos.x > 25 or pos.x < -25 or pos.y < 0 or pos.y > 6 or pos.z > 25 or pos.z < -25 then
        return false
    end
    return true
end

--returns true if the player is within 16 meters of the given position
function player_in_range(machine_pos)
    for _,player in pairs(minetest.get_connected_players()) do
        local player_pos = player:get_pos()
        local distance = vector.distance(player_pos, machine_pos)
        if distance < 16 then
            return true
        end
    end
    return false
end

--converts the given boolean variable to a number
function bool_to_number(value)
    return value and 1 or 0
end

--converts the given boolean variable to text for the HUD
function bool_to_on_off(value)
    if value then
        return "ON"
    end
    return "OFF"
end

--converts the given boolean variable to text for the HUD
function bool_to_open_closed(value)
    if value then
        return "CLOSED"
    end
    return "OPEN"
end