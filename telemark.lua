local function get_forced_node_name(a_position)
	local temp_voxel_manipulator = core.get_voxel_manip()
	local temp_min, temp_max = temp_voxel_manipulator:read_from_map(a_position, a_position)
	local temp_area = VoxelArea:new{
		MinEdge = temp_min,
		MaxEdge = temp_max,
		}
	local temp_data = temp_voxel_manipulator:get_data()
	local temp_voxel_index = temp_area:indexp(a_position)
	return core.get_name_from_content_id(temp_data[temp_voxel_index])
end

local function get_node_name(a_position)
	local result = core.get_node(a_position).name
	if result == "ignore" then
		result = get_forced_node_name(a_position)
	end
	return result
end

local function get_distance_cost(a_link_position, a_position)
	local temp_delta_x = a_link_position.x - a_position.x
	local temp_delta_y = a_link_position.y - a_position.y
	local temp_delta_z = a_link_position.z - a_position.z
	local temp_distance = math.sqrt(temp_delta_x*temp_delta_x + temp_delta_y*temp_delta_y + temp_delta_z*temp_delta_z)
	return math.ceil(temp_distance / 2000)
end

core.register_craft({
	output = 'travail:telemark 1',
	recipe = {
		{'moreblocks:trap_glass', 'maptools:silver_coin','moreblocks:trap_glass'},
		{'maptools:silver_coin', 'default:mese_block', 'maptools:silver_coin'},
		{'moreblocks:trap_stone', 'maptools:silver_coin','moreblocks:trap_stone'},
	}
})

core.register_craft({
	output = 'travail:telelink 1',
	recipe = {
		{'default:paper', 'default:mese_crystal','default:paper'},
		{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
		{'default:paper', 'default:mese_crystal','default:paper'},
	}
})
--[[
core.register_entity("travail:teleport", {
	visual = "mesh",
	visual_size = {x=1, y=1},
	mesh = "travail_teleport.x",
	textures = {"travail_teleport.png"},
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	automatic_rotate = true,
})
--]]

core.register_node("travail:telemark", {
	description = "Teleport marker - use a Telelink on two to connect.",
	drawtype = "glasslike",
	tiles = {"travail_telemark.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_glass_defaults(),
	on_rightclick = function(a_position, a_node, a_puncher, a_itemstack, a_pointed_thing)
		local temp_meta = core.get_meta(a_position):get_string("link")
		if temp_meta~="" then
			local temp_link_position = core.string_to_pos(temp_meta)
			a_position.y = a_position.y + 1
			local temp_cost = get_distance_cost(temp_link_position, a_position)
			local temp_count = a_itemstack:get_count()
			if temp_count>=temp_cost then
				a_itemstack:take_item(temp_cost)
				local temp_player_position = a_puncher:getpos()
--				local temp_source_teleport = core.add_entity(temp_player_position, "travail:teleport")
				local temp_dest_position = core.string_to_pos(temp_meta)
--				local temp_dest_teleport = core.add_entity(temp_dest_position, "travail:teleport")
--				core.after(2, function(a_puncher, a_dest_position, a_source_teleport)
--					a_source_teleport:remove()
					a_puncher:setpos(temp_dest_position)
--				end, a_puncher, temp_dest_position, temp_source_teleport)
--				core.after(5, function(a_dest_teleport)
--					a_dest_teleport:remove()
--				end, temp_dest_teleport)
			else
				local temp_user_name = a_puncher:get_player_name()
				core.chat_send_player(temp_user_name, "* THIS TELEPORT NEEDS "..temp_cost.." SILVER COINS!")
			end
		end
	end,
})

core.register_craftitem('travail:telelink', {
	description = "Links two separate Telemark blocks for teleport.",
	inventory_image = "travail_telelink.png",
	stack_max = 1,
	on_place = function()
		return nil
	end,
	on_use = function(a_itemstack, a_user, a_pointed_thing)
		local temp_position = a_pointed_thing.under
		local temp_under = get_node_name(temp_position)
		local temp_telemark_meta = core.get_meta(temp_position)
		local temp_user_name = a_user:get_player_name()

		temp_position.y = temp_position.y + 1

		if temp_under=="travail:telemark" then
			if minetest.is_protected(a_position, temp_user_name)==false then
				local temp_meta_link = a_itemstack:get_metadata()
				if temp_meta_link=="" then
					a_itemstack:set_metadata(core.pos_to_string(temp_position))
					core.chat_send_player(temp_user_name, "* Stored position "..core.pos_to_string(temp_position).." in Telelink *")
					return a_itemstack
				else
					if core.pos_to_string(temp_position) ~= temp_meta_link then
						temp_telemark_meta:set_string("link", temp_meta_link)

						local temp_link_position = core.string_to_pos(temp_meta_link)
						local temp_cost = get_distance_cost(temp_link_position, temp_position)
						temp_telemark_meta:set_string("infotext", "Teleports to: "..temp_meta_link.." - Silver coin cost "..temp_cost)
						core.chat_send_player(temp_user_name, "* Set teleports to: "..temp_meta_link)
					else
						core.chat_send_player(temp_user_name, "* SOURCE TELEPORT BLOCK!  Use on a different one *")
						return a_itemstack
					end
				end
			else
				core.chat_send_player(temp_user_name, "* PROTECTED AREA!")
				return a_itemstack
			end
		end
		a_itemstack:take_item()
		return a_itemstack
	end,
})