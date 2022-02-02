--[[
    Conveyors
    Author: Droog71
    License: AGPLv3
]]--

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_x"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_y"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_z"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_north_up"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_south_up"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_east_up"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_west_up"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_north_down"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_south_down"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_east_down"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_west_down"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_south_east"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_south_west"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_north_east"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})

minetest.register_abm({
    nodenames = {"moontest_conveyors:conveyor_north_west"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        move_items(pos, node, active_object_count, active_object_count_wider)
        set_conveyor_mesh(pos)
    end
})
