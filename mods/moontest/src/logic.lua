--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local heat_timer = 0

--sensors are active whenever an adjacent machine is on
minetest.register_node("moontest:sensor", {
    name = "Sensor",
    description = "Sensor\nPlace next to a machine and a relay.\n" ..
        "The relay will be energized when the machine is on.",
    tiles = {"sensor.png"},
    groups = {dig_immediate=2},
})

--relays convert sensor input to mesecons output
minetest.register_node("moontest:relay_off", {
    name = "Relay",
    description = "Relay\nGenerates a mesecons signal.\n" .. 
        "Must be placed next to a sensor connected to an active machine.",
    tiles = {"relay.png"},
    mesecons = {
        receptor = {
            state = "off"
        },
    },
    groups = {dig_immediate=2}
})

--relays convert sensor input to mesecons output
minetest.register_node("moontest:relay_on", {
    name = "Relay",
    description = "Relay\nGenerates a mesecons signal.\n" ..
        "Must be placed next to a sensor connected to an active machine.",
    tiles = {"relay.png"},
    mesecons = {
        receptor = {
            state = "on"
        },
    },
    groups = {dig_immediate=2}
})

--prevents the use of fast circuits via machine failure
minetest.register_globalstep(function(dtime)  
    heat_timer = heat_timer + 1
    if heat_timer >= 50 then
        local reactor_heat = minetest.get_meta(reactor_pos):get_int("mese_heat")
        if reactor_heat > 1 then
            if power_on() then
                reactor_stop()
                minetest.get_meta(reactor_pos):set_int("mese_heat", reactor_heat)
            end
        else
            minetest.get_meta(reactor_pos):set_int("mese_heat", 0)
        end
        local drill_heat = minetest.get_meta(drill_pos):get_int("mese_heat")
        if drill_heat > 1 then
            if drill_on() then
                minetest.set_node(drill_pos, {name = "moontest:drill_off"})
                minetest.get_meta(drill_pos):set_int("mese_heat", drill_heat)
                add_hud_message("Drill: failed")
                drill_failed = true
            end
        else
            minetest.get_meta(drill_pos):set_int("mese_heat", 0)
        end
        local gravity_generator_heat = minetest.get_meta(gravity_generator_pos):get_int("mese_heat")
        if gravity_generator_heat > 1 then
            if gravity_on()  then
                minetest.set_node(gravity_generator_pos, {name = "moontest:gravity_generator_off"})
                minetest.get_meta(gravity_generator_pos):set_int("mese_heat", gravity_generator_heat)
                add_hud_message("Gravity generator: failed")
                gravity_failed = true
            end
        else
            minetest.get_meta(gravity_generator_pos):set_int("mese_heat", 0)
        end
        local oxygen_generator_heat = minetest.get_meta(oxygen_generator_pos):get_int("mese_heat")
        if oxygen_generator_heat > 1 then
            if oxygen_on() then
                minetest.sound_play('oxygen_start_stop', {
                    pos = oxygen_generator_pos,
                    max_hear_distance = 16
                })
                minetest.set_node(oxygen_generator_pos, {name = "moontest:oxygen_generator_off"})
                minetest.get_meta(oxygen_generator_pos):set_int("mese_heat", oxygen_generator_heat)
                add_hud_message("Oxygen generator: failed")
                oxygen_failed = true
            end
        else
            minetest.get_meta(oxygen_generator_pos):set_int("mese_heat", 0)
        end
        local hvac_heat = minetest.get_meta(hvac_pos):get_int("mese_heat")
        if hvac_heat > 1 then
            if hvac_on() then
                minetest.sound_play('hvac_off', {
                  pos = hvac_pos,
                  max_hear_distance = 16
                })
                minetest.set_node(hvac_pos, {name = "moontest:hvac_off"})
                minetest.get_meta(hvac_pos):set_int("mese_heat", hvac_heat)
                add_hud_message("HVAC: failed")
                minetest.get_meta(hvac_pos):set_string("formspec",
                    "size[5,5]"..
                    "label[1.5,1;HVAC System]"..
                    "field[1.8,3;2,1;Thermostat;Thermostat;]")
                hvac_failed = true
            end
        else
            minetest.get_meta(hvac_pos):set_int("mese_heat", 0)
        end
        local pump_heat = minetest.get_meta(pump_pos):get_int("mese_heat")
        if pump_heat > 1 then
            if pump_on() then
                minetest.set_node(pump_pos, {name = "moontest:pump_off"})
                minetest.get_meta(pump_pos):set_int("mese_heat", pump_heat)
                add_hud_message("Coolant pump: failed")
                minetest.get_meta(pump_pos):set_string("formspec",
                    "size[5,5]"..
                    "label[1.5,1;Coolant Pump]"..
                    "field[1.8,3;2,1;Speed;Speed;]")
                pump_failed = true
            end
        else
            minetest.get_meta(pump_pos):set_int("mese_heat", 0)
        end
        heat_timer = 0
    end
end)

--controls the relationship between machines, sensors and relays
minetest.register_abm({
	nodenames = {"moontest:sensor"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
      local connected = false
      local north = vector.new(pos.x + 1, pos.y, pos.z)
      local south = vector.new(pos.x - 1, pos.y, pos.z)
      local east = vector.new(pos.x, pos.y, pos.z + 1)
      local west = vector.new(pos.x, pos.y, pos.z - 1)
      local directions = {north, south, east, west}
      local on_nodes = {
          "moontest:pump_on",
          "moontest:hvac_on",
      }
      local col_locations = {
          ["moontest:drill_collider"] = drill_pos,
          ["moontest:reactor_collider"] = reactor_pos,
          ["moontest:oxygen_generator_collider"] = oxygen_generator_pos,
          ["moontest:gravity_generator_collider"] = gravity_generator_pos
      }
      local on_obj = {
          ["moontest:drill_collider"] = "moontest:drill_on",
          ["moontest:reactor_collider"] = "moontest:reactor_on",
          ["moontest:oxygen_generator_collider"] = "moontest:oxygen_generator_on",
          ["moontest:gravity_generator_collider"] = "moontest:gravity_generator_on"
      }
      for _, dir in pairs(directions) do
          for i,node in pairs(on_nodes) do
              if minetest.get_node(dir).name == on_nodes[i] then
                  for _, dir in ipairs(directions) do
                      if minetest.get_node(dir).name == "moontest:relay_off" then
                          minetest.set_node(dir, {name="moontest:relay_on"})
                          mesecon.receptor_on(dir)
                      end
                  end
                  connected = true
              end
          end
          for name,location in pairs(col_locations) do
              if minetest.get_node(dir).name == name then
                  if minetest.get_node(col_locations[name]).name == on_obj[name] then
                      for _, dir in ipairs(directions) do
                          if minetest.get_node(dir).name == "moontest:relay_off" then
                              minetest.set_node(dir, {name="moontest:relay_on"})
                              mesecon.receptor_on(dir)
                          end
                      end
                      connected = true
                  end
              end
          end
          if connected == true then break end
      end
      if connected == false then
          for _, dir in ipairs(directions) do
              if minetest.get_node(dir).name == "moontest:relay_on" then
                  minetest.set_node(dir, {name="moontest:relay_off"})
                  mesecon.receptor_off(dir)
              end
          end
      end
	end
})