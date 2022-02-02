--[[
    Moon Habitat Simulator
    Version: 1.0.6
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local background = "form_bg.png"
local computer_drill = "computer_drill.png"
local computer_gravity = "computer_gravity.png"
local red = "red.png"
local green = "green.png"
local blue = "blue.png"

--defines the computer formspec
function computer_formspec()
    local drill_active = bool_to_number(drill_on())
    local gravity_active = bool_to_number(gravity_on())
    local ds = drill_speed > 2000 and 2000 or drill_speed
    local dr = drill_resistance > 2000 and 2000 or drill_resistance
    local dc = drill_cooling > 2000 and 2000 or drill_cooling
    local dd = drill_digging > 2000 and 2000 or drill_digging
    local dp = drill_power > 2000 and 2000 or drill_power
    local gg = generated_gravity > 100 and 100 or generated_gravity
    local sb = stability > 100 and 100 or stability
    if terraformer_on() then sb = 100 end
    local on_formspec = {
        "size[30,22]",
        "bgcolor[#2d2d2d;false]",
        "image[-1,-1;40,28;"..background.."]",
        "label[6,1;Drill]",
        "image[4.25,2;5.51,6.61;"..computer_drill.."]",
        "label[3,9.15;Speed: ]",
        "label[3,11.15;Resistance: ]",
        "label[3,13.15;Cooling: ]",
        "label[3,15.15;Production: ]",
        "label[3,17.15;Electrical load: ]",
        "image[6,9;" .. drill_active * ds * 0.005 .. ",1;"..green.."]",
        "image[6,11;" .. dr * 0.005 .. ",1;"..red.."]",
        "image[6,13;" .. dc * 0.005 .. ",1;"..blue.."]",
        "image[6,15;" .. dd * 0.005 .. ",1;"..green.."]",
        "image[6,17;" .. dp * 0.005 .. ",1;"..red.."]",
        "label[20.65,1;Gravity Generator]",
        "image[20.25,2;4.824,6.633;"..computer_gravity.."]",
        "label[19,9.15;Intensity: ]",
        "image[22,9;" .. gravity_active * gg * 0.05 .. ",1;"..green.."]",
        "image[22,11;" .. sb * 0.05 .. ",1;"..blue.."]",
        "label[19,11.15;Habitat stability: ]",
        "label[13.5,20;Press escape to exit.]",
    }
      local off_formspec = {
        "size[30,22]",
        "bgcolor[#2d2d2d;false]",
        "label[14,19.9;Computer has lost power.]",
        "label[14,20;Press escape to exit.]",
    }
    if power_on() then 
        return on_formspec
    end
    return off_formspec
end

--updates the computer formspec
function update_computer_formspec()
    local formspec = table.concat(computer_formspec())
    minetest.get_meta(computer_pos):set_string("formspec", formspec)
end