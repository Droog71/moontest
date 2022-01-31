--[[
    REM
    Author: Droog71
    License: AGPLv3
]]--

--rem
minetest.register_craftitem("rem:rare_earth_metals", {
    description = "Rare Earth Metals.\nSend them back to the planet to be sold.",
    inventory_image = "rem.png"
})

--extractor node
minetest.register_node("rem:extractor", {
    description = "Extractor\nMines rare earth metals.\n" ..
    "Place anywhere outside the habitat.\n" ..
    "More effective the farther it is placed from the habitat\n" ..
    "and from other extractors.",
    tiles = {"extractor.png"},
    drawtype = 'mesh',
    mesh = "extractor.obj",
    groups = {dig_immediate=2},
    paramtype2="facedir",
    on_construct = function(pos)
        table.insert(power_consumers, pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
            "size[8,9]"..
            "list[current_name;main;0,0;8,4;]"..
            "list[current_player;main;0,5;8,4;]" ..
            "listring[]")
        local inv = meta:get_inventory()
        inv:set_size("main", 4*1)
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local name = placer:get_player_name()
        if inside_habitat(name) then
            minetest.remove_node(pos)
            minetest.chat_send_player(name, "You can't use that indoors.")
            return true
        end
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        for i,p in pairs(power_consumers) do
            if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                table.remove(power_consumers, i)
                break
            end
        end
    end,
    can_dig = function(pos,player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
       return stack:get_count()
    end
})

--rocket node
minetest.register_node("rem:rocket", {
    description = "REM Rocket\nTakes rare earth metals back to the planet.\n" ..
    "Will take off when loaded with a stack of 50 REM.",
    tiles = {"rocket.png"},
    drawtype = 'mesh',
    mesh = "rocket.obj",
    inventory_image = "wield_rocket.png",
    groups = {dig_immediate=2},
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local name = placer:get_player_name()
        if inside_habitat(name) then
            minetest.remove_node(pos)
            minetest.chat_send_player(name, "You can't use that indoors.")
            return true
        end
    end,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
            "size[8,9]"..
            "list[current_name;main;0,0;8,4;]"..
            "list[current_player;main;0,5;8,4;]" ..
            "listring[]")
        local inv = meta:get_inventory()
        inv:set_size("main", 4*1)
    end,
    can_dig = function(pos,player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
       return stack:get_count()
    end
})

--operation of the extractor
minetest.register_abm({
    nodenames = {"rem:extractor"},
    interval = 10,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local under_pos = vector.new(pos.x, pos.y - 1, pos.z)
        local node_name = minetest.get_node(under_pos).name
        if node_name == "moontest:surface" or node_name == "terraformer:grass" then
            if is_consumer(pos) == false then
                table.insert(power_consumers, pos)
            elseif power_stable(pos) or power == 1 then
                minetest.get_meta(pos):set_int("power", 0)
                local chance = math.random(1,100)
                if chance >= 50 then
                    local habitat_range = vector.distance(vector.new(0, 0, 0), pos)
                    local other_range = 0
                    for i,p in pairs(power_consumers) do
                        if minetest.get_node(p).name == "rem:extractor" then
                            local dist = vector.distance(pos, p)
                            if dist > other_range then other_range = dist end
                        end
                    end
                    local median_range = (habitat_range + other_range) / 2
                    local amount = math.floor(median_range * 0.025)
                    if amount < 1 then amount = 1 end
                    if amount > 5 then amount = 5 end
                    local meta = minetest.get_meta(pos)
                    local inv = meta:get_inventory()
                    local stack = ItemStack("rem:rare_earth_metals")
                    stack:set_count(amount)
                    if inv:add_item("main", stack) then
                        minetest.sound_play('extractor', {
                            pos = pos,
                            gain = 0.5,
                            max_hear_distance = 16
                        })
                        minetest.add_particlespawner({
                            amount = 1,
                            time = 1,
                            minpos = {x=pos.x-0.1,y=pos.y+1,z=pos.z-0.1},
                            maxpos = {x=pos.x+0.1,y=pos.y+2,z=pos.z+0.1},
                            minvel = {x=0.1, y=0.01, z=0.1},
                            maxvel = {x=0.1, y=0.05, z=0.1},
                            minacc = {x=-0.1,y=0.1,z=-0.1},
                            maxacc = {x=0.1,y=0.2,z=0.1},
                            minexptime = 1,
                            maxexptime = 2,
                            minsize = 4,
                            maxsize = 6,
                            collisiondetection = false,
                            vertical = false,
                            texture = "rem.png"
                        })
                    end
                end
            end
            local power_disp = (power_stable(pos) or power == 1) and "on" or "off"
            minetest.get_meta(pos):set_string("infotext", "REM Extractor\n" .. "Power: " .. power_disp)
        end
    end
})

--rocket exhaust effects
local function rocket_exhaust(pos)
    minetest.sound_play('rocket', {
        pos = pos,
        max_hear_distance = 16
    })
    minetest.add_particlespawner({
        amount = 600,
        time = 3,
        minpos = {x=pos.x,y=pos.y,z=pos.z},
        maxpos = {x=pos.x,y=pos.y,z=pos.z},
        minvel = {x=-0.4, y=-0.1, z=-0.4},
        maxvel = {x=0.4, y=-0.2, z=0.4},
        minacc = {x=-0.4,y=-0.1,z=-0.4},
        maxacc = {x=0.4,y=-0.2,z=0.4},
        minexptime = 6,
        maxexptime = 8,
        minsize = 6,
        maxsize = 8,
        collisiondetection = false,
        vertical = false,
        texture = "exhaust.png"
    })
end

--operation of the rocket
minetest.register_abm({
    nodenames = {"rem:rocket"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local stack = ItemStack("rem:rare_earth_metals")
        stack:set_count(50)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv:contains_item("main", stack) and pos.y < 50 then
            if meta:get_int("up") == 1 then
                local up = vector.new(pos.x, pos.y + 1, pos.z)
                minetest.set_node(up, { name = "rem:rocket"} )
                local new_inv = minetest.get_meta(up):get_inventory()
                new_inv:add_item("main", stack)
                minetest.remove_node(pos)
                meta:set_int("up", 0)
            else
                if pos.y == 1 then
                    rocket_exhaust(pos)
                end
                meta:set_int("up", 1)
            end
        elseif pos.y > 1 then
            if pos.y == 50 then
                money = money + 5000
                total_ore_mined = total_ore_mined + 5000
                add_hud_message("Rocket delivered $5000 worth of REM.")
            end
            local down = vector.new(pos.x, pos.y - 1, pos.z)
            minetest.set_node(down, { name = "rem:rocket"} )
            minetest.remove_node(pos)
            if pos.y == 2 then
                rocket_exhaust(down)
            end
        end
    end
})