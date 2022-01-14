--[[
    Moon Habitat Simulator
    Version: 1.0.5
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local function reactor_smoke()
    local reactor_meta = minetest.get_meta(reactor_pos)
    if power_on() and reactor_meta:get_int("smoking") == 0 then
        minetest.sound_play('alarm', {
            pos = reactor_pos,
            max_hear_distance = 16
        })
        minetest.add_particlespawner({
            amount = 300,
            time = 3,
            minpos = {x=reactor_pos.x-2, y=reactor_pos.y, z=reactor_pos.z-1},
            maxpos = {x=reactor_pos.x+2, y=reactor_pos.y+2, z=reactor_pos.z+2},
            minvel = {x=-0.1, y=0.1, z=-0.1},
            maxvel = {x=0.2, y=0.2, z=0.2},
            minacc = {x=-0.1, y=0.1, z=-0.1},
            maxacc = {x=0.2, y=0.2, z=0.2},
            minexptime = 6,
            maxexptime = 8,
            minsize = 10,
            maxsize = 12,
            collisiondetection = false,
            vertical = false,
            texture = "smoke.png"
        })
        reactor_meta:set_int("smoking", 1)
        minetest.after(3,function()
            reactor_meta:set_int("smoking", 0)
        end)
    end
end

--increases reactor output by 100 when active
minetest.register_node("moontest:reactor_booster", {
    name = "Reactor Booster",
    description = "Reactor Booster\n" ..
        "Adds 100 to maximum reactor output.\n" ..
        "Must be placed near the reactor.\n" ..
        "Overloads after 10 seconds. 10 second cooldown.",
    tiles = {"reactor_booster.png"},
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
                if vector.distance(pos, reactor_pos) < 10 then
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
              if timer == 6 then
                  reactor_smoke()
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