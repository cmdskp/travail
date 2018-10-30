core.register_node("travail:stone_with_dirt", {
	description = "Stone with Dirt",
	tiles = {"default_dirt.png", "default_stone.png",
		{name = "default_stone.png^travail_dirt_side.png",
			tileable_vertical = false}},
	groups = {crumbly=3,soil=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
})

core.register_node("travail:sulphur", {
	description = "Sulphur",
	tiles = {"travail_sulphur.png"},
	is_ground_content = true,
	groups = {crumbly=2, stone=3},
	sounds = default.node_sound_stone_defaults(),
})

core.register_node("travail:blue_flame", {
	description = "Fire",
	drawtype = "plantlike",
	tiles = {{
		name="travail_blue_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "travail_blue_flame.png",
	light_source = 14,
	groups = {igniter=2,dig_immediate=3},
	drop = '',
	walkable = false,
	damage_per_second = 7,
	
	after_place_node = function(pos, placer)
		fire.on_flame_add_at(pos)
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		fire.on_flame_remove_at(pos)
	end,
})

core.register_abm({
	nodenames = {"travail:sulphur"},
	neighbors = {"group:igniter"},
	interval = 5,
	chance = 30,
	action = function(a_position, a_node, _, _)
		a_position.y = a_position.y + 1
		local temp_name = core.get_node(a_position)
		if temp_name=="air" then
			core.env:set_node(a_position, {name="travail:blue_flame"})
			fire.on_flame_add_at(a_position)
		else
			a_position.y = a_position.y - 1
			core.env:set_node(a_position, {name="travail:blue_flame"})
			fire.on_flame_add_at(a_position)
		end
	end,
})

core.register_node("travail:mud", {
	description = "Mud",
	tiles = {"travail_mud.png"},
	is_ground_content = true,
	groups = {crumbly=1, oddly_breakable_by_hand=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
})

core.register_node("travail:dry_mud", {
	description = "Dry Mud",
	tiles = {"travail_dry_mud.png"},
	is_ground_content = true,
	groups = {crumbly=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "travail:dry_mud",
	wherein        = "default:dirt",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 64,
	clust_size     = 5,
	y_max     = 64,
	y_min     = -4096,
})

core.register_node("travail:mineral_water_flowing", {
	description = "Flowing Mineral Water",
	inventory_image = core.inventorycube("travail_mineral_water.png"),
	drawtype = "flowingliquid",
	tiles = {"travail_mineral_water.png"},
	special_tiles = {
		{
			image = "travail_mineral_water_flowing_animated.png",
			backface_culling=false,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
		{
			image = "travail_mineral_water_flowing_animated.png",
			backface_culling=true,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "travail:mineral_water_flowing",
	liquid_alternative_source = "travail:mineral_water_source",
	liquid_viscosity = WATER_VISC,
	auto_heal = 1,
	post_effect_color = {a = 120, r = 30, g = 90, b = 50},
	groups = {water = 3, liquid = 3, puts_out_fire = 1, not_in_creative_inventory = 1},
})

core.register_node("travail:mineral_water_source", {
	description = "Mineral Water Source",
	inventory_image = core.inventorycube("travail_mineral_water.png"),
	drawtype = "liquid",
	tiles = {
		{name = "travail_mineral_water_source_animated.png", animation={type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.5}}
	},
	special_tiles = {
		-- New-style mineral water source material (mostly unused)
		{
			name = "travail_mineral_water_source_animated.png",
			animation = {type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 1.5},
			backface_culling = false,
		}
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "travail:mineral_water_flowing",
	liquid_alternative_source = "travail:mineral_water_source",
	liquid_viscosity = WATER_VISC,
	auto_heal = 1,
	post_effect_color = {a = 120, r = 30, g = 90, b = 50},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
	water_type = "mineral_water",
})


core.register_node("travail:sulphur_water_flowing", {
	description = "Flowing Sulphur Water",
	inventory_image = core.inventorycube("travail_sulphur_water.png"),
	drawtype = "flowingliquid",
	tiles = {"travail_sulphur_water.png"},
	special_tiles = {
		{
			image = "travail_sulphur_water_flowing_animated.png",
			backface_culling=false,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
		{
			image = "travail_sulphur_water_flowing_animated.png",
			backface_culling=true,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 3,
	liquidtype = "flowing",
	liquid_alternative_flowing = "travail:sulphur_water_flowing",
	liquid_alternative_source = "travail:sulphur_water_source",
	liquid_viscosity = WATER_VISC,
	damage_hunger = 1,
	post_effect_color = {a = 120, r = 30, g = 90, b = 50},
	groups = {liquid = 3, puts_out_fire = 1, not_in_creative_inventory = 1},
})

core.register_node("travail:sulphur_water_source", {
	description = "Sulphur Water Source",
	inventory_image = core.inventorycube("travail_sulphur_water.png"),
	drawtype = "liquid",
	tiles = {
		{name = "travail_sulphur_water_source_animated.png", animation={type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.5}}
	},
	special_tiles = {
		-- New-style sulphur water source material (mostly unused)
		{
			name = "travail_sulphur_water_source_animated.png",
			animation = {type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 1.5},
			backface_culling = false,
		}
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	liquidtype = "source",
	liquid_alternative_flowing = "travail:sulphur_water_flowing",
	liquid_alternative_source = "travail:sulphur_water_source",
	liquid_viscosity = WATER_VISC,
	drowning = 3,
	damage_hunger = 1,
	post_effect_color = {a = 120, r = 30, g = 90, b = 50},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
	water_type = "sulphur_water",
})

core.register_abm({
	nodenames = {"travail:sulphur_water_flowing", "travail:sulphur_water_source"},
	neighbors = {"default:lava_source", "default:lava_flowing"},
	interval = 4,
	chance = 1,
	action = function(a_position, a_node, active_object_count, active_object_count_wider)
		a_position.y = a_position.y + 1
		local temp_name =  core.get_node(a_position).name
		if temp_name=="default:lava_source" then
			core.set_node(a_position, {name = "travail:dry_mud"})
			a_position.y = a_position.y -  1
		core.set_node(a_position, {name = "travail:sulphur"})
		core.sound_play("sulphur_sizzle", {pos = a_position, gain = 0.2})
		else
			a_position.y = a_position.y -  1
			core.set_node(a_position, {name = "travail:dry_mud"})
		end
	end,
})

core.register_node("travail:blood_water_flowing", {
	description = "Flowing Blood Water",
	inventory_image = core.inventorycube("travail_blood_water.png"),
	drawtype = "flowingliquid",
	tiles = {"travail_blood_water.png"},
	special_tiles = {
		{
			image = "travail_blood_water_flowing_animated.png",
			backface_culling=false,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
		{
			image = "travail_blood_water_flowing_animated.png",
			backface_culling=true,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	liquidtype = "flowing",
	liquid_alternative_flowing = "travail:blood_water_flowing",
	liquid_alternative_source = "travail:blood_water_source",
	liquid_viscosity = 2,
	drowning = 2,
	post_effect_color = {a = 120, r = 90, g = 40, b = 30},
	groups = {water = 3, liquid = 3, puts_out_fire = 1, not_in_creative_inventory = 1},
})

core.register_node("travail:blood_water_source", {
	description = "Blood Water Source",
	inventory_image = core.inventorycube("travail_blood_water.png"),
	drawtype = "liquid",
	tiles = {
		{name = "travail_blood_water_source_animated.png", animation={type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.5}}
	},
	special_tiles = {
		-- New-style source material (mostly unused)
		{
			name = "travail_blood_water_source_animated.png",
			animation = {type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 1.5},
			backface_culling = false,
		}
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	liquidtype = "source",
	liquid_alternative_flowing = "travail:blood_water_flowing",
	liquid_alternative_source = "travail:blood_water_source",
	liquid_viscosity = 2,
	drowning = 2,
	post_effect_color = {a = 120, r = 90, g = 40, b = 30},
	groups = {water = 3, liquid = 3, puts_out_fire = 1},
	water_type = "blood_water",
})

if bucket then
	core.register_alias("bucket_blood_water", "magma:bucket_blood_water")

	bucket.register_liquid(
		"travail:blood_water_source",
		"travail:blood_water_flowing",
		"travail:bucket_blood_water",
		"travail_bucket_blood_water.png",
		"Blood Water Bucket"
	)

	core.register_alias("bucket_mineral_water", "magma:bucket_mineral_water")

	bucket.register_liquid(
		"travail:mineral_water_source",
		"travail:mineral_water_flowing",
		"travail:bucket_mineral_water",
		"travail_bucket_mineral_water.png",
		"Mineral Water Bucket"
	)

	core.register_alias("bucket_sulphur_water", "magma:bucket_sulphur_water")

	bucket.register_liquid(
		"travail:sulphur_water_source",
		"travail:sulphur_water_flowing",
		"travail:bucket_sulphur_water",
		"travail_bucket_sulphur_water.png",
		"Sulphur Water Bucket"
	)
	
	bucket.register_liquid(
		"travail:muddy_water_source",
		"travail:muddy_water_flowing",
		"travail:bucket_muddy_water",
		"travail_bucket_muddy_water.png",
		"Muddy Water Bucket"
	)
	
	bucket.register_liquid(
		"default:acid_source",
		"default:acid_flowing",
		"travail:glass_bottle_acid",
		"travail_glass_bottle_acid.png",
		"Acid Vessel"
	)
	
	bucket.register_liquid(
		"default:water_source",
		"default:water_flowing",
		"travail:glass_bottle_water",
		"travail_glass_bottle_water.png",
		"Water Vessel"
	)
	
	bucket.register_liquid(
		"default:lava_source",
		"default:lava_flowing",
		"travail:glass_bottle_lava",
		"travail_glass_bottle_lava.png",
		"Lava Vessel"
	)
	
	bucket.register_liquid(
		"travail:blood_water_source",
		"travail:blood_water_flowing",
		"travail:glass_bottle_blood_water",
		"travail_glass_bottle_blood_water.png",
		"Blood Water Vessel"
	)
	
	bucket.register_liquid(
		"travail:muddy_water_source",
		"travail:muddy_water_flowing",
		"travail:glass_bottle_muddy_water",
		"travail_glass_bottle_muddy_water.png",
		"Muddy Water Vessel"
	)
	
	bucket.register_liquid(
		"travail:sulphur_water_source",
		"travail:sulphur_water_flowing",
		"travail:glass_bottle_sulphur_water",
		"travail_glass_bottle_sulphur_water.png",
		"Sulphur Water Vessel"
	)
	
	bucket.register_liquid(
		"travail:mineral_water_source",
		"travail:mineral_water_flowing",
		"travail:glass_bottle_mineral_water",
		"travail_glass_bottle_mineral_water.png",
		"Mineral Water Vessel"
	)
end

core.register_node("travail:muddy_water_flowing", {
	description = "Flowing Muddy Water",
	inventory_image = core.inventorycube("travail_muddy_water.png"),
	drawtype = "flowingliquid",
	tiles = {"travail_muddy_water.png"},
	special_tiles = {
		{
			image = "travail_muddy_water_flowing_animated.png",
			backface_culling=false,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
		{
			image = "travail_muddy_water_flowing_animated.png",
			backface_culling=true,
			animation={type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 0.6}
		},
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	liquidtype = "flowing",
	liquid_alternative_flowing = "travail:muddy_water_flowing",
	liquid_alternative_source = "travail:muddy_water_source",
	liquid_viscosity = 2,
	drowning = 2,
	post_effect_color = {a = 120, r = 90, g = 40, b = 30},
	groups = {liquid = 3, puts_out_fire = 1, not_in_creative_inventory = 1},
})

core.register_node("travail:muddy_water_source", {
	description = "Muddy Water Source",
	inventory_image = core.inventorycube("travail_muddy_water.png"),
	drawtype = "liquid",
	tiles = {
		{name = "travail_muddy_water_source_animated.png", animation={type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.5}}
	},
	special_tiles = {
		-- New-style source material (mostly unused)
		{
			name = "travail_muddy_water_source_animated.png",
			animation = {type = "vertical_frames", aspect_w= 16, aspect_h = 16, length = 1.5},
			backface_culling = false,
		}
	},
	alpha = WATER_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	liquidtype = "source",
	liquid_alternative_flowing = "travail:muddy_water_flowing",
	liquid_alternative_source = "travail:muddy_water_source",
	liquid_viscosity = 2,
	drowning = 2,
	post_effect_color = {a = 120, r = 50, g = 30, b = 10},
	groups = {liquid = 3, puts_out_fire = 1},
	water_type = "muddy_water",
})


core.register_ore({
	ore_type       = "scatter",
	ore            = "travail:blood_water_source",
	wherein        = "default:stone_with_iron",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 64,
	clust_size     = 5,
	y_min     = -30000,
	y_max     = 64,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "travail:sulphur_water_source",
	wherein        = "default:lava_source",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 64,
	clust_size     = 5,
	y_min     = -30000,
	y_max     = 64,
})

local function get_random_touching(a_position, a_random_value)
	local temp_offset = {x=0, y=0, z=0}
	local temp_direction = a_random_value % 6
	if temp_direction==0 then
		temp_offset.y = -1
	elseif temp_direction==1 then
		temp_offset.x = -1
	elseif temp_direction==2 then
		temp_offset.x = 1
	elseif temp_direction==3 then
		temp_offset.z = -1
	elseif temp_direction==4 then
		temp_offset.z = 1
	else
		temp_offset.y = 1
	end
	return vector.add(a_position, temp_offset)
end

core.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"air"},
	interval = 15,
	chance = 200,
	catch_up = false,
	action = function(a_position)
		local temp_level =  core.get_node(a_position).param2
		if temp_level<2 then
			core.set_node(a_position, {name="magma:basalt"})
		end
	end,
})

core.register_abm({
	nodenames = {"travail:blood_water_flowing"},
	neighbors = {"default:stone"},
	interval = 15,
	chance = 200,
	catch_up = false,
	action = function(a_position)
		a_position.y = a_position.y - 1
		local temp_name =  core.get_node(a_position).name
		if temp_name=="default:stone" then
			core.set_node(a_position, {name="travail:stone_with_dirt"})
		end
	end,
})

core.register_abm({
	nodenames = {"default:dirt"},
	neighbors = {"group:water"},
	interval = 15,
	chance = 2,
	catch_up = false,
	action = function(a_position)
		core.set_node(a_position, {name="travail:mud"})
	end,
})

core.register_abm({
	nodenames = {"default:dirt"},
	neighbors = {"travail:sulphur_water_source", "travail:sulphur_water_flowing"},
	interval = 15,
	chance = 2,
	catch_up = false,
	action = function(a_position)
		core.set_node(a_position, {name="travail:mud"})
	end,
})

core.register_abm({
	nodenames = {"default:water_flowing"},
	neighbors = {"travail:mud"},
	interval = 10,
	chance = 5,
	catch_up = false,
	action = function(a_position)
		a_position.y = a_position.y - 1
		if core.get_node(a_position).name~="default:water_source" then
			a_position.y = a_position.y + 1
			a_position.x = a_position.x + 1
			if core.get_node(a_position).name~="default:water_source" then
				a_position.x = a_position.x - 2
				if core.get_node(a_position).name~="default:water_source" then
					a_position.x = a_position.x + 1
					a_position.z = a_position.z + 1
					if core.get_node(a_position).name~="default:water_source" then
						a_position.z = a_position.z - 2
						if core.get_node(a_position).name~="default:water_source" then
							return
						end
					end
				end
			end
		end
		core.place_node(a_position, {name="travail:muddy_water_source"})
	end,
})

core.register_abm({
	nodenames = {"default:water_flowing"},
	neighbors = {"travail:muddy_water_source"},
	interval = 5,
	chance = 1,
	catch_up = false,
	action = function(a_position)
		core.swap_node(a_position, {name="travail:muddy_water_flowing"})
	end,
})

core.register_abm({
	nodenames = {"travail:muddy_water_source"},
	neighbors = {"default:water_source"},
	interval = 2,
	chance = 1,
	catch_up = false,
	action = function(a_position)
		a_position = get_random_touching(a_position, math.random(7))
		local temp_name = core.get_node(a_position).name
		if temp_name=="default:water_source" then
			if core.find_node_near(a_position, 2, {"travail:mud"}) then
				core.swap_node(a_position, {name="travail:muddy_water_source"})
			end
		end
	end,
})

core.register_abm({
	nodenames = {"travail:dry_mud"},
	neighbors = {"group:liquid"},
	interval = 15,
	chance = 20,
	catch_up = false,
	action = function(a_position)
		core.set_node(a_position, {name="travail:mud"})
	end,
})

core.register_abm({
	nodenames = {"travail:mud"},
	interval = 15,
	chance = 20,
	catch_up = false,
	action = function(a_position)
		if not core.find_node_near(a_position, 1, {"group:liquid"}) then
			core.set_node(a_position, {name="travail:dry_mud"})
		end
	end,
})

core.register_abm({
	nodenames = {"travail:stone_with_dirt"},
	interval = 17,
	chance = 200,
	catch_up = false,
	action = function(a_position)
		core.set_node(a_position, {name="default:dirt"})
	end,
})

travail.time = 0
core.register_globalstep(function(dtime)
	travail.time = travail.time + dtime
	if travail.time>5 then
		local temp_players = core.get_connected_players()
		for _, temp_player in ipairs(temp_players) do
			local temp_position = temp_player:getpos()
			local temp_node_name = core.get_node(temp_position).name
			local temp_node = core.registered_nodes[temp_node_name]
			if temp_node.damage_hunger and hud then
				local temp_name = temp_player:get_player_name()
				local temp_hunger = tonumber(hud.hunger[temp_name])
				if temp_hunger>1 then
					temp_hunger = temp_hunger - temp_node.damage_hunger
					if temp_hunger<=1 then
						temp_hunger = 1
					end
				end
				hud.hunger[temp_name] = temp_hunger
				hud.set_hunger(temp_player)
			end
			if temp_node.auto_heal then
				local temp_health = temp_player:get_hp()
				if temp_node.auto_heal<0 or temp_health<14 then
					temp_player:set_hp(temp_health + temp_node.auto_heal)
				end
			end
			temp_position.y = temp_position.y - 1
			local temp_node_name = core.get_node(temp_position).name
			local temp_node = core.registered_nodes[temp_node_name]
			if temp_node.standing_damage then
				local temp_health = temp_player:get_hp()
				temp_player:set_hp(temp_health - temp_node.standing_damage)
			end
		end
		travail.time = travail.time - 5
	end
end)
