minetest.register_craft({
	output = 'travail:beacon 1',
	recipe = {
		{'default:glass'},
		{'default:torch'},
		{'default:stick'},
	}
})

minetest.register_node("travail:beacon", {
	description = "Beacon",
	drawtype = "glasslike",
	tiles = {"travail_nightlight.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	on_rightclick = function(a_position, a_node, a_clicker, a_itemstack, a_pointed_thing)
		local temp_player_name = a_clicker:get_player_name()
		if temp_player_name then
			local temp_meta = minetest.get_meta(a_position)
			local temp_id = temp_meta:get_int("id_"..temp_player_name)
			if temp_id then
				local temp_player = core.get_player_by_name(temp_player_name)
				if temp_player then
					temp_player:hud_remove(temp_id)
				end
			end
		end
	end,
})

