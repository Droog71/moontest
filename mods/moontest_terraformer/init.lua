--[[
    Terraformer
    Author: Droog71
    License: AGPLv3
]]--

tf_work = 0
terraformer_limit = 125
previous_tf_limit = 125
terraformer_pos = vector.new(0,8,0)
local terraformer_timer = 0
local p_x = -terraformer_limit
local p_z = -terraformer_limit
local n_x = terraformer_limit
local n_z = terraformer_limit

minetest.register_node("moontest_terraformer:grass", {
    name = "grass",
    description = "grass",
    tiles = {"grass.png"}
})

minetest.register_node("moontest_terraformer:tree", {
    name = "tree",
    description = "tree",
    tiles = {"tree.png"},
    drawtype = "mesh",
    mesh = "tree.obj"
})

minetest.register_node("moontest_terraformer:terraformer_on", {
    name = "terraformer_on",
    description = "terraformer_on",
    tiles = {"terraformer_on.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "terraformer.obj"
})

minetest.register_node("moontest_terraformer:terraformer_off", {
    name = "terraformer_off",
    inventory_image = "terraformer_inv.png",
    description = "Terraformer\n" ..
    "Makes the moon habitable.\n" ..
    "Automatically constructed on the roof of the habitat when purchased.\n" ..
    "Powered by the habitat reactor. Requires 3000 to 3500 power.",
    tiles = {"terraformer_off.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "terraformer.obj"
})

minetest.register_node("moontest_terraformer:terraformer_collider", {
    name = "terraformer_collider",
    description = "terraformer_collider",
    tiles = {"invisible.png"},
    drawtype = 'airlike',
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if minetest.get_meta(terraformer_pos):get_int("mese_on") == 0 then
                    local mese_heat = minetest.get_meta(terraformer_pos):get_int("mese_heat")
                    if power_on() and mese_heat <= 1 then
                        if minetest.get_node(terraformer_pos).name == "moontest_terraformer:terraformer_off" then
                            terraformer_start()
                        end
                        mese_heat = mese_heat + 1
                        minetest.get_meta(terraformer_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(terraformer_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(terraformer_pos):set_int("mese_on", 0)
            end
        },
    },
    light_source = 10
})

--terraforming
minetest.register_globalstep(function(dtime)
    if habitat_built == true then
        if power_on() then
            if terraformer_on() then
                terraform()
            elseif terraformer_off() then
                decay()
            end
        elseif terraformer_off() then
            decay()
        end
    end
end)

function terraform()
    terraformer_timer = terraformer_timer + 1
    if terraformer_timer == 5 then
        for _, player in pairs(minetest.get_connected_players()) do
            skybox.set(player, 2)
            player:set_physics_override({gravity = 1})
        end
        for name, level in pairs(oxygen_levels) do
            oxygen_levels[name] = 100
        end
        for name, level in pairs(temperature_levels) do
            temperature_levels[name] = 100
        end
        if p_x < terraformer_limit then
            for p_z = -terraformer_limit, terraformer_limit, 1 do
                local pos = vector.new(p_x, 0, p_z)
                local rock_pos = vector.new(p_x, 1, p_z)
                if minetest.get_node(pos).name == "moontest:moon_surface" then
                    minetest.set_node(pos, {name="moontest_terraformer:grass"})
                end
                if minetest.get_node(rock_pos).name == "moontest:moon_rock" then
                    minetest.set_node(rock_pos, {name="moontest_terraformer:tree"})
                end
            end
            p_x = p_x + 1
        end
    elseif terraformer_timer == 10 then
        if n_x > -terraformer_limit then
            for n_z = terraformer_limit, -terraformer_limit, -1 do
                local pos = vector.new(n_x, 0, n_z)
                local rock_pos = vector.new(n_x, 1, n_z)
                if minetest.get_node(pos).name == "moontest:moon_surface" then
                    minetest.set_node(pos, {name="moontest_terraformer:grass"})
                end
                if minetest.get_node(rock_pos).name == "moontest:moon_rock" then
                    minetest.set_node(rock_pos, {name="moontest_terraformer:tree"})
                end
            end
            n_x = n_x - 1
        end
        for index, alien in pairs(aliens) do
            alien:remove()
            aliens[index] = nil
        end
        minetest.sound_play('terraformer', {
            pos = terraformer_pos,
            max_hear_distance = 16
        })
        tf_work = math.random(0, 500)
        terraformer_timer = 0
    end
    if n_x == -terraformer_limit and p_x == terraformer_limit then
        previous_tf_limit = terraformer_limit
        terraformer_limit = terraformer_limit * 2
        p_x = -terraformer_limit
        p_z = -terraformer_limit
        n_x = terraformer_limit
        n_z = terraformer_limit
    end
end

function decay()
    if terraformer_limit <= previous_tf_limit then
        terraformer_timer = terraformer_timer + 1
        if terraformer_timer == 5 then
            for _, player in pairs(minetest.get_connected_players()) do
                skybox.set(player, 1)
            end
            if p_x < terraformer_limit then
                for p_z = -terraformer_limit, terraformer_limit, 1 do
                    local pos = vector.new(p_x, 0, p_z)
                    local rock_pos = vector.new(p_x, 1, p_z)
                    if minetest.get_node(pos).name == "moontest_terraformer:grass" then
                        minetest.set_node(pos, {name="moontest:moon_surface"})
                    end
                    if minetest.get_node(rock_pos).name == "moontest_terraformer:tree" then
                        minetest.set_node(rock_pos, {name="moontest:moon_rock"})
                    end
                end
                p_x = p_x + 1
            end
        elseif terraformer_timer == 10 then
            if n_x > -terraformer_limit then
                for n_z = terraformer_limit, -terraformer_limit, -1 do
                    local pos = vector.new(n_x, 0, n_z)
                    local rock_pos = vector.new(n_x, 1, n_z)
                    if minetest.get_node(pos).name == "moontest_terraformer:grass" then
                        minetest.set_node(pos, {name="moontest:moon_surface"})
                    end
                    if minetest.get_node(rock_pos).name == "moontest_terraformer:tree" then
                        minetest.set_node(rock_pos, {name="moontest:moon_rock"})
                    end
                end
                n_x = n_x - 1
            end
            tf_work = 0
            terraformer_timer = 0
        end
        if n_x == -terraformer_limit and p_x == terraformer_limit then
            terraformer_limit = terraformer_limit * 2
            p_x = -terraformer_limit
            p_z = -terraformer_limit
            n_x = terraformer_limit
            n_z = terraformer_limit
        end
    end
end

--returns true if the terraformer is on
function terraformer_on()
    return minetest.get_node(terraformer_pos).name == "moontest_terraformer:terraformer_on"
end

--returns true if the terraformer exists and is off
function terraformer_off()
    return minetest.get_node(terraformer_pos).name == "moontest_terraformer:terraformer_off"
end

--creates the terraformer
function build_terraformer()
    for x = -4,4,1 do
        for z = -4,4,1 do
            for y = 8,12,1 do
                minetest.set_node(vector.new(x, y, z), {name="moontest_terraformer:terraformer_collider"})
            end
        end
    end
    minetest.set_node(terraformer_pos, {name="moontest_terraformer:terraformer_on"})
end

--starts the terraformer
function terraformer_start()
    terraformer_limit = 125
    minetest.set_node(terraformer_pos, {name = "moontest_terraformer:terraformer_on"})
end

--shuts down the terraformer
function terraformer_shutdown()
    terraformer_limit = 125
    minetest.set_node(terraformer_pos, {name = "moontest_terraformer:terraformer_off"})
end

--handles interactions
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    if node.name == "moontest_terraformer:terraformer_collider" and terraformer_on() then
        terraformer_shutdown()
        add_hud_message("moontest_terraformer: off")     
    elseif node.name == "moontest_terraformer:terraformer_collider" and terraformer_on() == false and power_on() then
        terraformer_start()
        add_hud_message("moontest_terraformer: on")
    end
end)