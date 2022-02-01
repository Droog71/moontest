--[[
    Conveyors
    Author: Droog71
    License: AGPLv3
]]--

function set_conveyor_mesh(pos)
    local north = minetest.get_node(vector.new(pos.x + 1, pos.y, pos.z)).name
    local south = minetest.get_node(vector.new(pos.x - 1, pos.y, pos.z)).name
    local east = minetest.get_node(vector.new(pos.x, pos.y, pos.z + 1)).name
    local west = minetest.get_node(vector.new(pos.x, pos.y, pos.z - 1)).name
    local up = minetest.get_node(vector.new(pos.x, pos.y + 1, pos.z)).name
    local down = minetest.get_node(vector.new(pos.x, pos.y - 1, pos.z)).name
    local dirs = {north, south, east, west, up, down}
    
    if is_conveyor(north) and is_conveyor(south) then
        if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_x" then
            minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_x"})
        end
    end
    
    if is_conveyor(up) and is_conveyor(down) then
        if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_y" then
            minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_y"})
        end
    end
    
    if is_conveyor(east) and is_conveyor(west) then
        if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_z" then
            minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_z"})
        end
    end
    
    if is_conveyor(north) == true and is_conveyor(south) == false then
        if is_conveyor(up) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_north_up" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_north_up"})
            end
        end
    end
    
    if is_conveyor(south) == true and is_conveyor(north) == false then
        if is_conveyor(up) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_south_up" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_south_up"})
            end
        end
    end
    
    if is_conveyor(east) == true and is_conveyor(west) == false then
        if is_conveyor(up) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_east_up" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_east_up"})
            end
        end
    end
    
    if is_conveyor(west) == true and is_conveyor(east) == false then
        if is_conveyor(up) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_west_up" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_west_up"})
            end
        end
    end
    
    if is_conveyor(north) == true and is_conveyor(south) == false then
        if is_conveyor(down) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_north_down" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_north_down"})
            end
        end
    end
    
    if is_conveyor(south) == true and is_conveyor(north) == false then
        if is_conveyor(down) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_south_down" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_south_down"})
            end
        end
    end
    
    if is_conveyor(east) == true and is_conveyor(west) == false then
        if is_conveyor(down) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_east_down" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_east_down"})
            end
        end
    end
    
    if is_conveyor(west) == true and is_conveyor(east) == false then
        if is_conveyor(down) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_west_down" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_west_down"})
            end
        end
    end
    
    if is_conveyor(south) == true and is_conveyor(north) == false then
        if is_conveyor(east) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_south_east" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_south_east"})
            end
        end
    end
    
    if is_conveyor(south) == true and is_conveyor(north) == false then
        if is_conveyor(west) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_south_west" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_south_west"})
            end
        end
    end
    
    if is_conveyor(north) == true and is_conveyor(south) == false then
        if is_conveyor(east) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_north_east" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_north_east"})
            end
        end
    end
    
    if is_conveyor(north) == true and is_conveyor(south) == false then
        if is_conveyor(west) then
            if minetest.get_node(pos).name ~= "moontest_conveyors:conveyor_north_west" then
                minetest.swap_node(pos, {name = "moontest_conveyors:conveyor_north_west"})
            end
        end
    end
    
    local count = 0
    for _,dir in pairs(dirs) do
        if is_conveyor(dir) then
            count = count + 1
        end
    end
    
    if count > 2 then
        minetest.remove_node(pos)
    end
end