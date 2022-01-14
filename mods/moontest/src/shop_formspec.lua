--[[
    Moon Habitat Simulator
    Version: 1.0.5
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

local page = 1
local index = 1
local item_buttons = {}
local item_btn_keys = {}
local loaded = false

local items_for_sale = { 
    {
        ["Wire"] = "mesecons:wire_00000000_off",
        ["Switch"] = "mesecons_switch:mesecon_switch_off",
        ["Button"] = "mesecons_button:button_off",
        ["Note Block"] = "mesecons_noteblock:noteblock",
        ["Screw Driver"] = "screwdriver2:screwdriver",
        ["Flashlight"] = "work_lights:flashlight",
        ["Crate"] = "moontest:crate"
    },
    {
        ["Fuel"] = "portable_power:fuel",
        ["Work Light"] = "work_lights:work_light_off",
        ["Generator"] = "portable_power:generator",
        ["Solar Panel"] = "portable_power:solar_panel",
        ["Research Probe"] = "moontest:research_probe",
        ["Robot"] = "lwscratch:robot",
        ["Robot Disk"] = "lwscratch:cassette"
    },
    {
        ["Delayer"] = "mesecons_delayer:delayer_off_1",
        ["Microcontroller"] = "mesecons_microcontroller:microcontroller0000",
        ["Sensor"] = "moontest:sensor",
        ["Relay"] = "moontest:relay_off",
        ["Reactor Booster"] = "moontest:reactor_booster",
        ["REM Extractor"] = "rem:extractor",
        ["REM Rocket"] = "rem:rocket",
        ["Terraformer"] = "terraformer:terraformer_off"
    }
}

local item_prices = { 
    {
        ["Wire"] = 8,
        ["Switch"] = 16,
        ["Button"] = 32,
        ["Note Block"] = 16,
        ["Screw Driver"] = 32,
        ["Flashlight"] = 64,
        ["Crate"] = 64
    },
    {
        ["Fuel"] = 8,
        ["Work Light"] = 128,
        ["Generator"] = 2048,
        ["Solar Panel"] = 2048,
        ["Research Probe"] = 4096,
        ["Robot"] = 1024,
        ["Robot Disk"] = 128
    },
    {
        ["Delayer"] = 2048,
        ["Microcontroller"] = 2048,
        ["Sensor"] = 1024,
        ["Relay"] = 1024,
        ["Reactor Booster"] = 4096,
        ["REM Extractor"] = 4096,
        ["REM Rocket"] = 4096,
        ["Terraformer"] = 262144
    }
}

local research_levels = { 
    {
        ["Wire"] = 1,
        ["Switch"] = 1,
        ["Button"] = 1,
        ["Note Block"] = 1,
        ["Screw Driver"] = 1,
        ["Flashlight"] = 1,
        ["Crate"] = 1
    },
    {
        ["Fuel"] = 1,
        ["Work Light"] = 1,
        ["Generator"] = 1,
        ["Solar Panel"] = 1,
        ["Research Probe"] = 1,
        ["Robot"] = 2,
        ["Robot Disk"] = 2
    },
    {
        ["Delayer"] = 4,
        ["Microcontroller"] = 4,
        ["Sensor"] = 4,
        ["Relay"] = 4,
        ["Reactor Booster"] = 6,
        ["REM Extractor"] = 6,
        ["REM Rocket"] = 6,
        ["Terraformer"] = 8
    }
}

local function get_page_buttons()
    for item_name,item in pairs(items_for_sale[page]) do
        local stack = ItemStack(item)
        item_buttons[index] = "label[0.5," .. index + 0.6 .. ";" ..
            "Research: " .. research_levels[page][item_name] .. "]button[3," ..
            index .. ";4,2;" .. item_name ..
            ";" .. item_name .. "]" ..
            "item_image[7," .. index + 0.6 ..
            ";0.6,0.6;" .. item .. "]" ..
            "tooltip[" .. item_name .. ";" ..
            stack:get_description() .. ";#353535;#FFFFFF]" ..
            "label[8," .. index + 0.6 .. ";" .. " $" .. 
            item_prices[page][item_name] .."]"
        item_btn_keys[item_name] = item
        index = index + 1
    end
    for i = index,get_size(item_buttons),1 do
        item_buttons[i] = ""
    end
    index = 1
end

minetest.register_on_joinplayer(function(player)
    if loaded == false then
        get_page_buttons()
        loaded = true
    end
end)

--defines the shop formspec
function shop_formspec(player)
    local formspec = {
        "size[10,16]",
        "bgcolor[#353535;false]",
        "label[4.5,0.5;Shop]",
        table.concat(item_buttons),
        "field[4.25,11;2,1;amount;amount;]",
        "label[3.5,12;".."Your balance: $" .. money.."]",
        "button[1.5,13;3,0.75;<-;<-]",
        "button[5.5,13;3,0.75;->;->]",
        "button[3,14;4,2;Back;Back]"
    }
    return formspec
end

--handles clicked buttons
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local shop_fs = shop_formspec(player)
    local current_fs = player:get_inventory_formspec()
    if current_fs == table.concat(shop_fs, "") then
        local player_name = player:get_player_name()
        for key, val in pairs(fields) do
            if key == "Back" then
                local formspec = inventory_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "->" then
                if page < 3 then
                    page = page + 1
                else
                    page = 1
                end
                get_page_buttons()
                local formspec = shop_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            elseif key == "<-" then
                if page > 1 then
                    page = page - 1
                else
                    page = 3
                end
                get_page_buttons()
                local formspec = shop_formspec(player)
                player:set_inventory_formspec(table.concat(formspec, ""))
            else
                for item_name,item in pairs(item_btn_keys) do
                    if key == item_name and key ~= "Terraformer" then
                        local item = ItemStack(item)
                        local count = 1
                        if fields.amount then
                            if tonumber(fields.amount) then
                                count = tonumber(fields.amount)
                                if count > 99 then count = 99 end
                                item:set_count(count)
                            end
                        end
                        local price = item_prices[page][item_name] * count
                        local research_required = research_levels[page][item_name]
                        if money >= price then
                            if research_progress >= research_required then
                                if player:get_inventory():add_item("main", item) then
                                    money = money - price
                                    add_hud_message(player_name .. " bought " .. count .. "x '" .. item_name .. "'.")
                                    local formspec = shop_formspec(player)
                                    player:set_inventory_formspec(table.concat(formspec, ""))
                                end
                            else
                                local research_message = "Insufficient research level: " ..
                                    research_progress .. "/" .. research_required
                                minetest.chat_send_player(player_name, research_message)
                            end
                        else
                            minetest.chat_send_player(player_name, "You can't afford that!")
                        end
                    elseif key == item_name and key == "Terraformer" then
                        local tf_node = minetest.get_node(terraformer_pos).name
                        if tf_node ~= "terraformer:terraformer_on" and tf_node ~= "terraformer:terraformer_off" then
                            local price = item_prices[page][item_name]
                            local research_required = research_levels[page][item_name]
                            if money >= price then
                                if research_progress >= research_required then
                                    build_terraformer()
                                    money = money - price
                                    add_hud_message(player_name .. " bought " .. "'" .. item_name .. "'.")
                                    local formspec = shop_formspec(player)
                                    player:set_inventory_formspec(table.concat(formspec, ""))
                                else
                                    local research_message = "Insufficient research level: " ..
                                        research_progress .. "/" .. research_required
                                    minetest.chat_send_player(player_name, research_message)
                                end
                            else
                                minetest.chat_send_player(player_name, "You can't afford that!")
                            end
                        else
                            minetest.chat_send_player(player_name, "Terraformer already installed!")
                        end
                    end
                end
            end
        end   
    end
end)