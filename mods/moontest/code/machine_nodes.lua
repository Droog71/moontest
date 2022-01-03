--[[
    Moon Habitat Simulator
    Version: 1.0.2
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--all machine nodes are registered here

minetest.register_node("moontest:drill_on", {
    name = "drill_on",
    description = "drill_on",
    tiles = {"drill_on.png"},
    drawtype = 'mesh',
    mesh = "drill.obj"
})

minetest.register_node("moontest:drill_off", {
    name = "drill_off",
    description = "drill_off",
    tiles = {"drill_off.png"},
    drawtype = 'mesh',
    mesh = "drill.obj"
})

minetest.register_node("moontest:reactor_on", {
    name = "reactor_on",
    description = "reactor_on",
    tiles = {"reactor_on.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "reactor.obj"
})

minetest.register_node("moontest:reactor_off", {
    name = "reactor_off",
    description = "reactor_off",
    tiles = {"reactor_off.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "reactor.obj"
})

minetest.register_node("moontest:oxygen_generator_on", {
    name = "oxygen_generator_on",
    description = "oxygen_generator_on",
    tiles = {"oxygen_generator_on.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "oxygen_generator.obj"
})

minetest.register_node("moontest:oxygen_generator_off", {
    name = "oxygen_generator_off",
    description = "oxygen_generator_off",
    tiles = {"oxygen_generator_off.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "oxygen_generator.obj"
})

minetest.register_node("moontest:gravity_generator_on", {
    name = "gravity_generator_on",
    description = "gravity_generator_on",
    tiles = {"gravity_generator_on.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "gravity_generator.obj"
})

minetest.register_node("moontest:gravity_generator_off", {
    name = "gravity_generator_off",
    description = "gravity_generator_off",
    tiles = {"gravity_generator_off.png"},
    use_texture_alpha = "clip",
    drawtype = 'mesh',
    mesh = "gravity_generator.obj"
})

minetest.register_node("moontest:pump_on", {
    name = "pump_on",
    description = "pump_on",
    tiles = {"pump_on.png"},
    drawtype = 'mesh',
    mesh = "pump.obj",
    on_receive_fields = function(pos, formname, fields, player)
        if fields.Speed then
            if tonumber(fields.Speed) then
                if tonumber(fields.Speed) > 0 then
                    set_pump_speed(tonumber(fields.Speed))
                    add_hud_message(player:get_player_name() .. " set coolant pump speed to " .. fields.Speed)
                end
            end
        end
    end,
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if minetest.get_meta(pump_pos):get_int("mese_on") == 0 then
                    local mese_heat = minetest.get_meta(pump_pos):get_int("mese_heat")
                    if mese_heat <= 1 then
                        mese_heat = mese_heat + 1
                        minetest.get_meta(pump_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(pump_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(pump_pos):set_int("mese_on", 0)
            end
        },
    },
})

minetest.register_node("moontest:pump_off", {
    name = "pump_off",
    description = "pump_off",
    tiles = {"pump_off.png"},
    drawtype = 'mesh',
    mesh = "pump.obj",
    on_receive_fields = function(pos, formname, fields, player)
        if fields.Speed then
            if tonumber(fields.Speed) then
                if tonumber(fields.Speed) > 0 then
                  set_pump_speed(tonumber(fields.Speed))
                  add_hud_message(player:get_player_name() .. " set coolant pump speed to " .. fields.Speed)
                end
            end
        end
    end,
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if power_on() and minetest.get_meta(pump_pos):get_int("mese_on") == 0 then
                    if minetest.get_meta(pump_pos):get_int("mese_heat") <= 1 then
                        minetest.set_node(pump_pos, {name = "moontest:pump_on"}) 
                        minetest.get_meta(pump_pos):set_string("formspec",
                            "size[5,5]"..
                            "label[1.5,1;Coolant Pump]"..
                            "field[1.8,3;2,1;Speed;Speed;]") 
                        local mese_heat = minetest.get_meta(pump_pos):get_int("mese_heat")
                        mese_heat = mese_heat + 1
                        minetest.get_meta(pump_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(pump_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(pump_pos):set_int("mese_on", 0)
            end
        },
    },
})

minetest.register_node("moontest:hvac_on", {
    name = "hvac_on",
    description = "hvac_on",
    tiles = {
        "hvac_on.png",
        "hvac_on.png",
        "hvac_on.png",
        "hvac_on.png",
        "hvac_on.png",
        "vent.png"
    },
    on_receive_fields = function(pos, formname, fields, player)
        if fields.Thermostat then
            if tonumber(fields.Thermostat) then
                if tonumber(fields.Thermostat) > 0 then
                  set_thermostat(tonumber(fields.Thermostat))
                  add_hud_message(player:get_player_name() .. " set thermostat to " .. fields.Thermostat)
                end
            end
        end
    end,
    mesecons = {
        effector = {
            action_on = function(pos, node)
                if minetest.get_meta(hvac_pos):get_int("mese_on") == 0 then
                    local mese_heat = minetest.get_meta(hvac_pos):get_int("mese_heat")
                    if mese_heat <= 1 then
                        mese_heat = mese_heat + 1
                        minetest.get_meta(hvac_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(hvac_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(hvac_pos):set_int("mese_on", 0)
            end
        },
    },
})

minetest.register_node("moontest:hvac_off", {
    name = "hvac_off",
    description = "hvac_off",
    tiles = {
      "hvac_off.png",
      "hvac_off.png",
      "hvac_off.png",
      "hvac_off.png",
      "hvac_off.png",
      "vent.png"
	},
  on_receive_fields = function(pos, formname, fields, player)
      if fields.Thermostat then
          if tonumber(fields.Thermostat) then
              if tonumber(fields.Thermostat) > 0 then
                set_thermostat(tonumber(fields.Thermostat))
                add_hud_message(player:get_player_name() .. " set thermostat to " .. fields.Thermostat)
              end
          end
      end
  end,
  mesecons = {
        effector = {
            action_on = function(pos, node)
                if power_on() and minetest.get_meta(hvac_pos):get_int("mese_on") == 0 then
                    if minetest.get_meta(hvac_pos):get_int("mese_heat") <= 1 then
                        minetest.set_node(hvac_pos, {name = "moontest:hvac_on"})
                        minetest.get_meta(hvac_pos):set_string("formspec",
                            "size[5,5]"..
                            "label[1.5,1;HVAC System]"..
                            "field[1.8,3;2,1;Thermostat;Thermostat;]") 
                        local mese_heat = minetest.get_meta(hvac_pos):get_int("mese_heat")
                        mese_heat = mese_heat + 1
                        minetest.get_meta(hvac_pos):set_int("mese_heat", mese_heat)
                    end
                    minetest.get_meta(hvac_pos):set_int("mese_on", 1)
                end
            end,
            action_off = function(pos, node)
                minetest.get_meta(hvac_pos):set_int("mese_on", 0)
            end
        },
    },
})