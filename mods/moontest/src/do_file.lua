--[[
    Moon Habitat Simulator
    Version: 1.0.6
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local function do_file(filename)
    dofile(minetest.get_modpath("moontest") .. DIR_DELIM .. "src" .. DIR_DELIM .. filename .. ".lua")
end

do_file("nodes")
do_file("habitat")
do_file("oxygen")
do_file("climate")
do_file("hunger")
do_file("energy")
do_file("machines")
do_file("interaction")
do_file("simulation")
do_file("reactor_booster")
do_file("logic")
do_file("aliens")
do_file("research")
do_file("sprint")
do_file("hud")
do_file("inventory_formspec")
do_file("manual_formspec")
do_file("computer_formspec")
do_file("shop_formspec")
do_file("sleep_formspec")
do_file("tutorial")
do_file("welcome_message")
