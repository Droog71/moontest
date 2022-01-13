--[[
    Moon Habitat Simulator
    Version: 1.0.4
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

hunger_levels = {}
local hunger_timer = 0

--initializes the hunger variable
minetest.register_on_joinplayer(function(player)
    if player then
        hunger_levels[player:get_player_name()] = 100
    end
end)

--defines the space food item and on_use function
minetest.register_craftitem("moontest:space_food", {
    description = "Freeze dried food paste.",
    inventory_image = "space_food.png",
    on_use = function(itemstack, user, pointed_thing)
        local name = user:get_player_name()
        if is_sleeping(name) == false then
            if hunger_levels[name] <= 99 and itemstack:take_item() ~= nil then
                local hunger = 100 - hunger_levels[name]
                if hunger <= 10 then
                    hunger_levels[name] = hunger_levels[name] + hunger
                else
                    hunger_levels[name] = hunger_levels[name] + 10
                end		  
                minetest.sound_play('eat', {
                        pos = user:get_pos(),
                        max_hear_distance = 16,
                        gain = 0.5
                    })
                update_hunger_hud(name)
                return itemstack
            elseif user:get_hp() <= 99 and itemstack:take_item() ~= nil then
                local health = 100 - user:get_hp()
                if health <= 10 then               
                    user:set_hp(user:get_hp() + health)    
                else
                    user:set_hp(user:get_hp() + 10)
                end 
                minetest.sound_play('eat', {
                        pos = user:get_pos(),
                        max_hear_distance = 16,
                        gain = 0.5
                    })
                update_hunger_hud(name)
                return itemstack
            end
        end
    end
})

--manages hunger for all players
function update_hunger()
    hunger_timer = hunger_timer + 1
    if hunger_timer >= 150 then
        for name, hunger_level in pairs(hunger_levels) do
            local player = minetest.get_player_by_name(name)
            if hunger_levels[name] > 0 and player:get_hp() > 0 then
                hunger_levels[name] = hunger_levels[name] - 1
                update_hunger_hud(name)
            else
                if minetest.get_player_by_name(name):get_hp() > 0 then
                    hurt_player(name)
                end
            end
        end
        hunger_timer = 0
    end
end

--called when the player left clicks the space food vending machine
function buy_space_food(buyer, amount)
    local item = ItemStack("moontest:space_food")
    item:set_count(amount)
    buyer:get_inventory():add_item("main", item)
    local list = buyer:get_inventory():get_list("main")
    for index_1,stack_1 in pairs(list) do
        local current = buyer:get_inventory():get_stack("main", index_1):get_name()
        if current == "moontest:space_food" and index_1 < 9 then
            for index_2,stack_2 in pairs(list) do
                if stack_2:is_empty() and index_2 > 8 then
                    local empty = ItemStack("")
                    buyer:get_inventory():set_stack("main", index_1, empty)
                    buyer:get_inventory():set_stack("main", index_2, stack_1)
                    break
                end
            end
        end
    end
    money = money - 10 * amount
    minetest.sound_play('vending', {
        pos = food_vending_bottom_pos,
        max_hear_distance = 16,
        gain = 0.5
    })
    add_hud_message(buyer:get_player_name() .. " bought " .. amount .. "x space food.")
end