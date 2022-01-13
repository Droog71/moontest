--[[
    Work Lights
    Author: Droog71
    Version: 1.0.0
    License: AGPLv3
]]--

--flashlight
minetest.register_craftitem("work_lights:flashlight", {
    description = "Flashlight.",
    inventory_image = "flashlight.png",
    light_source = 14
})

--work light on
minetest.register_node("work_lights:work_light_on", {
    name = "work_light_on",
    description = "Work Light\nMust be placed within 10 meters of a generator.",
    tiles = {"work_light_tex.png"},
    drawtype = 'mesh',
    mesh = "work_light.obj",
    inventory_image = "work_light_inv.png",
    paramtype2="facedir",
    groups = {dig_immediate=2},
    drop = "work_lights:work_light_off",
    light_source = 14,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        for i,p in pairs(power_consumers) do
            if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                table.remove(power_consumers, i)
                break
            end
        end
    end
})

--work light off
minetest.register_node("work_lights:work_light_off", {
    name = "work_light_off",
    description = "Work Light\nRequires a solar panel and a logical switch to operate.",
    tiles = {"work_light_tex.png"},
    drawtype = 'mesh',
    mesh = "work_light.obj",
    inventory_image = "work_light_inv.png",
    paramtype2="facedir",
    groups = {dig_immediate=2},
})

--work_light_on abm
minetest.register_abm({
    nodenames = {"work_lights:work_light_on"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        if is_consumer(pos) == false then
            table.insert(power_consumers, pos)
        elseif power_stable(pos) == false then
            minetest.set_node(pos, { name = "work_lights:work_light_off" })
        end
    end
})

--work_light_off abm
minetest.register_abm({
    nodenames = {"work_lights:work_light_off"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        if is_consumer(pos) == false then
            table.insert(power_consumers, pos)
        elseif power_stable(pos) == true then
            minetest.set_node(pos, { name = "work_lights:work_light_on" })
        end
    end
})