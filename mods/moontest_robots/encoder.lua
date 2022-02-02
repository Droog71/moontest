local utils = ...



local encode_cmd =
{
	["moontest_robots:cmd_act_move_front"]				= "AA",
	["moontest_robots:cmd_act_move_back"]				= "AB",
	["moontest_robots:cmd_act_move_down"]				= "AC",
	["moontest_robots:cmd_act_move_up"]					= "AD",
	["moontest_robots:cmd_act_turn_left"]				= "AE",
	["moontest_robots:cmd_act_turn_right"]				= "AF",
	["moontest_robots:cmd_act_dig_front"]				= "AG",
	["moontest_robots:cmd_act_dig_front_down"]		= "AH",
	["moontest_robots:cmd_act_dig_front_up"]			= "AI",
	["moontest_robots:cmd_act_dig_back"]				= "AJ",
	["moontest_robots:cmd_act_dig_back_down"]			= "AK",
	["moontest_robots:cmd_act_dig_back_up"]			= "AL",
	["moontest_robots:cmd_act_dig_down"]				= "AM",
	["moontest_robots:cmd_act_dig_up"]					= "AN",
	["moontest_robots:cmd_act_place_front"]			= "AO",
	["moontest_robots:cmd_act_place_front_down"]		= "AP",
	["moontest_robots:cmd_act_place_front_up"]		= "AQ",
	["moontest_robots:cmd_act_place_back"]				= "AR",
	["moontest_robots:cmd_act_place_back_down"]		= "AS",
	["moontest_robots:cmd_act_place_back_up"]			= "AT",
	["moontest_robots:cmd_act_place_down"]				= "AU",
	["moontest_robots:cmd_act_place_up"]				= "AV",
	["moontest_robots:cmd_act_pull"]						= "AW",
	["moontest_robots:cmd_act_put"]						= "AX",
	["moontest_robots:cmd_act_pull_stack"]				= "AY",
	["moontest_robots:cmd_act_put_stack"]				= "AZ",
	["moontest_robots:cmd_act_craft"]					= "BA",
	["moontest_robots:cmd_act_drop"]						= "BB",
	["moontest_robots:cmd_act_trash"]					= "BC",
	["moontest_robots:cmd_act_drop_stack"]				= "BD",
	["moontest_robots:cmd_act_trash_stack"]			= "BE",
	["moontest_robots:cmd_act_value_assign"]			= "BF",
	["moontest_robots:cmd_act_value_plus"]				= "BG",
	["moontest_robots:cmd_act_value_minus"]			= "BH",
	["moontest_robots:cmd_act_value_multiply"]		= "BI",
	["moontest_robots:cmd_act_value_divide"]			= "BJ",
	["moontest_robots:cmd_act_stop"]						= "BK",
	["moontest_robots:cmd_act_wait"]						= "BL",
	["moontest_robots:cmd_act_chat"]						= "BM",
	["moontest_robots:cmd_value_number"]				= "BN",
	["moontest_robots:cmd_value_text"]					= "BO",
	["moontest_robots:cmd_value_value"]					= "BP",
	["moontest_robots:cmd_name_front"]					= "BQ",
	["moontest_robots:cmd_name_front_down"]			= "BR",
	["moontest_robots:cmd_name_front_up"]				= "BS",
	["moontest_robots:cmd_name_back"]					= "BT",
	["moontest_robots:cmd_name_back_down"]				= "BU",
	["moontest_robots:cmd_name_back_up"]				= "BV",
	["moontest_robots:cmd_name_down"]					= "BW",
	["moontest_robots:cmd_name_up"]						= "BX",
	["moontest_robots:cmd_stat_if"]						= "BY",
	["moontest_robots:cmd_stat_loop"]					= "BZ",
	["moontest_robots:cmd_op_not"]						= "CA",
	["moontest_robots:cmd_op_and"]						= "CB",
	["moontest_robots:cmd_op_or"]							= "CC",
	["moontest_robots:cmd_cond_counter_equal"]		= "CD",
	["moontest_robots:cmd_cond_counter_greater"]		= "CE",
	["moontest_robots:cmd_cond_counter_less"]			= "CF",
	["moontest_robots:cmd_cond_counter_even"]			= "CG",
	["moontest_robots:cmd_cond_counter_odd"]			= "CH",
	["moontest_robots:cmd_cond_value_equal"]			= "CI",
	["moontest_robots:cmd_cond_value_greater"]		= "CJ",
	["moontest_robots:cmd_cond_value_less"]			= "CK",
	["moontest_robots:cmd_cond_value_even"]			= "CL",
	["moontest_robots:cmd_cond_value_odd"]				= "CM",
	["moontest_robots:cmd_cond_contains"]				= "CN",
	["moontest_robots:cmd_cond_fits"]					= "CO",
	["moontest_robots:cmd_cond_detect_front"]			= "CP",
	["moontest_robots:cmd_cond_detect_front_down"]	= "CQ",
	["moontest_robots:cmd_cond_detect_front_up"]		= "CR",
	["moontest_robots:cmd_cond_detect_back"]			= "CS",
	["moontest_robots:cmd_cond_detect_back_down"]	= "CT",
	["moontest_robots:cmd_cond_detect_back_up"]		= "CU",
	["moontest_robots:cmd_cond_detect_down"]			= "CV",
	["moontest_robots:cmd_cond_detect_up"]				= "CW",
	[""]													= "ZZ",
}



local dencode_cmd =
{
	["AA"] = "moontest_robots:cmd_act_move_front",
	["AB"] = "moontest_robots:cmd_act_move_back",
	["AC"] = "moontest_robots:cmd_act_move_down",
	["AD"] = "moontest_robots:cmd_act_move_up",
	["AE"] = "moontest_robots:cmd_act_turn_left",
	["AF"] = "moontest_robots:cmd_act_turn_right",
	["AG"] = "moontest_robots:cmd_act_dig_front",
	["AH"] = "moontest_robots:cmd_act_dig_front_down",
	["AI"] = "moontest_robots:cmd_act_dig_front_up",
	["AJ"] = "moontest_robots:cmd_act_dig_back",
	["AK"] = "moontest_robots:cmd_act_dig_back_down",
	["AL"] = "moontest_robots:cmd_act_dig_back_up",
	["AM"] = "moontest_robots:cmd_act_dig_down",
	["AN"] = "moontest_robots:cmd_act_dig_up",
	["AO"] = "moontest_robots:cmd_act_place_front",
	["AP"] = "moontest_robots:cmd_act_place_front_down",
	["AQ"] = "moontest_robots:cmd_act_place_front_up",
	["AR"] = "moontest_robots:cmd_act_place_back",
	["AS"] = "moontest_robots:cmd_act_place_back_down",
	["AT"] = "moontest_robots:cmd_act_place_back_up",
	["AU"] = "moontest_robots:cmd_act_place_down",
	["AV"] = "moontest_robots:cmd_act_place_up",
	["AW"] = "moontest_robots:cmd_act_pull",
	["AX"] = "moontest_robots:cmd_act_put",
	["AY"] = "moontest_robots:cmd_act_pull_stack",
	["AZ"] = "moontest_robots:cmd_act_put_stack",
	["BA"] = "moontest_robots:cmd_act_craft",
	["BB"] = "moontest_robots:cmd_act_drop",
	["BC"] = "moontest_robots:cmd_act_trash",
	["BD"] = "moontest_robots:cmd_act_drop_stack",
	["BE"] = "moontest_robots:cmd_act_trash_stack",
	["BF"] = "moontest_robots:cmd_act_value_assign",
	["BG"] = "moontest_robots:cmd_act_value_plus",
	["BH"] = "moontest_robots:cmd_act_value_minus",
	["BI"] = "moontest_robots:cmd_act_value_multiply",
	["BJ"] = "moontest_robots:cmd_act_value_divide",
	["BK"] = "moontest_robots:cmd_act_stop",
	["BL"] = "moontest_robots:cmd_act_wait",
	["BM"] = "moontest_robots:cmd_act_chat",
	["BN"] = "moontest_robots:cmd_value_number",
	["BO"] = "moontest_robots:cmd_value_text",
	["BP"] = "moontest_robots:cmd_value_value",
	["BQ"] = "moontest_robots:cmd_name_front",
	["BR"] = "moontest_robots:cmd_name_front_down",
	["BS"] = "moontest_robots:cmd_name_front_up",
	["BT"] = "moontest_robots:cmd_name_back",
	["BU"] = "moontest_robots:cmd_name_back_down",
	["BV"] = "moontest_robots:cmd_name_back_up",
	["BW"] = "moontest_robots:cmd_name_down",
	["BX"] = "moontest_robots:cmd_name_up",
	["BY"] = "moontest_robots:cmd_stat_if",
	["BZ"] = "moontest_robots:cmd_stat_loop",
	["CA"] = "moontest_robots:cmd_op_not",
	["CB"] = "moontest_robots:cmd_op_and",
	["CC"] = "moontest_robots:cmd_op_or",
	["CD"] = "moontest_robots:cmd_cond_counter_equal",
	["CE"] = "moontest_robots:cmd_cond_counter_greater",
	["CF"] = "moontest_robots:cmd_cond_counter_less",
	["CG"] = "moontest_robots:cmd_cond_counter_even",
	["CH"] = "moontest_robots:cmd_cond_counter_odd",
	["CI"] = "moontest_robots:cmd_cond_value_equal",
	["CJ"] = "moontest_robots:cmd_cond_value_greater",
	["CK"] = "moontest_robots:cmd_cond_value_less",
	["CL"] = "moontest_robots:cmd_cond_value_even",
	["CM"] = "moontest_robots:cmd_cond_value_odd",
	["CN"] = "moontest_robots:cmd_cond_contains",
	["CO"] = "moontest_robots:cmd_cond_fits",
	["CP"] = "moontest_robots:cmd_cond_detect_front",
	["CQ"] = "moontest_robots:cmd_cond_detect_front_down",
	["CR"] = "moontest_robots:cmd_cond_detect_front_up",
	["CS"] = "moontest_robots:cmd_cond_detect_back",
	["CT"] = "moontest_robots:cmd_cond_detect_back_down",
	["CU"] = "moontest_robots:cmd_cond_detect_back_up",
	["CV"] = "moontest_robots:cmd_cond_detect_down",
	["CW"] = "moontest_robots:cmd_cond_detect_up",
	["ZX"] = "itemstack",
	["ZZ"] = "",
}



function utils.encode_program (inv)
	local code = ""
	local rdata = { }

	for i = 1, utils.program_inv_size do
		local stack = inv:get_stack ("program", i)

		if stack and not stack:is_empty () then
			local c = encode_cmd[stack:get_name ()]

			if not c then
				-- itemstack
				c = "ZX"
			end

			if utils.is_value_item (stack:get_name ()) or
				utils.is_action_value_item (stack:get_name ()) or
				utils.is_condition_value_item (stack:get_name ()) then

				rdata[#rdata + 1] = stack:get_meta ():get_string ("value")

			elseif utils.is_inventory_item (stack:get_name ()) then
				rdata[#rdata + 1] = stack:to_string ()

			end

			code = code..c
		else
			code = code.."ZZ"
		end
	end

	return { code = code, rdata = rdata }
end



function utils.dencode_program (inv, encoded)
	if encoded then
		local code = encoded.code
		local rdata = encoded.rdata
		local rdata_idx = 1

		for i = 1, utils.program_inv_size do
			local c = code:sub (((i - 1) * 2) + 1, ((i - 1) * 2) + 2)
			local name = dencode_cmd[c]
			local stack = nil

			if name == "itemstack" then
				stack = ItemStack (rdata[rdata_idx])
				rdata_idx = rdata_idx + 1

			else
				stack = ItemStack (name)

				if utils.is_value_item (stack:get_name ()) or
					utils.is_action_value_item (stack:get_name ()) or
					utils.is_condition_value_item (stack:get_name ()) then

					stack:get_meta ():set_string ("value", rdata[rdata_idx])
					stack:get_meta ():set_string ("description", rdata[rdata_idx])
					rdata_idx = rdata_idx + 1
				end
			end

			inv:set_stack ("program", i, stack)
		end
	end
end



--
