--[[
    Moon Habitat Simulator
    Version: 1
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--special purpose nodes are registered here

minetest.register_node("moontest:food_vending_top", {
	description = "Space Food Vending",
	tiles = {
		"food_vending.png",
		"food_vending.png",
		"food_vending.png",
		"food_vending_top_front.png",
		"food_vending.png",
		"food_vending.png"
	},
    light_source = 10
})

minetest.register_node("moontest:food_vending_bottom", {
	description = "Space Food Vending",
	tiles = {
		"food_vending.png",
		"food_vending.png",
		"food_vending.png",
		"food_vending_bottom_front.png",
		"food_vending.png",
		"food_vending.png"
	},
    light_source = 10
})

minetest.register_node("moontest:airlock", {
    name = "airlock",
    description = "airlock",
    tiles = {"airlock.png"}
})

minetest.register_node("moontest:airlock_controller_on", {
    name = "airlock_controller_on",
    description = "airlock_controller_on",
    tiles = {"airlock_controller_on.png"}
})

minetest.register_node("moontest:airlock_controller_off", {
    name = "airlock_controller_off",
    description = "airlock_controller_off",
    tiles = {"airlock_controller_off.png"}
})

minetest.register_node("moontest:research_station", {
    name = "research_station",
    description = "research_station",
    tiles = {"research_station.png"},
    drawtype = 'mesh',
    mesh = "research.obj"
})

minetest.register_node("moontest:research_panel", {
    name = "research_panel",
    description = "research_panel",
    tiles = {"invisible.png"},
    drawtype = 'airlike',
    light_source = 10
})

minetest.register_node("moontest:light_on", {
    name = "light",
    description = "light",
    tiles = {"light.png"},
    drawtype = 'mesh',
    mesh = "light.obj",
    light_source = 14
})

minetest.register_node("moontest:light_off", {
    name = "light",
    description = "light",
    tiles = {"light.png"},
    drawtype = 'mesh',
    mesh = "light.obj"
})

minetest.register_node("moontest:exterior_light_on", {
    name = "exterior_light_on",
    description = "exterior_light_on",
    tiles = {"light.png"},
    drawtype = 'mesh',
    mesh = "exterior_light.obj",
    light_source = 14
})

minetest.register_node("moontest:exterior_light_off", {
    name = "exterior_light_off",
    description = "exterior_light_off",
    tiles = {"light.png"},
    drawtype = 'mesh',
    mesh = "exterior_light.obj"
})

minetest.register_node("moontest:bunkbed", {
    name = "bunkbed",
    description = "bunkbed",
    tiles = {"bunkbed.png"},
    drawtype = 'mesh',
    mesh = "bunkbed.obj"
})

minetest.register_node("moontest:hvac_prop", {
    name = "hvac_prop",
    description = "hvac_prop",
    tiles = {"hvac_prop.png"},
    drawtype = 'mesh',
    mesh = "hvac_prop.obj"
})

minetest.register_node("moontest:coolant_tank", {
    name = "coolant_tank",
    description = "coolant_tank",
    tiles = {"coolant_tank.png"},
    drawtype = 'mesh',
    mesh = "coolant_tank.obj"
})