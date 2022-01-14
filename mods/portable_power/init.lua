--[[
    Portable Power
    Author: Droog71
    License: AGPLv3
]]--

power_producers = {}
power_consumers = {}
generator_sounds = {}

--fuel
minetest.register_craftitem("portable_power:fuel", {
    description = "Fuel.\nAdd to the inventory of a generator.",
    inventory_image = "fuel.png"
})

--solar panel
minetest.register_node("portable_power:solar_panel", {
  description = "Solar Panel\n" .. "Generates power for research probes,\n" .. 
        "REM extractors and work lights.\n" ..
        "Requires an active terraformer.",
  tiles = {"solar_panel.png"},
  groups = {dig_immediate=2},
  paramtype2="facedir",
  drawtype = 'mesh',
  mesh = "solar_panel.obj",
  wield_image = "solar_panel_wield.png",
  inventory_image = "solar_panel_wield.png",
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
minetest.register_node("portable_power:generator", {
    description = "Generator\n" .. "Generates power for research probes,\n" .. 
        "REM extractors and work lights.\n" ..
        "One power source is needed for every 5 consumers.\n" ..
        "Must be placed within 10 meters of the consumers.",
    tiles = {"generator.png"},
    groups = {dig_immediate=2},
    paramtype2="facedir",
    drawtype = 'mesh',
    mesh = "generator.obj",
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
            "size[8,9]"..
            "list[current_name;main;0,0;8,4;]"..
            "list[current_player;main;0,5;8,4;]" ..
            "listring[]")
        local inv = meta:get_inventory()
        inv:set_size("main", 4*1)
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
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local name = placer:get_player_name()
        if inside_habitat(name) then
            minetest.remove_node(pos)
            minetest.chat_send_player(name, "You can't use that indoors.")
            return true
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

--solar panel abm
minetest.register_abm({
    nodenames = {"portable_power:solar_panel"},
    interval = 10,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local active = is_producer(pos)
        if not blocked(pos) then
            if active == false then
                table.insert(power_producers, pos)
            end
        else
            if active == true then
                for i,p in pairs(power_producers) do
                    if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                        table.remove(power_producers, i)
                        break
                    end
                end
            end
        end
    end
})

minetest.register_abm({
    nodenames = {"portable_power:generator"},
    interval = 10,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local has_fuel = false
        if inv:contains_item("main", "portable_power:fuel") then
            inv:remove_item("main", "portable_power:fuel")
            has_fuel = true
        end 
        local active = is_producer(pos)
        if has_fuel then
            if active == false then
                table.insert(power_producers, pos)
            end
            local pos_str = pos.x .. "," .. pos.y .. "," .. pos.z
            generator_sounds[pos_str] = minetest.sound_play('generator', {
                pos = pos,
                max_hear_distance = 16
            })
        else
            if active == true then
                for i,p in pairs(power_producers) do
                    if p.x == pos.x and p.y == pos.y and p.z == pos.z then
                        table.remove(power_producers, i)
                        break
                    end
                end
            end
        end
    end
})

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local inv_fs = player:get_inventory_formspec()
    local title = string.sub(inv_fs, 48, 61)
    if title == "Portable Power" then
        for key, val in pairs(fields) do
            if key == "Back" then
                local formspec = inventory_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            end
        end 
    end
end)

--defines the power formspec
function power_formspec(player)
    local power_info = ""
        for index,pos in pairs(power_producers) do
            local local_consumers = 0
            local local_producers = 0
            for index,consumer in pairs(power_consumers) do
                if vector.distance(consumer, pos) <= 10 then
                    local_consumers = local_consumers + 1
                end
            end
            for index,producer in pairs(power_producers) do
                if vector.distance(producer, pos) <= 10 then
                    local_producers = local_producers + 1
                end
            end
            local stable = local_consumers <= local_producers * 5
            local stable_display = stable and "stable" or "unstable"
            power_info = power_info .. local_consumers .. " consumers and " .. 
            local_producers .. " producers for power source at (" ..
            pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")" ..
            " (" .. stable_display .. ")\n"
        end
    local formspec = {
        "size[11,11]",
        "bgcolor[#353535;false]",
        "label[4.5,0.5;Portable Power]",
        "scroll_container[1,1;12,8;power_scroll;vertical;0.1]",
        "label[1,1;" .. power_info .. "]",
        "scroll_container_end[]",
        "button[3.5,9.5;4,2;Back;Back]"
    }
    return formspec
end

--returns true if power is stable for the given pos
function power_stable(pos)
    local local_consumers = 0
    local local_producers = 0
    for index,consumer in pairs(power_consumers) do
        if vector.distance(consumer, pos) <= 10 then
            local_consumers = local_consumers + 1
        end
    end
    for index,producer in pairs(power_producers) do
        if vector.distance(producer, pos) <= 10 then
            local_producers = local_producers + 1
        end
    end
    return local_consumers <= local_producers * 5
end

--returns true if the node is an active producer of power
function is_producer(pos)
    for _,p in pairs(power_producers) do
        if p.x == pos.x and p.y == pos.y and p.z == pos.z then
            return true
        end
    end
    return false
end

--returns true if the node is an active consumer of power
function is_consumer(pos)
    for i,p in pairs(power_consumers) do
        if p.x == pos.x and p.y == pos.y and p.z == pos.z then
            return true
        end
    end
    return false
end

--for solar panels
function blocked(pos)
    if terraformer_on() == false then
        return true
    end
    for y = pos.y + 1, 100, 1 do
        local above = vector.new(pos.x, y, pos.z)
        local name = minetest.get_node(above).name
        local dt = minetest.registered_nodes[name]["drawtype"]
        local name_clear = name == "air" or name == "ignore"
        local dt_clear = dt == "airlike" or dt == "glasslike" or dt == "glasslike_framed"
        if name_clear == false and dt_clear == false then
            return true
        end
    end
    return false
end

