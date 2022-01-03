--[[
    Moon Habitat Simulator
    Version: 1.0.2
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--increases reactor output by 100 when active
minetest.register_node("moontest:reactor_booster", {
    name = "Reactor Booster",
    description = "Reactor Booster\n" ..
        "Adds 100 to maximum reactor output.\n" ..
        "Must be placed near the reactor.\n" ..
        "Overloads after 10 seconds. 10 second cooldown.",
    tiles = {"reactor_on.png"},
    drawtype = 'mesh',
    mesh = "reactor_booster.obj",
    use_texture_alpha = "clip",
    groups = {dig_immediate=2},
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        if tonumber(oldmetadata.fields.on) == 1 then
            max_power = max_power - 100
        end
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_int("on",0)
        meta:set_int("timer",0)
    end,
    mesecons = {
        effector = {
            action_on = function(pos, node)
                local meta = minetest.get_meta(pos)
                if vector.distance(pos, reactor_pos) < 20 then
                    if meta:get_int("on") == 0 then
                        max_power = max_power + 100
                        meta:set_int("on", 1)
                    end
                end
            end,
            action_off = function(pos, node)
                local meta = minetest.get_meta(pos)
                if meta:get_int("on") == 1 then
                    max_power = max_power - 100
                    meta:set_int("on", 0)
                end
            end
        },
    }
})

--boosters overload the reactor after 10 seconds
minetest.register_abm({
	nodenames = {"moontest:reactor_booster"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
      local meta = minetest.get_meta(pos)
      if meta:get_int("on") == 1 then
          if meta:get_int("timer") >= 10 then
              if power_on() then
                  reactor_stop()
              end
          else
              local timer = meta:get_int("timer")
              timer = timer + 1
              meta:set_int("timer", timer)
              if timer == 5 then
                  minetest.add_particlespawner({
                      amount = 600,
                      time = 3,
                      minpos = {x=pos.x-2,y=pos.y+1,z=pos.z-1},
                      maxpos = {x=pos.x+2,y=pos.y+15,z=pos.z+2},
                      minvel = {x=0.2, y=0.2, z=0.2},
                      maxvel = {x=0.4, y=0.8, z=0.4},
                      minacc = {x=-0.2,y=0,z=-0.2},
                      maxacc = {x=0.2,y=0.1,z=0.2},
                      minexptime = 6,
                      maxexptime = 8,
                      minsize = 10,
                      maxsize = 12,
                      collisiondetection = false,
                      vertical = false,
                      texture = "smoke.png"
                  })  
              end
          end
      else
          local timer = meta:get_int("timer")
          if timer > 0 then
              timer = timer - 2
          end
          meta:set_int("timer", timer)
      end
	end
})