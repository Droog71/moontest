--[[
    Moon Habitat Simulator
    Version: 1.0.4
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--defines the inventory formspec
function inventory_formspec(player)
    local formspec = {
        "size[8,7.5]",
        "bgcolor[#2d2d2d;false]",
        "list[current_player;main;0,3.5;8,4;]",
        "button[1.5,0.75;2,0.5;Tutorial;Tutorial]",
        "button[1.5,2;2,0.5;Manual;Manual]",
        "button[4.5,0.75;2,0.5;Shop;Shop]",
        "button[4.5,2;2,0.5;Power;Power]"
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
            elseif key == "Power" then
                local formspec = power_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            end
        end
    end
end)