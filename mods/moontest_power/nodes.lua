--[[
    Portable Power
    Author: Droog71
    License: AGPLv3
]]--

--solar panel
minetest.register_node("moontest_power:solar_panel", {
  description = "Solar Panel\n" .. "Generates power.\n" ..
        "Machines and power transmitters must\n" .. 
        "be placed adjacent to the power source.",
  tiles = {"solar_panel.png"},
  groups = {dig_immediate=2},
  paramtype2="facedir",
  drawtype = 'mesh',
  mesh = "solar_panel.obj",
  wield_image = "solar_panel_wield.png",
  inventory_image = "solar_panel_wield.png",
  on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("infotext", "Solar Panel")
  end,
  after_place_node = function(pos, placer, itemstack, pointed_thing)
      local name = placer:get_player_name()
      if inside_habitat(name) then
          minetest.remove_node(pos)
          minetest.chat_send_player(name, "You can't use that indoors.")
          return true
      end
  end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
      for i,p in pairs(power_producers) do
          if p.x == pos.x and p.y == pos.y and p.z == pos.z then
              table.remove(power_producers, i)
              break
          end
      end
  end
})

--generator
minetest.register_node("moontest_power:generator", {
    description = "Generator\n" .. "Generates power.\n" ..
        "Machines and power transmitters must\n" .. 
        "be placed adjacent to the power source.",
    tiles = {"generator.png"},
    groups = {dig_immediate=2},
    paramtype2="facedir",
    drawtype = 'mesh',
    mesh = "generator.obj",
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
            "size[8,9]"..
            "label[3.4,0.75;Generator]" ..
            "list[current_name;main;3,2;8,4;]" ..
            "list[current_player;main;0,5;8,4;]" ..
            "listring[]")
        meta:set_string("infotext", "Generator")
        local inv = meta:get_inventory()
        inv:set_size("main", 2*1)
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
      local name = placer:get_player_name()
      if inside_habitat(name) then
          minetest.remove_node(pos)
          minetest.chat_send_player(name, "You can't use that indoors.")
          return true
      end
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        for i,p in pairs(power_producers) do
            if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                table.remove(power_producers, i)
                break
            end
        end
        local pos_str = pos.x .. "," .. pos.y .. "," .. pos.z
        if generator_sounds[pos_str] then
            minetest.sound_stop(generator_sounds[pos_str])
        end
    end,
    can_dig = function(pos,player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        return stack:get_count()
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        return stack:get_count()
    end
})

--transmitter
minetest.register_node("moontest_power:power_transmitter", {
  description = "Power Transmitter\n" .. "Transmits power.\n" ..
        "Powers a machine or another transmitter up to 20 meters away.\n" .. 
        "Use a screwdriver to rotate the transmitter.\n" .. 
        "Rotate to 1 (up) or 1.5 (down) for vertical transmission.",
  tiles = {
		"transmitter.png", "transmitter.png",
		"transmitter.png", "transmitter.png",
		"transmitter.png", "transmitter_front.png"
	},
  paramtype2="facedir",
  groups = {dig_immediate=2},
  on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("infotext", "Power Transmitter")
  end,
  after_place_node = function(pos, placer, itemstack, pointed_thing)
      local name = placer:get_player_name()
      if inside_habitat(name) then
          minetest.remove_node(pos)
          minetest.chat_send_player(name, "You can't use that indoors.")
          return true
      end
  end,
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
      for i,p in pairs(power_consumers) do
          if p.x == pos.x and p.y == pos.y and p.z == pos.z then
              table.remove(power_consumers, i)
              break
          end
      end
      clear_power(pos)
  end
})

minetest.register_node("moontest_power:power", {
    name = "power",
    description = "power",
    tiles = {"power.png"},
    walkable = false,
    light_source = 14,
    pointable = false,
		buildable_to = true,
    groups = { not_in_creative_inventory = 1 },
})

minetest.register_node("moontest_power:power_x", {
    name = "power",
    description = "power",
    drawtype= "mesh",
    mesh = "power_x.obj",
    tiles = {"power.png"},
    walkable = false,
    light_source = 14,
    pointable = false,
		buildable_to = true,
    groups = { not_in_creative_inventory = 1 },
})

minetest.register_node("moontest_power:power_y", {
    name = "power",
    description = "power",
    drawtype= "mesh",
    mesh = "power_y.obj",
    tiles = {"power.png"},
    walkable = false,
    light_source = 14,
    pointable = false,
		buildable_to = true,
    groups = { not_in_creative_inventory = 1 },
})

minetest.register_node("moontest_power:power_z", {
    name = "power",
    description = "power",
    drawtype= "mesh",
    mesh = "power_z.obj",
    tiles = {"power.png"},
    walkable = false,
    light_source = 14,
    pointable = false,
		buildable_to = true,
    groups = { not_in_creative_inventory = 1 },
})