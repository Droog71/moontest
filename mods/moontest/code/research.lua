--[[
    Moon Habitat Simulator
    Version: 1.01
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

research_progress = 1

--defines the organic matter item and on_use function
minetest.register_craftitem("moontest:splat", {
    description = "Organic matter.",
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
                        if research_progress < 5 then
                            research_progress = research_progress + (amount * 0.01)
                            if research_progress > 5 then research_progress = 5 end
                            add_hud_message("Research data is now worth $" .. 
                                math.floor(10 * research_progress) .. " per item.")
                        end
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
