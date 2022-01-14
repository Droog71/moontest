--[[
    Moon Habitat Simulator
    Version: 1.0.5
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--builds the break room
function build_break_room()
    for y = 1,6,1 do 
        for z = -18,-24,-1 do
            minetest.set_node(vector.new(14, y, z), {name = "moontest:wall"})
        end
    end 
    
    for y = 1,6,1 do 
        for x = 24,21,-1 do
            minetest.set_node(vector.new(x, y, -17), {name = "moontest:wall"})
        end
    end
    
    for y = 1,6,1 do 
        for x = 17,14,-1 do
            minetest.set_node(vector.new(x, y, -17), {name = "moontest:wall"})
        end
    end
    
    for x = 20,18,-1 do
        minetest.set_node(vector.new(x, 6, -17), {name = "moontest:wall"})
    end
    
    for x = 19,24,1 do
        minetest.set_node(vector.new(x, 4, -24), {name = "moontest:cabinet"})
    end
    
    minetest.set_node(food_vending_top_pos, {name = "moontest:food_vending_top"})
    minetest.set_node(food_vending_bottom_pos, {name = "moontest:food_vending_bottom"})
    minetest.set_node(vector.new(22, 1, -24), {name = "moontest:refridgerator"})
    minetest.set_node(vector.new(22, 2, -24), {name = "moontest:invisible"})
    minetest.set_node(vector.new(24, 1, -24), {name = "moontest:counter"})
    minetest.set_node(vector.new(23, 1, -24), {name = "moontest:counter"})
    minetest.set_node(vector.new(21, 1, -24), {name = "moontest:counter"})
    minetest.set_node(vector.new(20, 1, -24), {name = "moontest:sink"})
    minetest.set_node(vector.new(19, 1, -24), {name = "moontest:counter"})
    minetest.set_node(vector.new(19, 2, -24), {name = "moontest:microwave"})
    minetest.set_node(vector.new(17, 1, -20), {name = "moontest:table"})
    minetest.set_node(vector.new(16, 1, -20), {name = "moontest:chair"})
    minetest.set_node(vector.new(17, 1, -21), {name = "moontest:chair"}) 
end

--builds the sleeping room
function build_sleeping_room()
    for y = 1, 6 do
        for z = -7,7,1 do
            minetest.set_node(vector.new(-8, y, z), {name = "moontest:wall"})
        end
    end
    
    for y = 1, 6 do
        for x = -8,-24,-1 do
            minetest.set_node(vector.new(x, y, 7), {name = "moontest:wall"})
        end
    end
    
    for y = 1, 6 do
        for x = -8,-14,-1 do
            minetest.set_node(vector.new(x, y, -7), {name = "moontest:wall"})
        end
    end
    
    for y = 1, 6 do
        for x = -18,-24,-1 do
            minetest.set_node(vector.new(x, y, -7), {name = "moontest:wall"})
        end
    end
    
    for x = -19,-23,-1 do
        minetest.set_node(vector.new(x, 1, -6), {name = "moontest:sofa"})
    end
    
    for x = -15,-17,-1 do
        minetest.set_node(vector.new(x, 6, -7), {name = "moontest:wall"})
    end
    
    for x = -9,-24,-1 do
        minetest.set_node(vector.new(x, 1, 6), {name = "moontest:counter"})
    end
    
    for x = -9,-24,-1 do
        minetest.set_node(vector.new(x, 3, 6), {name = "moontest:cabinet"})
    end
    
    for x = -20,-10,4 do
        minetest.set_node(vector.new(x, 1, 0), {name = "moontest:bunkbed"})
    end
    
    for x = -20,-10,4 do
        for z = -1,1,1 do
            for y = 2, 4 do
                if not ((z == 0 and y == 2) or z == 0 and y == 3) then
                    minetest.set_node(vector.new(x, y, z), {name = "moontest:invisible"}) 
                end
            end
        end
    end
    
    minetest.set_node(vector.new(-9, 4, -4), {name = "moontest:vent"})
    minetest.set_node(vector.new(-9, 4, 4), {name = "moontest:vent"})
end

--builds the gravity generator room
function build_gravity_room()
    for y = 1, 6 do
        for z = -7,7,1 do
            minetest.set_node(vector.new(8, y, z), {name = "moontest:wall"})
        end
    end
    for y = 1, 6 do
        for x = 8,24,1 do
            minetest.set_node(vector.new(x, y, 7), {name = "moontest:wall"})
        end
    end
    for y = 1, 6 do
        for x = 8,14,1 do
            minetest.set_node(vector.new(x, y, -7), {name = "moontest:wall"})
        end
    end
    for y = 1, 6 do
        for x = 18,24,1 do
            minetest.set_node(vector.new(x, y, -7), {name = "moontest:wall"})
        end
    end
    for x = 15,17,1 do
        minetest.set_node(vector.new(x, 6, -7), {name = "moontest:wall"})
    end
    
    minetest.set_node(vector.new(9, 4, -4), {name = "moontest:vent"})
    minetest.set_node(vector.new(9, 4, 4), {name = "moontest:vent"})
end

--builds the bathroom
function build_bathroom()
   for y = 1,6,1 do 
        for x = -24,-14,1 do 
            minetest.set_node(vector.new(x, y, -14), {name = "moontest:wall"})
        end
    end  
    
    for y = 1,6,1 do 
        for x = -22,-14,1 do 
            minetest.set_node(vector.new(x, y, -17), {name = "moontest:wall"})
        end
    end  
    
    for y = 1,6,1 do 
        for z = -18,-24,-1 do 
            minetest.set_node(vector.new(-14, y, z), {name = "moontest:wall"})
        end
    end  
    
    for y = 1,6,1 do 
        for x = -15,-18,-1 do
            minetest.set_node(vector.new(x, y, -21), {name = "moontest:glass"})
        end
    end 
    
    for z = -17,-20,-1 do
        minetest.set_node(vector.new(-24, 5, z), {name = "moontest:duct"})
    end
    
    minetest.set_node(vector.new(-24, 4, -20), {name = "moontest:vent"})
    minetest.set_node(vector.new(-17, 1, -24), {name = "moontest:toilet"})
    minetest.set_node(vector.new(-22, 1, -24), {name = "moontest:counter"})
    minetest.set_node(vector.new(-23, 1, -24), {name = "moontest:sink"})
    minetest.set_node(vector.new(-24, 1, -24), {name = "moontest:counter"})
    minetest.set_node(vector.new(-16, 6, -19), {name = "moontest:vertical_pipe"})
    minetest.set_node(vector.new(-16, 5, -19), {name = "moontest:vertical_pipe"})
    minetest.set_node(vector.new(-16, 4, -19), {name = "moontest:shower"})
    minetest.set_node(vector.new(-16, 0, -19), {name = "moontest:floor_drain"})
end

--builds the garage
function build_garage() 
    local crates_exist = false
    
    minetest.set_node(vector.new(15, 1, 20), {name = "moontest:hovercraft"})
    minetest.set_node(vector.new(-15, 1, 20), {name = "moontest:hovercraft_2"})
    
    for x = 12,18,1 do
        for z = 19,22,1 do
            for y = 2, 3 do
                minetest.set_node(vector.new(x, y, z), {name = "moontest:invisible"}) 
            end
        end
    end
    
    for x = -12,-18,-1 do
        for z = 19,22,1 do
            for y = 2, 3 do
                minetest.set_node(vector.new(x, y, z), {name = "moontest:invisible"}) 
            end
        end
    end
    
    for y = 1,2,1 do
        for x = -24,-9,1 do
            for z = 8,16,1 do
                if minetest.get_node(vector.new(x, y, z)).name == "moontest:crate" then
                    crates_exist = true
                end
            end
        end
    end
    
    if crates_exist == false then
        for y = 1,2,1 do
            for x = -24,-9,1 do
                for z = 8,16,1 do
                    if math.random(0, 100) > y * 40 then
                        if y == 1 or (y == 2 and minetest.get_node(vector.new(x, 1, z)).name == "moontest:crate") then
                            minetest.set_node(vector.new(x, y, z), {name = "moontest:crate"})
                        end
                    end
                end
            end
        end
        
        for y = 1,2,1 do
            for x = 9,24,1 do
                for z = 8,16,1 do
                    if math.random(0, 100) > y * 40 then
                        if y == 1 or (y == 2 and minetest.get_node(vector.new(x, 1, z)).name == "moontest:crate") then
                            minetest.set_node(vector.new(x, y, z), {name = "moontest:crate"})
                        end
                    end
                end
            end
        end
    end
end