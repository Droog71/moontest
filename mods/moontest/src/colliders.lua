--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

minetest.register_node("moontest:invisible", {
    name = "invisible",
    description = "invisible",
    tiles = {"invisible.png"},
    drawtype = 'airlike',
    light_source = 10
})

minetest.register_node("moontest:reactor_collider", {
    name = "reactor_collider",
    description = "reactor_collider",
    tiles = {"invisible.png"},
    drawtype = 'airlike',
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if minetest.get_meta(reactor_pos):get_int("mese_on") == 0 then
                    local mese_heat = minetest.get_meta(reactor_pos):get_int("mese_heat")
                    if minetest.get_meta(reactor_pos):get_int("mese_heat") <= 1 then
                        if minetest.get_node(reactor_pos).name == "moontest:reactor_off" then
                            reactor_start()
                        end
                        mese_heat = mese_heat + 1
                        minetest.get_meta(reactor_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(reactor_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(reactor_pos):set_int("mese_on", 0)
            end
        },
    },
    light_source = 10
})

minetest.register_node("moontest:gravity_generator_collider", {
    name = "gravity_generator_collider",
    description = "gravity_generator_collider",
    tiles = {"invisible.png"},
    drawtype = 'airlike',
    on_receive_fields = function(pos, formname, fields, player)
        if fields.Intensity then
            if tonumber(fields.Intensity) then
                if tonumber(fields.Intensity) > 0 then
                    set_gravity(tonumber(fields.Intensity))
                    add_hud_message(player:get_player_name() .. " set gravity to " .. fields.Intensity)
                end
            end
        end
    end,
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if minetest.get_meta(gravity_generator_pos):get_int("mese_on") == 0 then
                    local mese_heat = minetest.get_meta(gravity_generator_pos):get_int("mese_heat")
                    if power_on() and mese_heat <= 1 then
                        if minetest.get_node(gravity_generator_pos).name == "moontest:gravity_generator_off" then
                            minetest.set_node(gravity_generator_pos, {name = "moontest:gravity_generator_on"})
                        end
                        mese_heat = mese_heat + 1
                        minetest.get_meta(gravity_generator_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(gravity_generator_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(gravity_generator_pos):set_int("mese_on", 0)
            end
        },
    },
    light_source = 10
})

minetest.register_node("moontest:drill_collider", {
    name = "drill_collider",
    description = "drill_collider",
    tiles = {"invisible.png"},
    drawtype = 'airlike',
    on_receive_fields = function(pos, formname, fields, player)
        if fields.Speed then
            if tonumber(fields.Speed) then
                if tonumber(fields.Speed) > 0 then
                    set_drill_speed(tonumber(fields.Speed))
                    add_hud_message(player:get_player_name() .. " set drill speed to " .. fields.Speed)
                end
            end
        end
    end,
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if minetest.get_meta(drill_pos):get_int("mese_on") == 0 then
                    local mese_heat = minetest.get_meta(drill_pos):get_int("mese_heat")
                    if power_on() and mese_heat <= 1 then
                        if minetest.get_node(drill_pos).name == "moontest:drill_off" then
                            minetest.set_node(drill_pos, {name = "moontest:drill_on"})
                        end
                        mese_heat = mese_heat + 1
                        minetest.get_meta(drill_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(drill_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(drill_pos):set_int("mese_on", 0)
            end
        },
    },
    light_source = 10
})

minetest.register_node("moontest:oxygen_generator_collider", {
    name = "oxygen_generator_collider",
    description = "oxygen_generator_collider",
    tiles = {"invisible.png"},
    drawtype = 'airlike',
    on_receive_fields = function(pos, formname, fields, player)
        if fields.Output then
            if tonumber(fields.Output) then
                if tonumber(fields.Output) > 0 then
                    set_oxygen_output(tonumber(fields.Output))
                    add_hud_message(player:get_player_name() .. " set oxygen output to " .. fields.Output)
                end
            end
        end
    end,
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if minetest.get_meta(oxygen_generator_pos):get_int("mese_on") == 0 then
                    local mese_heat = minetest.get_meta(oxygen_generator_pos):get_int("mese_heat")
                    if power_on() and mese_heat <= 1 then
                        if minetest.get_node(oxygen_generator_pos).name == "moontest:oxygen_generator_off" then
                            minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_on"})
                        end
                        mese_heat = mese_heat + 1
                        minetest.get_meta(oxygen_generator_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(oxygen_generator_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(oxygen_generator_pos):set_int("mese_on", 0)
            end
        },
    },
    light_source = 10
})