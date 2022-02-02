--[[
    Portable Power
    Author: Droog71
    License: AGPLv3
]]--

power_producers = {}
power_consumers = {}
generator_sounds = {}

dofile(minetest.get_modpath("moontest_power") .. DIR_DELIM .. "nodes.lua")
dofile(minetest.get_modpath("moontest_power") .. DIR_DELIM .. "abm.lua")

--fuel
minetest.register_craftitem("moontest_power:fuel", {
    description = "Fuel.\nAdd to the inventory of a generator.",
    inventory_image = "fuel.png"
})

function clear_power(pos)
    for z = pos.z + 1, pos.z + 20, 1 do
        local hit = vector.new(pos.x, pos.y, z)
        if minetest.get_node(hit).name == "moontest_power:power_z" then
            minetest.remove_node(hit)
        end
    end
    for z = pos.z - 1, pos.z - 20, -1 do
        local hit = vector.new(pos.x, pos.y, z)
        if minetest.get_node(hit).name == "moontest_power:power_z" then
            minetest.remove_node(hit)
        end
    end
    for x = pos.x + 1, pos.x + 20, 1 do
        local hit = vector.new(x, pos.y, pos.z)
        if minetest.get_node(hit).name == "moontest_power:power_x" then
            minetest.remove_node(hit)
        end
    end
    for x = pos.x - 1, pos.x - 20, -1 do
        local hit = vector.new(x, pos.y, pos.z)
        if minetest.get_node(hit).name == "moontest_power:power_x" then
            minetest.remove_node(hit)
        end
    end
    for y = pos.y + 1, pos.y + 20, 1 do
        local hit = vector.new(pos.x, y, pos.z)
        if minetest.get_node(hit).name == "moontest_power:power_y" then
            minetest.remove_node(hit)
        end
    end
    for y = pos.y - 1, pos.y - 20, -1 do
        local hit = vector.new(pos.x, y, pos.z)
        if minetest.get_node(hit).name == "moontest_power:power_y" then
            minetest.remove_node(hit)
        end
    end
end

--returns true if power is present at the given location
function power_stable(pos)
    local local_producers = 0
    for index,producer in pairs(power_producers) do
        if vector.distance(producer, pos) <= 1 then
            return true
        end
    end
end

--returns true if the node is an active producer of power
function is_producer(pos)
    for _,p in pairs(power_producers) do
        if p.x == pos.x and p.y == pos.y and p.z == pos.z then
            return true
        end
    end
    return false
end

--returns true if the node is an active consumer of power
function is_consumer(pos)
    for i,p in pairs(power_consumers) do
        if p.x == pos.x and p.y == pos.y and p.z == pos.z then
            return true
        end
    end
    return false
end

--for power transmitters
function transmitter_blocked(hit)
    local clear_nodes = {
        "air",
        "ignore",
        "moontest_power:power_x",
        "moontest_power:power_y",
        "moontest_power:power_z"
    }
    local name = minetest.get_node(hit).name
    local reg = minetest.registered_nodes[name]
    if reg then
        local dt = minetest.registered_nodes[name]["drawtype"]
        local dt_clear = dt == "airlike"
        local name_clear = false
        for i = 1, 5, 1 do
            if name == clear_nodes[i] then
                name_clear = true
                break
            end
        end
        if name_clear == false and dt_clear == false then
            return true
        end
    end
    return false
end

--for solar panels
function solar_blocked(pos)
    if terraformer_on() == false then
        return true
    end
    for y = pos.y + 1, 100, 1 do
        local above = vector.new(pos.x, y, pos.z)
        local name = minetest.get_node(above).name
        local dt = minetest.registered_nodes[name]["drawtype"]
        local name_clear = name == "air" or name == "ignore"
        local dt_clear = dt == "airlike" or dt == "glasslike" or dt == "glasslike_framed"
        if name_clear == false and dt_clear == false then
            return true
        end
    end
    return false
end
