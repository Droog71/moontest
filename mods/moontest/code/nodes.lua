--[[
    Moon Habitat Simulator
    Version: 1.01
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--all standard nodes are registered here, other nodes are handled by the scripts below

dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "machine_nodes.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "pipe_nodes.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "special_nodes.lua")
dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "code" .. DIR_DELIM .. "colliders.lua")

minetest.register_node("moontest:moon_surface", {
    name = "moon_surface",
    description = "moon_surface",
    tiles = {"moon_surface.png"},
})

minetest.register_node("moontest:wall", {
    name = "wall",
    description = "wall",
    tiles = {"wall.png"}
})

minetest.register_node("moontest:floor", {
    name = "floor",
    description = "floor",
    tiles = {"floor.png"}
})

minetest.register_node("moontest:duct", {
    name = "duct",
    description = "duct",
    tiles = {"duct.png"}
})

minetest.register_node("moontest:vent", {
    name = "vent",
    description = "vent",
    tiles = {
		"duct.png",
		"vent.png",
		"duct.png",
		"duct.png",
		"duct.png",
		"duct.png"
	}
})

minetest.register_node("moontest:crate", {
    name = "crate",
    description = "crate",
    tiles = {"crate.png"}
})

minetest.register_node("moontest:console", {
    name = "console",
    description = "console",
    tiles = {"console.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "console.obj"
})

minetest.register_node("moontest:console_2", {
    name = "console_2",
    description = "console_2",
    tiles = {"console.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "console_2.obj"
})

minetest.register_node("moontest:hovercraft", {
    name = "hovercraft",
    description = "hovercraft",
    tiles = {"hovercraft.png"},
    drawtype = 'mesh',
    mesh = "hovercraft.obj"
})

minetest.register_node("moontest:hovercraft_2", {
    name = "hovercraft_2",
    description = "hovercraft_2",
    tiles = {"hovercraft.png"},
    drawtype = 'mesh',
    mesh = "hovercraft_2.obj"
})

minetest.register_node("moontest:refridgerator", {
    name = "refridgerator",
    description = "refridgerator",
    tiles = {"refridgerator.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "refridgerator.obj"
})

minetest.register_node("moontest:microwave", {
    name = "microwave",
    description = "microwave",
    tiles = {"microwave.png"},
    drawtype = 'mesh',
    mesh = "microwave.obj"
})

minetest.register_node("moontest:cabinet", {
    name = "cabinet",
    description = "cabinet",
    tiles = {"cabinet.png"},
    drawtype = 'mesh',
    mesh = "cabinet.obj"
})

minetest.register_node("moontest:counter", {
    name = "counter",
    description = "counter",
    tiles = {"counter.png"},
    drawtype = 'mesh',
    mesh = "counter.obj"
})

minetest.register_node("moontest:sink", {
    name = "sink",
    description = "sink",
    tiles = {"sink.png"},
    drawtype = 'mesh',
    mesh = "sink.obj"
})

minetest.register_node("moontest:toilet", {
    name = "toilet",
    description = "toilet",
    tiles = {"toilet.png"},
    drawtype = 'mesh',
    mesh = "toilet.obj"
})

minetest.register_node("moontest:shower", {
    name = "shower",
    description = "shower",
    tiles = {"shower.png"},
    drawtype = 'mesh',
    mesh = "shower.obj",
    light_source = 5
})

minetest.register_node("moontest:floor_drain", {
    name = "floor_drain",
    description = "floor_drain",
    tiles = {
		"floor_drain.png",
		"floor.png",
		"floor.png",
		"floor.png",
		"floor.png",
		"floor.png"
	},
    light_source = 5
})

minetest.register_node("moontest:table", {
    name = "table",
    description = "table",
    tiles = {"table.png"},
    drawtype = 'mesh',
    mesh = "table.obj"
})

minetest.register_node("moontest:chair", {
    name = "chair",
    description = "chair",
    tiles = {"chair.png"},
    drawtype = 'mesh',
    mesh = "chair.obj"
})

minetest.register_node("moontest:sofa", {
    name = "sofa",
    description = "sofa",
    tiles = {"sofa.png"},
    drawtype = 'mesh',
    mesh = "sofa.obj"
})

minetest.register_node("moontest:glass", {
    name = "glass",
    description = "glass",
    tiles = {"glass.png"},
    drawtype = 'glasslike_framed'
})