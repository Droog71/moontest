--[[
    Moon Habitat Simulator
    Version: 1.0.4
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--defines the sleep formspec
function sleep_formspec(player)
    local formspec = {
        "size[2,0.5]",
        "bgcolor[#2d2d2d;false]",
        "button[0,0.1;2,0.5;wakeup;Wake Up]"
    }
    return formspec
end

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()
    if formname == "sleep" then
        for key, val in pairs(fields) do
            if key == "wakeup" then
                wake_up(player, name)
            end
        end
    end
end)