--[[
    Portable Power
    Author: Droog71
    License: AGPLv3
]]--

--solar panel abm
minetest.register_abm({
    nodenames = {"portable_power:solar_panel"},
    interval = 10,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local active = is_producer(pos)
        if not solar_blocked(pos) then
            if active == false then
                table.insert(power_producers, pos)
            end
        else
            if active == true then
                for i,p in pairs(power_producers) do
                    if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                        table.remove(power_producers, i)
                        break
                    end
                end
            end
        end
        local power_disp = is_producer(pos) and "on" or "off"
        minetest.get_meta(pos):set_string("infotext", "Solar Panel\n" .. "Power: " .. power_disp)
    end
})

minetest.register_abm({
    nodenames = {"portable_power:generator"},
    interval = 10,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local has_fuel = false
        if inv:contains_item("main", "portable_power:fuel") then
            inv:remove_item("main", "portable_power:fuel")
            has_fuel = true
        end 
        local active = is_producer(pos)
        if has_fuel then
            if active == false then
                table.insert(power_producers, pos)
            end
            local pos_str = pos.x .. "," .. pos.y .. "," .. pos.z
            generator_sounds[pos_str] = minetest.sound_play('generator', {
                pos = pos,
                max_hear_distance = 8
            })
        else
            if active == true then
                for i,p in pairs(power_producers) do
                    if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                        table.remove(power_producers, i)
                        break
                    end
                end
            end
        end
        local power_disp = is_producer(pos) and "on" or "off"
        minetest.get_meta(pos):set_string("infotext", "Generator\n" .. "Power: " .. power_disp)
    end
})

--power transmitter abm
minetest.register_abm({
    nodenames = {"portable_power:power_transmitter"},
    interval = 2,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local power = minetest.get_meta(pos):get_int("power")
        if is_consumer(pos) == false then
            table.insert(power_consumers, pos)
        elseif power_stable(pos) or power == 1 then
            minetest.get_meta(pos):set_int("power", 0)
            local distance = 0
            local dir = node.param2 / 4
            if dir ~= minetest.get_meta(pos):get_float("old_dir") then
                minetest.get_meta(pos):set_float("old_dir", dir)
                clear_power(pos)
            end
            if dir == 1 then
                for y = pos.y + 1, pos.y + 20, 1 do
                    local hit = vector.new(pos.x, y, pos.z)
                    if is_consumer(hit) then
                        minetest.get_meta(hit):set_int("power", 1)
                        break
                    elseif transmitter_blocked(hit) then
                        break
                    else
                        distance = distance + 1
                        minetest.set_node(hit, {name="portable_power:power_y"})
                    end
                end
            elseif dir == 1.5 then
                for y = pos.y - 1, pos.y - 20, -1 do
                    local hit = vector.new(pos.x, y, pos.z)
                    if is_consumer(hit) then
                        minetest.get_meta(hit):set_int("power", 1)
                        break
                    elseif transmitter_blocked(hit) then
                        break
                    else
                        distance = distance + 1
                        minetest.set_node(hit, {name="portable_power:power_y"})
                    end
                end
            elseif dir == 0 then
                for z = pos.z - 1, pos.z - 20, -1 do
                    local hit = vector.new(pos.x, pos.y, z)
                    if is_consumer(hit) then
                        minetest.get_meta(hit):set_int("power", 1)
                        break
                    elseif transmitter_blocked(hit) then
                        break
                    else
                        distance = distance + 1
                        minetest.set_node(hit, {name="portable_power:power_z"})
                    end
                end
            elseif dir == 0.5 then
                for z = pos.z + 1, pos.z + 20, 1 do
                    local hit = vector.new(pos.x, pos.y, z)
                    if is_consumer(hit) then
                        minetest.get_meta(hit):set_int("power", 1)
                        break
                    elseif transmitter_blocked(hit) then
                        break
                    else
                        distance = distance + 1
                        minetest.set_node(hit, {name="portable_power:power_z"})
                    end
                end
            elseif dir == 0.75 then
                for x = pos.x + 1, pos.x + 20, 1 do
                    local hit = vector.new(x, pos.y, pos.z)
                    if is_consumer(hit) then
                        minetest.get_meta(hit):set_int("power", 1)
                        break
                    elseif transmitter_blocked(hit) then
                        break
                    else
                        distance = distance + 1
                        minetest.set_node(hit, {name="portable_power:power_x"})
                    end
                end
            elseif dir == 0.25 then
                for x = pos.x - 1, pos.x - 20, -1 do
                    local hit = vector.new(x, pos.y, pos.z)
                    if is_consumer(hit) then
                        minetest.get_meta(hit):set_int("power", 1)
                        break
                    elseif transmitter_blocked(hit) then
                        break
                    else
                        distance = distance + 1
                        minetest.set_node(hit, {name="portable_power:power_x"})
                    end
                end
            else
                clear_power(pos)
            end
            if distance ~= minetest.get_meta(pos):get_int("old_distance") then
                minetest.get_meta(pos):set_int("old_distance", distance)
                clear_power(pos)
            end
            minetest.sound_play('power_transmitter', {
                pos = pos,
                max_hear_distance = 8
            })
        end
        local power_disp = (power_stable(pos) or power == 1) and "on" or "off"
        minetest.get_meta(pos):set_string("infotext", "Power Transmitter\n" .. "Power: " .. power_disp)
    end
})
