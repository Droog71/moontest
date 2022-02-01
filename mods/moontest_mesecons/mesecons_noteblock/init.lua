minetest.register_node("moontest_mesecons_noteblock:noteblock", {
	description = "Noteblock\n" .. "Emits a sound when energized.",
	tiles = {"mesecons_noteblock.png"},
	is_ground_content = false,
	groups = {dig_immediate=2},
	on_punch = function(pos, node, puncher) -- change sound when punched
		if minetest.is_protected(pos, puncher and puncher:get_player_name() or "") then
			return
		end

		node.param2 = (node.param2+1)%12
		mesecon.noteblock_play(pos, node.param2)
		minetest.set_node(pos, node)
	end,
	sounds = nil,
	mesecons = {effector = { -- play sound when activated
		action_on = function(pos, node)
			mesecon.noteblock_play(pos, node.param2)
		end
	}},
	on_blast = mesecon.on_blastnode,
})

minetest.register_craft({
	output = "moontest_mesecons_noteblock:noteblock 1",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:mesecon_conductor_craftable", "default:steel_ingot", "group:mesecon_conductor_craftable"},
		{"group:wood", "group:wood", "group:wood"},
	}
})

local soundnames = {
	[0] = "moontest_mesecons_noteblock_csharp",
	"moontest_mesecons_noteblock_d",
	"moontest_mesecons_noteblock_dsharp",
	"moontest_mesecons_noteblock_e",
	"moontest_mesecons_noteblock_f",
	"moontest_mesecons_noteblock_fsharp",
	"moontest_mesecons_noteblock_g",
	"moontest_mesecons_noteblock_gsharp",

	"moontest_mesecons_noteblock_a",
	"moontest_mesecons_noteblock_asharp",
	"moontest_mesecons_noteblock_b",
	"moontest_mesecons_noteblock_c"
}

local node_sounds = {
	["default:lava_source"] = "fire_fire",
	["default:chest"] = "moontest_mesecons_noteblock_snare",
	["default:chest_locked"] = "moontest_mesecons_noteblock_snare",
	["default:coalblock"] = "tnt_explode",
	["default:glass"] = "moontest_mesecons_noteblock_hihat",
	["default:obsidian_glass"] = "moontest_mesecons_noteblock_hihat",
}

local node_sounds_group = {
	["stone"] = "moontest_mesecons_noteblock_kick",
	["tree"] = "moontest_mesecons_noteblock_crash",
	["wood"] = "moontest_mesecons_noteblock_litecrash",
}

mesecon.noteblock_play = function(pos, param2)
	pos.y = pos.y-1
	local nodeunder = minetest.get_node(pos).name
	local soundname = node_sounds[nodeunder]
	if not soundname then
		for k,v in pairs(node_sounds_group) do
			local g = minetest.get_item_group(nodeunder, k)
			if g ~= 0 then
				soundname = v
				break
			end
		end
	end
	if not soundname then
		soundname = soundnames[param2]
		if not soundname then
			minetest.log("error", "[moontest_mesecons_noteblock] No soundname found, test param2")
			return
		end
		if nodeunder == "default:steelblock" then
			soundname = soundname.. 2
		end
	end
	pos.y = pos.y+1
	if soundname == "fire_fire" then
		-- Smoothly fade out fire sound
		local handle = minetest.sound_play(soundname, {pos = pos, loop = true})
		minetest.after(3.0, minetest.sound_fade, handle, -1.5, 0.0)
	else
		minetest.sound_play(soundname, {pos = pos}, true)
	end
end
