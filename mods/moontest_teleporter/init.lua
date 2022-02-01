--[[
    Teleporter
    Author: Droog71
    License: AGPLv3
]]--

local players = {}

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    if node.name == "moontest_teleporter:teleporter" then
        local teleporting = false
        local player_name = puncher:get_player_name()
        for index,name in pairs(players) do
            if name == player_name then
                teleporting = true
                break
            end
        end
        if power_on() and teleporting == false then
            table.insert(players, player_name)
            local destination = vector.new(20, 8, -4)
            if pos.y >= 7 then
                destination = vector.new(20, 1, -4)
            end
            puncher:set_pos(destination)
            minetest.sound_play("teleporter", {
                pos = destination,
                max_hear_distance = 8
            })
            minetest.after(3, function()
                for index,name in pairs(players) do
                    if name == player_name then
                        table.remove(players, index)
                        break
                    end
                end
            end)
        end
    end
end)

minetest.register_node("moontest_teleporter:teleporter", {
	description = "teleporter",
	tiles = {"teleporter.png"}
})
