--[[
    Conveyors
    Author: Droog71
    License: AGPLv3
]]--

local function construct_conveyor(pos)
    local meta = minetest.get_meta(pos)
    local puller = meta:get_int("puller")
    local puller_disp = puller == 1 and "ON" or "OFF"
    meta:set_string("formspec",
        "size[8,9]"..
        "list[current_name;main;3,0.75;8,4;]"..
        "label[3.41,0;Conveyor]" ..
        "list[current_name;filter;1,2.3;8,4;]"..
        "label[2,2.5;Filter (Conveyor will move this item only.)]" ..
        "list[current_player;main;0,5;8,4;]" ..
        "button[0.5,3.5;2,1;Puller;Puller]" ..
        "label[2.5,3.7;(Pull items from non-conveyor nodes): " ..
        puller_disp .. "]" ..
        "listring[]"
    )
    meta:set_string("infotext", "Conveyor")
    local inv = meta:get_inventory()
    inv:set_size("main", 2*1)
    inv:set_size("filter", 1*1)
end

local function receive_conveyor_fields(pos, formname, fields, sender)
    for k,v in pairs(fields) do
        if k == "Puller" then
            local meta = minetest.get_meta(pos)
            local puller = meta:get_int("puller")
            local i = puller == 1 and 0 or 1
            local puller_disp = i == 1 and "ON" or "OFF"
            meta:set_int("puller", i)
            meta:set_string("formspec",
            "size[8,9]"..
            "list[current_name;main;3,0.75;8,4;]"..
            "label[3.41,0;Conveyor]" ..
            "list[current_name;filter;1,2.3;8,4;]"..
            "label[2,2.5;Filter (Conveyor will move this item only.)]" ..
            "list[current_player;main;0,5;8,4;]" ..
            "button[0.5,3.5;2,1;Puller;Puller]" ..
            "label[2.5,3.7;(Pull items from non-conveyor nodes): " ..
            puller_disp .. "]" ..
            "listring[]")
        end
    end
end

minetest.register_node("conveyors:conveyor", {
    description = ("Conveyor\nUsed to move items from one location to another."),
    tiles = {"conveyor.png"},
    groups = {dig_immediate=2},
    on_construct = function(pos)
        construct_conveyor(pos)
    end,
    on_receive_fields = function(pos, formname, fields, sender)
        receive_conveyor_fields(pos, formname, fields, sender)
    end
})

minetest.register_node("conveyors:conveyor_x", {
    drawtype = "mesh",
    mesh = "conveyor_x.obj",
    description = ("Conveyor"),
    tiles = {"conveyor.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_y", {
    drawtype = "mesh",
    mesh = "conveyor_y.obj",
    description = ("Conveyor"),
    tiles = {"conveyor.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_z", {
    drawtype = "mesh",
    mesh = "conveyor_z.obj",
    description = ("Conveyor"),
    tiles = {"conveyor.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_north_up", {
    drawtype = "mesh",
    mesh = "conveyor_north_up.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_south_up", {
    drawtype = "mesh",
    mesh = "conveyor_south_up.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_east_up", {
    drawtype = "mesh",
    mesh = "conveyor_east_up.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_west_up", {
    drawtype = "mesh",
    mesh = "conveyor_west_up.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end,
})

minetest.register_node("conveyors:conveyor_north_down", {
    drawtype = "mesh",
    mesh = "conveyor_north_down.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_south_down", {
    drawtype = "mesh",
    mesh = "conveyor_south_down.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_east_down", {
    drawtype = "mesh",
    mesh = "conveyor_east_down.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_west_down", {
    drawtype = "mesh",
    mesh = "conveyor_west_down.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_south_east", {
    drawtype = "mesh",
    mesh = "conveyor_south_east.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_south_west", {
    drawtype = "mesh",
    mesh = "conveyor_south_west.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_north_east", {
    drawtype = "mesh",
    mesh = "conveyor_north_east.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})

minetest.register_node("conveyors:conveyor_north_west", {
    drawtype = "mesh",
    mesh = "conveyor_north_west.obj",
    description = ("Conveyor"),
    tiles = {"conveyor_corner.png"},
    groups = {dig_immediate=2, not_in_creative_inventory = 1},
    drop = "conveyors:conveyor",
    on_construct = function(pos)
        construct_conveyor(pos)
    end
})
