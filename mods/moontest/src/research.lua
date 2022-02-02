--[[
    Moon Habitat Simulator
    Version: 1.0.5
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

research_progress = 1

--defines the organic matter item and on_use function
minetest.register_craftitem("moontest:splat", {
    description = "Organic matter.\n" ..
    "[research item]",
    inventory_image = "splat.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.under ~= nil then
            local under = minetest.get_node(pointed_thing.under)
            if under ~= nil and power_on() then
                if under.name == "moontest:research_station" or under.name == "moontest:research_panel" then
                    local amount = 0
                    local worth = 0
                    for i = 1,itemstack:get_count(),1 do
                        if itemstack:take_item() ~= nil then
                            amount = amount + 1
                            worth = worth + (10 * research_progress)
                        end	
                    end
                    if amount > 0 then
                        money = math.floor(money + worth)
                        add_hud_message(user:get_player_name() .. 
                            " processed $" .. math.floor(worth) .. " worth of research data.")
                        if research_progress <= 10 then
                            research_progress = research_progress + (amount * 0.01)
                            if research_progress > 10 then research_progress = 10 end
                        end
                        add_hud_message("Reseaerch level: " .. research_progress)
                        add_hud_message("Research data is now worth $" .. 
                        math.floor(10 * research_progress) .. " per item.")
                        minetest.sound_play('research', {
                            pos = research_station_pos,
                            max_hear_distance = 16
                        })
                    end
                    return itemstack
                end
            end
        end
    end
})

--defines the research data item and on_use function
minetest.register_craftitem("moontest:research_data", {
    description = "Research data.\n" ..
    "[research item]",
    inventory_image = "research_data.png",
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.under ~= nil then
            local under = minetest.get_node(pointed_thing.under)
            if under ~= nil and power_on() then
                if under.name == "moontest:research_station" or under.name == "moontest:research_panel" then
                    local amount = 0
                    local worth = 0
                    for i = 1,itemstack:get_count(),1 do
                        if itemstack:take_item() ~= nil then
                            amount = amount + 1
                            worth = worth + (10 * research_progress)
                        end	
                    end
                    if amount > 0 then
                        money = math.floor(money + worth)
                        add_hud_message(user:get_player_name() .. 
                            " processed $" .. math.floor(worth) .. " worth of research data.")
                        if research_progress <= 10 then
                            research_progress = research_progress + (amount * 0.01)
                            if research_progress > 10 then research_progress = 10 end
                        end
                        add_hud_message("Reseaerch level: " .. research_progress)
                        add_hud_message("Research data is now worth $" .. 
                        math.floor(10 * research_progress) .. " per item.")
                        minetest.sound_play('research', {
                            pos = research_station_pos,
                            max_hear_distance = 16
                        })
                    end
                    return itemstack
                end
            end
        end
    end
})

minetest.register_node("moontest:moon_rock", {
    name = "moon_rock",
    description = "Moon Rock\n" ..
    "[research item]",
    drawtype = 'mesh',
    mesh = "moon_rock.obj",
    tiles = {"moon_rock.png"},
    groups = {dig_immediate=2},
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.under ~= nil then
            local under = minetest.get_node(pointed_thing.under)
            if under ~= nil and power_on() then
                if under.name == "moontest:research_station" or under.name == "moontest:research_panel" then
                    local amount = 0
                    local worth = 0
                    for i = 1,itemstack:get_count(),1 do
                        if itemstack:take_item() ~= nil then
                            amount = amount + 1
                            worth = worth + (10 * research_progress)
                        end	
                    end
                    if amount > 0 then
                        money = math.floor(money + worth)
                        add_hud_message(user:get_player_name() .. 
                            " processed $" .. math.floor(worth) .. " worth of research data.")
                        if research_progress <= 10 then
                            research_progress = research_progress + (amount * 0.01)
                            if research_progress > 10 then research_progress = 10 end
                        end
                        add_hud_message("Reseaerch level: " .. research_progress)
                        add_hud_message("Research data is now worth $" .. 
                        math.floor(10 * research_progress) .. " per item.")
                        minetest.sound_play('research', {
                            pos = research_station_pos,
                            max_hear_distance = 16
                        })
                    end
                    return itemstack
                end
            end
        end
    end
})

--research probe
minetest.register_node("moontest:research_probe", {
    description = "Research Probe\nGathers research data.\n" ..
        "More effective the farther it is placed from the habitat\n" ..
        "and from other research probes.",
    tiles = {"research_probe.png"},
    drawtype = 'mesh',
    mesh = "research_probe.obj",
    groups = {dig_immediate=2},
    paramtype2="facedir",
    on_construct = function(pos)
        table.insert(power_consumers, pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
            "size[8,9]"..
            "list[current_name;main;0,0;8,4;]"..
            "list[current_player;main;0,5;8,4;]" ..
            "listring[]")
        local inv = meta:get_inventory()
        inv:set_size("main", 4*1)
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
    end,
    can_dig = function(pos,player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
       return stack:get_count()
    end
})

--operation of the research probe
minetest.register_abm({
    nodenames = {"moontest:research_probe"},
    interval = 10,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local power = minetest.get_meta(pos):get_int("power")
        if is_consumer(pos) == false then
            table.insert(power_consumers, pos)
        elseif power_stable(pos) or power == 1 then
            minetest.get_meta(pos):set_int("power", 0)
            local chance = math.random(1,100)
            if chance >= 50 then
                local habitat_range = vector.distance(vector.new(0, 0, 0), pos)
                local other_range = 0
                for i,p in pairs(power_consumers) do
                    if minetest.get_node(p).name == "moontest:research_probe" then
                        local dist = vector.distance(pos, p)
                        if dist > other_range then other_range = dist end
                    end
                end
                local median_range = (habitat_range + other_range) / 2
                local amount = math.floor(median_range * 0.025)
                if amount < 1 then amount = 1 end
                if amount > 5 then amount = 5 end
                local meta = minetest.get_meta(pos)
                local inv = meta:get_inventory()
                local stack = ItemStack("moontest:research_data")
                stack:set_count(amount)
                if inv:add_item("main", stack) then
                    minetest.sound_play('research', {
                        pos = pos,
                        gain = 0.5,
                        max_hear_distance = 16
                    })
                    minetest.add_particlespawner({
                        amount = 1,
                        time = 1,
                        minpos = {x=pos.x-0.1,y=pos.y+1,z=pos.z-0.1},
                        maxpos = {x=pos.x+0.1,y=pos.y+2,z=pos.z+0.1},
                        minvel = {x=0.1, y=0.01, z=0.1},
                        maxvel = {x=0.1, y=0.05, z=0.1},
                        minacc = {x=-0.1,y=0.1,z=-0.1},
                        maxacc = {x=0.1,y=0.2,z=0.1},
                        minexptime = 1,
                        maxexptime = 2,
                        minsize = 4,
                        maxsize = 6,
                        collisiondetection = false,
                        vertical = false,
                        texture = "research_data.png"
                    })
                end
            end
        end
        local power_disp = (power_stable(pos) or power == 1) and "on" or "off"
        minetest.get_meta(pos):set_string("infotext", "Research Probe\n" .. "Power: " .. power_disp)
    end
})