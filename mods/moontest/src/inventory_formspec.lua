--[[
    Moon Habitat Simulator
    Version: 1.0.5
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--defines the inventory formspec
function inventory_formspec(player)
    local formspec = {
        "size[8,7.5]",
        "bgcolor[#2d2d2d;false]",
        "list[current_player;main;0,3.5;8,4;]",
        "button[1,1.5;2,0.5;Tutorial;Tutorial]",
        "button[3,1.5;2,0.5;Manual;Manual]",
        "button[5,1.5;2,0.5;Shop;Shop]",
    }
    return formspec
end

--sets the inventory formspec
minetest.register_on_joinplayer(function(player)
    local formspec = inventory_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end)

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()
    local menu_fs = inventory_formspec(player)
    local current_fs = player:get_inventory_formspec()
    if current_fs == table.concat(menu_fs, "") and habitat_built == true then
        for key, val in pairs(fields) do
            if key == "Manual" then
                local formspec = manual_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Shop" then
                local formspec = shop_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "Tutorial" then
                start_tutorial(player)
            end
        end
    end
end)