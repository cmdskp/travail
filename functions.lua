function travail.add_stairs(a_block_list)
	for i=1, #a_block_list do
		local temp_name = a_block_list[i]
		local temp_capitalised = temp_name:sub(1,1):upper()..temp_name:sub(2)
		local temp_def = core.registered_nodes["travail:"..temp_name]
		local temp_groups = temp_def.groups
		if stairsplus then
			if stairsplus.register_all then
				stairsplus:register_all("travail", temp_name, "travail:"..temp_name, {
						description=temp_def.description,
						tiles = temp_def.tiles,
						use_texture_alpha = temp_def.use_texture_alpha,
						light_source = temp_def.light_source,
						groups = temp_groups,
						is_ground_content = true,
						sounds = default.node_sound_stone_defaults()
				})
			elseif stairsplus.register_stair_and_slab_and_panel_and_micro then
				stairsplus.register_stair_and_slab_and_panel_and_micro("travail", temp_name, "travail:"..temp_name,
						temp_groups,
						temp_def.tiles,
						temp_name.." Stairs",
						temp_name.." Corner",
						temp_name.." Slab",
						temp_name.." Wall",
						temp_name.." Panel",
						temp_name.." Microblock",
						temp_def.description,
						default.node_sound_stone_defaults()
				)
			end
		elseif stairs then
			stairs:register_stair_and_slab("travail_"..temp_name, "travail:"..temp_name,
					temp_groups,
					temp_def.tiles,
					temp_def.description.." stair",
					temp_def.description.." slab",
					default.node_sound_stone_defaults()
			)
		end
	end
end

function travail.add_stairs_and_fence(a_block_list)
	travail.add_stairs(a_block_list)

	for i=1, #a_block_list do
		local temp_name = a_block_list[i]
		local temp_def = core.registered_nodes["travail:"..temp_name]

		core.register_node("travail:fence_"..temp_name, {
			description = temp_def.description.." Fence",
			drawtype = "fencelike",
			tiles = temp_def.tiles,
			inventory_image = "travail_"..temp_name.."_fence.png",
			wield_image = "travail_"..temp_name.."_fence.png",
			paramtype = "light",
			sunlight_propagates = true,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
			},
			groups = temp_def.groups,
			sounds = temp_def.sounds,
		})

		local temp_material = "travail:"..temp_name
		core.register_craft({
			output = "travail:fence_"..temp_name.." 16",
			recipe = {
				{temp_material, temp_material, temp_material},
				{temp_material, temp_material, temp_material},
			}
		})

	end
end