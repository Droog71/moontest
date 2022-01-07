--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--all pipe nodes are registered here

minetest.register_node("moontest:vertical_pipe", {
    name = "vertical_pipe",
    description = "vertical_pipe",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "vertical_pipe.obj",
    light_source = 5
})

minetest.register_node("moontest:coolant_pipe_vertical_1", {
    name = "coolant_pipe_vertical_1",
    description = "coolant_pipe_vertical_1",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_vertical_1.obj"
})

minetest.register_node("moontest:coolant_pipe_vertical_2", {
    name = "coolant_pipe_vertical_2",
    description = "coolant_pipe_vertical_2",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_vertical_2.obj"
})

minetest.register_node("moontest:coolant_pipe_horizontal", {
    name = "coolant_pipe_horizontal",
    description = "coolant_pipe_horizontal",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_horizontal.obj"
})

minetest.register_node("moontest:coolant_pipe_bend_1", {
    name = "coolant_pipe_bend_1",
    description = "coolant_pipe_bend_1",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_bend_1.obj"
})

minetest.register_node("moontest:coolant_pipe_bend_2", {
    name = "coolant_pipe_bend_2",
    description = "coolant_pipe_bend_2",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_bend_2.obj"
})

minetest.register_node("moontest:coolant_pipe_single_horizontal_1", {
    name = "coolant_pipe_single_horizontal_1",
    description = "coolant_pipe_single_horizontal_1",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_single_horizontal_1.obj"
})

minetest.register_node("moontest:coolant_pipe_single_horizontal_2", {
    name = "coolant_pipe_single_horizontal_2",
    description = "coolant_pipe_single_horizontal_2",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_single_horizontal_2.obj"
})

minetest.register_node("moontest:coolant_pipe_single_bend_1", {
    name = "coolant_pipe_single_bend_1",
    description = "coolant_pipe_single_bend_1",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_single_bend_1.obj"
})

minetest.register_node("moontest:coolant_pipe_single_vertical_1", {
    name = "coolant_pipe_single_vertical_1",
    description = "coolant_pipe_single_vertical_1",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_single_vertical_1.obj"
})

minetest.register_node("moontest:coolant_pipe_single_vertical_2", {
    name = "coolant_pipe_single_vertical_2",
    description = "coolant_pipe_single_vertical_2",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_single_vertical_2.obj"
})

minetest.register_node("moontest:coolant_pipe_pump", {
    name = "coolant_pipe_pump",
    description = "coolant_pipe_pump",
    tiles = {"pipe.png"},
    drawtype = 'mesh',
    mesh = "coolant_pipe_pump.obj"
})