--[[
    Shop Menu
    Author: Droog71
    License: AGPLv3
]]--

local index = 1
local item_buttons = {}
local item_btn_keys = {}
local loaded = false

local items_for_sale = { 
    ["wire"] = "mesecons:wire_00000000_off",
    ["switch"] = "mesecons_switch:mesecon_switch_off",
    ["noteblock"] = "mesecons_noteblock:noteblock",
    ["button"] = "mesecons_button:button_off",
    ["delayer"] = "mesecons_delayer:delayer_off_1",
    ["controller"] = "mesecons_microcontroller:microcontroller0000",
    ["sensor"] = "moontest:sensor",
    ["relay"] = "moontest:relay_off",
    ["reactor_booster"] = "moontest:reactor_booster"
}
local item_prices = { 
    ["wire"] = 10,
    ["switch"] = 20,
    ["noteblock"] = 10,
    ["button"] = 20,
    ["delayer"] = 100,
    ["controller"] = 250,
    ["sensor"] = 250,
    ["relay"] = 250,
    ["reactor_booster"] = 500
}

minetest.register_on_joinplayer(function(player)
    if loaded == false then
        for item_name,item in pairs(items_for_sale) do
            item_buttons[index] = "button[3," .. 
                index .. ";4,2;" .. item_name ..
                ";" .. item_name .. "]" ..
                "item_image[7," .. index + 0.6 .. 
                ";0.6,0.6;" .. item .. "]" ..
                "label[8," .. index + 0.6 .. ";" .. " $" .. 
                item_prices[item_name] .."]"
            item_btn_keys[item_name] = item
            index = index + 1
        end
        loaded = true
    end
end)

--defines the shop formspec
function shop_formspec(player)
    local formspec = {
        "size[10,16]",
        "bgcolor[#353535;false]",
        table.concat(item_buttons),
        "label[3.5,11.5;".."Your balance: $" .. money.."]",
        "button[3,13;4,2;Back;Back]"
    }
    return formspec
end

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "" then return end
    local player_name = player:get_player_name()
    for key, val in pairs(fields) do
        for item_name,item in pairs(item_btn_keys) do
            if key == item_name then
                local item = ItemStack(item)
                if money >= item_prices[item_name] then
                    if player:get_inventory():add_item("main", item) then
                        money = money - item_prices[item_name]
                        add_hud_message(
                            player_name .. " bought a " .. item_name .. "."
                        )
                        local formspec = shop_formspec(player)
                        player:set_inventory_formspec(table.concat(formspec, ""))
                    end
                else
                    minetest.chat_send_player(player_name, "You can't afford that!")
                end
            end
        end
    end    
end)