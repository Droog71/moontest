--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

money = 1000
aggro = 0.3

local loaded = false
local loading_timer = 0
local expense_timer = 0
local save_timer = 0
local computer_timer = 0
local previous_expense = 0

local enable_fog = minetest.settings:get_bool("enable_fog")
local menu_clouds = minetest.settings:get_bool("menu_clouds")
local smooth_lighting = minetest.settings:get_bool("smooth_lighting")

minetest.settings:set_bool("enable_fog", false)
minetest.settings:set_bool("menu_clouds", false)
minetest.settings:set_bool("smooth_lighting", true)
minetest.register_item(":", { type = "none", wield_image = "hand.png"})
skybox.add({"Space", "#FFFFFF", 0, { density = 0}})

-- Executes source files, just give .lua filename from src directory
local do_src = function(filename)
    dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "src" .. DIR_DELIM .. filename .. ".lua")
end

-- Initalize game concepts
do_src("nodes")
do_src("habitat")
do_src("oxygen")
do_src("climate")
do_src("hunger")
do_src("energy")
do_src("machines")
do_src("interaction")
do_src("simulation")
do_src("reactor_booster")
do_src("logic")
do_src("aliens")
do_src("research")
do_src("sprint")
do_src("hud")
do_src("formspec")
do_src("tutorial")
do_src("shop_formspec")

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
        skybox.set(player, 1)
        local load_time = first_run() and 20 or 10
            minetest.after(load_time, function()
                build_habitat()
                player:set_pos(vector.new(0, 2, 5))
                habitat_built = true
            end)
        if save_exists() then
            load_world()
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
    oxygen_levels[player_name] = 100
    hunger_levels[player_name] = 100
    temperature_levels[player_name] = 100
    energy_levels[player_name] = 100
    money = money - 2000
    add_hud_message(player_name .. " is being cloned for $2000.")
end)

--loads saved game data from file
function load_world()
    local file = io.open(minetest.get_worldpath() .. DIR_DELIM .. "save_data.json", "r") 
    if file then
        local data = minetest.parse_json(file:read "*a")
        if data then
            if data.money then
                money = data.money
            end
            if data.aggro then
                aggro = data.aggro
            end
            if data.max_power then
                max_power = data.max_power
            end
            if data.total_ore_mined then
                total_ore_mined = data.total_ore_mined
            end
            if data.thermostat then
                set_thermostat(data.thermostat)
            end
            if data.oxygen_output then
                set_oxygen_output(data.oxygen_output)
            end
            if data.drill_speed then
                set_drill_speed(data.drill_speed)
            end
            if data.pump_speed then
               set_pump_speed(data.pump_speed)
            end
            if data.generated_gravity then
               set_gravity(data.generated_gravity)
            end
            if data.research_progress then
               research_progress = data.research_progress
            end
            if data.alien_count then
               alien_count = data.alien_count
            end
            if data.hunger_levels then
                hunger_levels = data.hunger_levels
            end
            if data.oxygen_levels then
                oxygen_levels = data.oxygen_levels
            end
            if data.temperature_levels then
                temperature_levels = data.temperature_levels
            end
            if data.energy_levels then
                energy_levels = data.energy_levels
            end
        else
            minetest.log("error", "Failed to read save_data.json")
        end
        io.close(file)
    end
end

--saves game data to file
function save_game()
    local save_vars = {
        money = money,
        aggro = aggro,
        max_power = max_power,
        total_ore_mined = total_ore_mined,
        thermostat = thermostat,
        oxygen_output = oxygen_output,
        drill_speed = drill_speed,
        pump_speed = pump_speed,
        generated_gravity = generated_gravity,
        research_progress = research_progress,
        alien_count = alien_count,
        hunger_levels = hunger_levels,
        oxygen_levels = oxygen_levels,
        temperature_levels = temperature_levels,
        energy_levels = energy_levels
    }
    local save_data = minetest.write_json(save_vars)
    local save_path = minetest.get_worldpath() .. DIR_DELIM .. "save_data.json"
    minetest.safe_file_write(save_path, save_data)
end

--returns true if the file exists
function save_exists()
    local file = io.open(minetest.get_worldpath() .. DIR_DELIM .. "save_data.json", "r")
    if file then
        io.close(file)
        return true 
    end
    return false
end

--returns true on first run to increase loading time while media files are cached
function first_run()
    if minetest.settings:get_bool("moontest:first_run") then
        return false 
    end
    minetest.settings:set_bool("moontest:first_run", true)
    return true
end

--prevents cheating by exiting to the menu to avoid payments
minetest.register_on_shutdown(function()
    money = money - math.floor(total_ore_mined * 0.01)
    minetest.settings:set_bool("enable_fog", enable_fog)
    minetest.settings:set_bool("menu_clouds", menu_clouds)
    minetest.settings:set_bool("smooth_lighting", smooth_lighting)
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
    if habitat_built == false then
        for _,player in pairs(minetest.get_connected_players()) do
            player:set_pos(vector.new(0, 10, 0))
            player:set_physics_override({gravity = 0})
        end
        
        loading_timer = loading_timer + 1
        if loading_timer >= 100 then
            add_hud_message("Preparing the world, please wait...")
            update_shared_hud()
            loading_timer = 0
        end
    else
        if loaded == false then
            add_hud_message("Game started.")
            loaded = true
        end
        if tutorial_active == false then
            update_oxygen()
            update_hunger()
            update_climate()
            update_simulation()
            spawn_aliens()
        
            expense_timer = expense_timer + 1
            if expense_timer >= 1000 then
                local expense = math.floor(total_ore_mined * 0.01)
                money = money - expense
                update_money_hud()
                add_hud_message("Expenses paid: " .. "$" .. expense)
                if expense > previous_expense then
                    add_hud_message("Expenses increased to: " .. "$" .. expense)
                    previous_expense = total_ore_mined * 0.01
                end
                if aggro < 1 then
                    aggro = aggro + 0.01
                end
                expense_timer = 0
            end
                
            save_timer = save_timer + 1
            if save_timer >= 100 then
                save_game()
                save_timer = 0
            end
        end
        update_energy()
        update_machines()
        update_shared_hud()
        computer_timer = computer_timer + 1
        if computer_timer >= 20 then
            update_computer_formspec()
            computer_timer = 0
        end
    end
end)

--handles player damage and death
function hurt_player(name)
    local player = minetest.get_player_by_name(name)
    player:set_hp(player:get_hp() - 1)
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
    return value and "ON" or "OFF"
end

--converts the given boolean variable to text for the HUD
function bool_to_open_closed(value)
    if value then
        return "CLOSED"
    end
    return "OPEN"
end
