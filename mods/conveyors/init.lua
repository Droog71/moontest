--[[
    Conveyors
    Author: Droog71
    License: AGPLv3
]]--

dofile(minetest.get_modpath("conveyors") .. DIR_DELIM .. "nodes.lua")
dofile(minetest.get_modpath("conveyors") .. DIR_DELIM .. "abm.lua")
dofile(minetest.get_modpath("conveyors") .. DIR_DELIM .. "mesh.lua")

--returns true if the vectors are equal
local function vector_equal(v1, v2)
   return v1.x == v2.x and v1.y == v2.y and v1.z == v2.z
end

--returns true if the node is a conveyor
function is_conveyor(name)
    return name == "conveyors:conveyor" or 
        name == "conveyors:conveyor_x" or 
        name == "conveyors:conveyor_y" or 
        name == "conveyors:conveyor_z" or
        name == "conveyors:conveyor_north_up" or
        name == "conveyors:conveyor_south_up" or
        name == "conveyors:conveyor_east_up" or
        name == "conveyors:conveyor_west_up" or
        name == "conveyors:conveyor_north_down" or
        name == "conveyors:conveyor_south_down" or
        name == "conveyors:conveyor_east_down" or
        name == "conveyors:conveyor_west_down" or
        name == "conveyors:conveyor_south_east" or
        name == "conveyors:conveyor_south_west" or
        name == "conveyors:conveyor_north_east" or
        name == "conveyors:conveyor_north_west"
end

--gets the location of the inventory the conveyor is pulling from
local function get_pull_dir(pos)
    local x = minetest.get_meta(pos):get_int("pull_dir_x")
    local y = minetest.get_meta(pos):get_int("pull_dir_y") 
    local z = minetest.get_meta(pos):get_int("pull_dir_z")
    return vector.new(x, y, z)
end

--sets the location of the inventory the conveyor is pulling from
local function set_pull_dir(pos, dir)
    minetest.get_meta(pos):set_int("pull_dir_x", dir.x)
    minetest.get_meta(pos):set_int("pull_dir_y", dir.y) 
    minetest.get_meta(pos):set_int("pull_dir_z", dir.z)
end

--gets the location of the inventory the conveyor is supplying items to
local function get_put_dir(pos)
    local x = minetest.get_meta(pos):get_int("put_dir_x")
    local y = minetest.get_meta(pos):get_int("put_dir_y")
    local z = minetest.get_meta(pos):get_int("put_dir_z")
    return vector.new(x, y, z)
end

--sets the location of the inventory the conveyor is supplying items to
local function set_put_dir(pos, dir)
    minetest.get_meta(pos):set_int("put_dir_x", dir.x)
    minetest.get_meta(pos):set_int("put_dir_y", dir.y)
    minetest.get_meta(pos):set_int("put_dir_z", dir.z)
end

--moves items along the conveyor path
function move_items(pos, node, active_object_count, active_object_count_wider)
    local north = vector.new(pos.x + 1, pos.y, pos.z)
    local south = vector.new(pos.x - 1, pos.y, pos.z)
    local east = vector.new(pos.x, pos.y, pos.z + 1)
    local west = vector.new(pos.x, pos.y, pos.z - 1)
    local up = vector.new(pos.x, pos.y + 1, pos.z)
    local down = vector.new(pos.x, pos.y - 1, pos.z)
    local directions = {north, south, east, west, up, down}
    local pull_dir = get_pull_dir(pos)
    local put_dir = get_put_dir(pos)
    local stack_to_send = nil
    
    local self_inv = minetest.get_meta(pos):get_inventory()
    local filter_stack = self_inv:get_stack("filter", 1)
    local filter = ""
    if filter_stack then
        filter = filter_stack:get_name()
    end
    
    for _,dir in pairs(directions) do
        local conveyor = is_conveyor(minetest.get_node(dir).name)
        local puller = minetest.get_meta(pos):get_int("puller")
        if conveyor or puller == 1 then
            if not vector_equal(dir, get_put_dir(pos)) then
                local inv = minetest.get_meta(dir):get_inventory()
                local main = inv:get_list("main")
                local dst = inv:get_list("dst")
                if main then
                    for k,v in pairs(main) do
                        local stack = inv:get_stack("main", k)
                        if stack then
                            if stack:get_name() ~= "" then
                                if filter == "" or filter == stack:get_name() then
                                    stack_to_send = stack:get_name()
                                    local to_remove = ItemStack(stack_to_send)
                                    inv:remove_item("main", to_remove)
                                    set_pull_dir(pos, dir)
                                    break
                                end
                            end
                        end
                    end
                elseif dst then
                    for k,v in pairs(dst) do
                        local stack = inv:get_stack("dst", k)
                        if stack then
                            if stack:get_name() ~= "" then
                                if filter == "" or filter == stack:get_name() then
                                    stack_to_send = stack:get_name()
                                    local to_remove = ItemStack(stack_to_send)
                                    inv:remove_item("dst", to_remove)
                                    set_pull_dir(pos, dir)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    if stack_to_send then
        for _,dir in pairs(directions) do
            if not vector_equal(dir, get_pull_dir(pos)) then
                local inv = minetest.get_meta(dir):get_inventory()
                local sending = ItemStack(stack_to_send)
                local main = inv:get_list("main")
                local src = inv:get_list("src")
                if main then
                    inv:add_item("main", sending)
                    set_put_dir(pos, dir)
                elseif src then
                    inv:add_item("src", sending)
                    set_put_dir(pos, dir)
                end
            end
        end
    else
        local self_inv = minetest.get_meta(pos):get_inventory()
        local main = self_inv:get_list("main")
        if main then
            for k,v in pairs(main) do
                local stack = self_inv:get_stack("main", k)
                if stack then
                    if stack:get_name() ~= "" then
                        stack_to_send = stack:get_name()
                        for _,dir in pairs(directions) do
                            if not is_conveyor(minetest.get_node(dir).name) then
                                local put_inv = minetest.get_meta(dir):get_inventory()
                                local main = put_inv:get_list("main")
                                local src = put_inv:get_list("src")
                                if main then
                                    local sending = ItemStack(stack_to_send)
                                    self_inv:remove_item("main", sending)
                                    put_inv:add_item("main", sending)
                                    set_put_dir(pos, dir)
                                    break
                                elseif src then
                                    local sending = ItemStack(stack_to_send)
                                    self_inv:remove_item("main", sending)
                                    put_inv:add_item("src", sending)
                                    set_put_dir(pos, dir)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
