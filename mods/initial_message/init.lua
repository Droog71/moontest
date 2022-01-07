--[[
    Moon Habitat Simulator
    Version: 1.0.3
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

--defines the greeting formspec
local function greeting_formspec(player)
    local greeting = 
      "Welcome to Moontest: Moon Habitat Simulator!\n" .. 
      "Press I to open your inventory.\n" ..
      "Click the tutorial button there to start the tutorial.\n" ..
      "Alternatively, click the manual button to read the manual.\n\n" ..
      "Good luck and have fun!"
    local formspec = {
        "size[8.5,6]",
        "bgcolor[#2d2d2d;false]",
        "button_exit[3.25,5;2,0.5;OK;OK]",
        "label[1.5,1;" .. greeting .. "]"
    }
    return formspec
end

--shows the greeting formspec
minetest.register_on_joinplayer(function(player)
    local cb = function(player)
        if not player or not player:is_player() then
            return
        end
        local name = player:get_player_name()
        minetest.show_formspec(name, "greeting", table.concat(greeting_formspec()))
    end
    minetest.after(2.0, cb, player)
end)
