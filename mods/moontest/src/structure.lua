--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--builds an exterior wall
function build_wall_one()
    for y = 0,8,1 do
        for z = -25,25,1 do
            local node_pos = vector.new(25, y, z)
            if y >= 2 and y <= 5 then
                if z >= -5 and z <= 5 then
                    minetest.set_node(node_pos, {name = "moontest:glass"})
                else
                    minetest.set_node(node_pos, {name = "moontest:wall"})
                end
            else
                minetest.set_node(node_pos, {name = "moontest:wall"})
            end
        end
    end
end

--builds an exterior wall
function build_wall_two()
    for y = 0,8,1 do 
        for z = -25,25,1 do 
            local node_pos = vector.new(-25, y, z)
            if y >= 2 and y <= 5 then
                if z >= -5 and z <= 5 then
                    minetest.set_node(node_pos, {name = "moontest:glass"})
                else
                    minetest.set_node(node_pos, {name = "moontest:wall"})
                end
            else
                minetest.set_node(node_pos, {name = "moontest:wall"})
            end
        end
    end
end

--builds an exterior wall
function build_wall_three()
    for y = 0,8,1 do
        for x = -25,25,1 do
            local node_pos = vector.new(x, y, 25)
            if y >= 1 and y <= 5 then
                if x >= -2 and x <= 2 then
                    minetest.set_node(node_pos, {name = "moontest:airlock"})
                else
                    if y == 2 and x == 4 then
                        minetest.set_node(node_pos, {name = "moontest:airlock_controller_on"})
                    else
                        minetest.set_node(node_pos, {name = "moontest:wall"})
                    end
                end
            else
                if y == 0 and x >= -2 and x <= 2 then
                    minetest.set_node(node_pos, {name = "moontest:floor"})
                else
                    minetest.set_node(node_pos, {name = "moontest:wall"})
                end
            end
        end
    end
end

--builds an exterior wall
function build_wall_four()
    for y = 0,8,1 do 
        for x = -25,25,1 do 
            local node_pos = vector.new(x, y, -25)
            if y >= 2 and y <= 5 then
                if x >= -5 and x <= 5 then
                    minetest.set_node(node_pos, {name = "moontest:glass"})
                else
                    minetest.set_node(node_pos, {name = "moontest:wall"})
                end
            else
                minetest.set_node(node_pos, {name = "moontest:wall"})
            end
        end
    end
end

--builds the floor
function build_floor()
    for x = -24,24,1 do
        for z = -24,24,1
        do
            local node_pos = vector.new(x, 0, z)
            minetest.set_node(node_pos, {name = "moontest:floor"})
        end
    end
end

--builds the roof
function build_roof()
    for x = -24,24,1 do
        for z = -24,24,1
        do
            local node_pos = vector.new(x, 7, z)
            minetest.set_node(node_pos, {name = "moontest:floor"})
        end
    end
end

--builds the air ducts
function build_ducts()
    for z = -16,16,4 do
        if z > 4 or z < -4 then
            for x = -24,24,1 do          
                minetest.set_node(vector.new(x, 5, z), {name = "moontest:duct"})
            end
            for vent_x = -18,18,6 do
                minetest.set_node(vector.new(vent_x, 4, z), {name = "moontest:vent"})
            end
        end
    end
    
    for z = -16,16,1 do          
        minetest.set_node(vector.new(9, 5, z), {name = "moontest:duct"})
    end
    
    for z = -16,16,1 do          
        minetest.set_node(vector.new(-9, 5, z), {name = "moontest:duct"})
    end
    
    for z = -16,-20,-1 do
        minetest.set_node(vector.new(11, 5, z), {name = "moontest:duct"})
    end
    
    for y = 5,2,-1 do 
        minetest.set_node(vector.new(11, y, -20), {name = "moontest:duct"})
    end
    
    for z = -16,-20,-1 do
        minetest.set_node(vector.new(4, 5, z), {name = "moontest:duct"})
    end
    
    for y = 5,4,-1 do
        minetest.set_node(vector.new(4, y, -20), {name = "moontest:duct"})
    end
end

--builds the light fixtures
function build_lights()
    for z = -22,22,4 do
        for x = -22,22,6 do
            if x ~= -10 and x ~= 8 and not (x == -16 and z == -18) then
                minetest.set_node(vector.new(x, 5, z), {name = "moontest:light_on"})
            end
        end
    end
	minetest.set_node(vector.new(-7,5,26), {name = "moontest:exterior_light_on"})
	minetest.set_node(vector.new(7,5,26), {name = "moontest:exterior_light_on"})
end

--builds the consoles
function build_consoles()
    for z = -5,5,5 do
        minetest.set_node(vector.new(7,1,z), {name = "moontest:console"}) 
    end
    for y = 1,2,1 do
        for z = -6,6,1 do
            for x = 6,7,1 do
                if y == 1 and z ~= -5 and z ~= 0 and z ~= 5 then
                    minetest.set_node(vector.new(x,y,z), {name = "moontest:invisible"})
                elseif y == 2 then
                    minetest.set_node(vector.new(x,y,z), {name = "moontest:invisible"})
                end
            end
        end
    end

    for z = -5,5,5 do
       minetest.set_node(vector.new(-7,1,z), {name = "moontest:console_2"}) 
    end
    for y = 1,2,1 do
        for z = -6,6,1 do
            for x = -7,-6,1 do
                if y == 1 and z ~= -5 and z ~= 0 and z ~= 5 then
                    minetest.set_node(vector.new(x,y,z), {name = "moontest:invisible"})
                elseif y == 2 then
                    minetest.set_node(vector.new(x,y,z), {name = "moontest:invisible"})
                end
            end
        end
    end
end