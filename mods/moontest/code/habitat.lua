--[[
    Moon Habitat Simulator
    Version: 1.0.2
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "structure.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "rooms.lua")

habitat_built = false
pump_pos = vector.new(-4, 1, -20)
oxygen_generator_pos = vector.new(11, 1, -20)
reactor_pos = vector.new(0, 1, -14)
drill_pos = vector.new(0, 1, 35)
hvac_pos = vector.new(4, 3, -20)
gravity_generator_pos = vector.new(16, 1, 0)
food_vending_top_pos = vector.new(24, 2, -20)
food_vending_bottom_pos = vector.new(24, 1, -20)
airlock_controller_pos = vector.new(4, 2, 25)
airlock_pos = vector.new(0, 2, 25)
research_station_pos = vector.new(9,1,0)
computer_pos = vector.new(12,2,-6)

--builds the habitat, called 10 seconds after the world is created
function build_habitat()
    build_wall_one()
    build_wall_two()
    build_wall_three()
    build_wall_four()
    build_floor()
    build_roof()
    build_ducts()
    build_lights()
    build_sleeping_room()
    build_break_room()
    build_gravity_room()
    build_bathroom()
    build_garage()   
    build_consoles()
    build_reactor()
    build_oxygen_generator() 
    build_gravity_generator()
    build_hvac()
    build_drill()
    build_coolant_system()   
    build_research_station()   
end

--creates the drill mesh, colliders and GUI
function build_drill()
    for y = 1, 10 do
        for x = -2,2,1 do
            for z = 33,37,1 do
                minetest.set_node(vector.new(x, y, z), {name = "moontest:drill_collider"})
                minetest.get_meta(vector.new(x, y, z)):set_string("formspec",
                    "size[5,5]"..
                    "label[1.5,1;Mining Drill]"..
                    "field[1.8,3;2,1;Speed;Speed;]")
            end
        end
    end
    for x = -3,-5,-1 do
        for z = 35,38,1 do
            minetest.set_node(vector.new(x, 2, z), {name = "moontest:drill_collider"})
            minetest.get_meta(vector.new(x, 2, z)):set_string("formspec",
                "size[5,5]"..
                "label[1.5,1;Mining Drill]"..
                "field[1.8,3;2,1;Speed;Speed;]")
        end
    end
    for y = 1,4,1 do
        for z = 38,41,1 do
            minetest.set_node(vector.new(0, y, z), {name = "moontest:drill_collider"})
            minetest.get_meta(vector.new(0, y, z)):set_string("formspec",
                "size[5,5]"..
                "label[1.5,1;Mining Drill]"..
                "field[1.8,3;2,1;Speed;Speed;]")
        end
    end
    minetest.set_node(drill_pos, {name = "moontest:drill_on"})    
end

--creates the coolant pump mesh, pipes, coolant tank, colliders and GUI
function build_coolant_system()
    minetest.set_node(vector.new(-4, 2, -20), {name = "moontest:coolant_pipe_pump"})
    for y = 3,5,1 do
        minetest.set_node(vector.new(-4, y, -20), {name = "moontest:coolant_pipe_single_vertical_2"})
    end
    minetest.set_node(vector.new(-4, 6, -20), {name = "moontest:coolant_pipe_bend_1"})
    for z = -19,24,1 do
        minetest.set_node(vector.new(-4, 6, z), {name = "moontest:coolant_pipe_horizontal"})
    end
    for z = 26,36,1 do
        minetest.set_node(vector.new(-4, 6, z), {name = "moontest:coolant_pipe_horizontal"})
    end
    minetest.set_node(vector.new(-4, 6, 37), {name = "moontest:coolant_pipe_bend_2"})
    for y = 5,1,-1 do
        minetest.set_node(vector.new(-4, y, 37), {name = "moontest:coolant_pipe_vertical_2"})
    end
    for x = -5,-9,-1 do
        minetest.set_node(vector.new(x, 6, -20), {name = "moontest:coolant_pipe_single_horizontal_1"})
    end
    for x = -5,-9,-1 do
        minetest.set_node(vector.new(x, 2, -20), {name = "moontest:coolant_pipe_single_horizontal_2"})
    end
    minetest.set_node(vector.new(-10, 6, -20), {name = "moontest:coolant_pipe_single_bend_1"})
    for y = 5,2,-1 do
        minetest.set_node(vector.new(-10, y, -20), {name = "moontest:coolant_pipe_single_vertical_1"})
    end  
    minetest.set_node(vector.new(-10, 1, -20), {name = "moontest:coolant_tank"})
    minetest.set_node(vector.new(-11, 1, -20), {name = "moontest:invisible"})
    minetest.set_node(pump_pos, {name = "moontest:pump_on"}) 
    minetest.get_meta(pump_pos):set_string("formspec",
        "size[5,5]"..
        "label[1.5,1;Coolant Pump]"..
        "field[1.8,3;2,1;Speed;Speed;]")
    minetest.get_meta(pump_pos):set_int("mese_heat", 0)
    minetest.get_meta(pump_pos):set_int("mese_on", 0)
end

--creates the hvac system mesh, colliders and GUI
function build_hvac()
   minetest.set_node(vector.new(4, 1, -20), {name = "moontest:hvac_prop"})    
    for z = -18,-22,-1 do
        for x = 3,5,1 do
            for y = 1,2,1 do
                if not (z == -20 and x == 4) then
                    minetest.set_node(vector.new(x, y, z), {name = "moontest:invisible"})
                end
            end
        end
    end
    minetest.set_node(hvac_pos, {name = "moontest:hvac_on"})
    minetest.get_meta(hvac_pos):set_string("formspec",
        "size[5,5]"..
        "label[1.5,1;HVAC System]"..
        "field[1.8,3;2,1;Thermostat;Thermostat;]")
    minetest.get_meta(hvac_pos):set_int("mese_heat", 0)
    minetest.get_meta(hvac_pos):set_int("mese_on", 0)
end

--creates the oxygen generator mesh, colliders and GUI
function build_oxygen_generator()
    for x = 10,12,1 do
        for z = -19,-21,-1 do
            for y = 1,2,1 do
                minetest.set_node(vector.new(x, y, z), {name = "moontest:oxygen_generator_collider"})
                minetest.get_meta(vector.new(x, y, z)):set_string("formspec",
                    "size[5,5]"..
                    "label[1.5,1;Oxygen Generator]"..
                    "field[1.8,3;2,1;Output;Output;]")
            end
        end
    end
    minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_on"}) 
end

--creates the gravity generator mesh and colliders
function build_gravity_generator()
    for x = 15,17,1 do
        for z = -1,1,1 do
            for y = 1,5 do
                minetest.set_node(vector.new(x, y, z), {name = "moontest:gravity_generator_collider"})
                minetest.get_meta(vector.new(x, y, z)):set_string("formspec",
                    "size[5,5]"..
                    "label[1.5,1;Gravity Generator]"..
                    "field[1.8,3;2,1;Intensity;Intensity;]")
            end
        end
    end
    minetest.set_node(gravity_generator_pos, {name = "moontest:gravity_generator_on"}) 
end

--creates the reactor mesh and colliders
function build_reactor()
    for x = -1,1,1 do
        for z = -13,-15,-1 do
            for y = 1,3,1 do
                minetest.set_node(vector.new(x, y, z), {name = "moontest:reactor_collider"})
            end
        end
    end
    minetest.set_node(reactor_pos, {name = "moontest:reactor_on"}) 
end

--creates the research station mesh and interactive node for the panel
function build_research_station()
    minetest.set_node(research_station_pos, {name = "moontest:research_station"})
    minetest.set_node(vector.new(9,2,0), {name = "moontest:research_panel"}) 
    minetest.set_node(vector.new(12,1,-6), {name = "moontest:table"})
    minetest.set_node(computer_pos, {name = "moontest:computer"}) 
    minetest.get_meta(computer_pos):set_string("formspec",table.concat(computer_formspec()))
end