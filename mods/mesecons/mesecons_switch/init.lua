-- mesecons_switch

mesecon.register_node("mesecons_switch:mesecon_switch", {
	paramtype2="facedir",
	description="Switch\n" .. "Used to turn logic circuits on and off.",
	is_ground_content = false,
	on_rightclick = function (pos, node)
		if(mesecon.flipstate(pos, node) == "on") then
        mesecon.receptor_on(pos)
		else
        mesecon.receptor_off(pos)
		end
		minetest.sound_play("mesecons_switch", { pos = pos }, true)
	end
},{
	groups = {dig_immediate=2},
	tiles = {"switch.png"},
  drawtype = 'mesh',
  mesh = "switch_off.obj",
  inventory_image = "switch_inv.png",
	mesecons = {receptor = { state = mesecon.state.off }}
},{
	groups = {dig_immediate=2},
	tiles = {"switch.png"},
  drawtype = 'mesh',
  mesh = "switch_on.obj",
  inventory_image = "switch_inv.png",
	mesecons = {receptor = { state = mesecon.state.on }}
})
