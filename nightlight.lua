minetest.register_craft({
	output = 'travail:nightlight 1',
	recipe = {
		{'default:glass', 'default:mese','default:glass'},
		{'default:mese', 'default:glass', 'default:mese'},
		{'default:glass', 'default:mese','default:glass'},
	}
})

local function switch_night_sensor(a_position, a_player_name, a_message)
	local temp_timer = core.get_node_timer(a_position)
	if temp_timer:get_timeout()==0 then
		temp_timer:start(20)
	else
		temp_timer:stop()
	end
	core.chat_send_player(a_player_name, "-- You switch "..a_message.." the night sensor.")
end

minetest.register_node("travail:nightlight", {
	description = "Night Light",
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {-.375, -.375, -.375, .375, .375, .375}},
	tiles = {"travail_nightlight.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	on_construct = function(a_position)
		core.get_node_timer(a_position):start(20)
	end,
	on_rightclick = function(a_position, a_node, a_clicker, a_itemstack, a_pointed_thing)
		local temp_player_name = a_clicker:get_player_name()
		if not core.is_protected(a_position, temp_player_name) then
			core.swap_node(a_position, {name = "travail:nightlight_on", param2 = a_node.param2})
			switch_night_sensor(a_position, temp_player_name, "on")
		end
	end,
	on_timer = function(a_position, a_elapsed)
		local temp_time = core.get_timeofday()
		if temp_time<0.24 or temp_time>0.76 then
			local temp_node = core.get_node(a_position)
			core.swap_node(a_position, {name = "travail:nightlight_on", param2 = temp_node.param2})
		end
		return true
	end,
})

minetest.register_node("travail:nightlight_on", {
	description = "Night Light On",
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {-.375, -.375, -.375, .375, .375, .375}},
	tiles = {"travail_nightlight_on.png"},
	paramtype = "light",
	light_source = 14,
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
	sounds = default.node_sound_glass_defaults(),
	drop = "travail:nightlight",
	on_rightclick = function(a_position, a_node, a_clicker, a_itemstack, a_pointed_thing)
		local temp_player_name = a_clicker:get_player_name()
		if not core.is_protected(a_position, temp_player_name) then
			core.swap_node(a_position, {name = "travail:nightlight", param2 = a_node.param2})
			switch_night_sensor(a_position, temp_player_name, "off")
		end
	end,
	on_timer = function(a_position, a_elapsed)
		local temp_time = core.get_timeofday()
		if temp_time>=0.24 and temp_time<=0.76 then
			local temp_node = core.get_node(a_position)
			core.swap_node(a_position, {name = "travail:nightlight", param2 = temp_node.param2})
		end
		return true
	end,
})
