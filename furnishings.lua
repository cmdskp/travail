minetest.register_node("travail:ladder_steel", {
	description = "Steel Ladder",
	drawtype = "nodebox",
	tiles = {"travail_ladder_steel.png"},
	inventory_image = "travail_ladder_steel_inv.png",
	wield_image = "travail_ladder_steel_inv.png",
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "wallmounted",
	climbable = true,
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.375, 0.4375, -0.5, 0.375, 0.5, 0.5},
		wall_bottom = {-0.375, -0.5, -0.5, 0.375, -0.4375, 0.5},
		wall_side   = {-0.5, -0.5, -0.375, -0.4375, 0.5, 0.375},
	},
	selection_box = {type = "wallmounted"},
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("travail:ladder_obsidian", {
	description = "Obsidian Ladder",
	drawtype = "nodebox",
	tiles = {"travail_ladder_obsidian.png"},
	inventory_image = "travail_ladder_obsidian_inv.png",
	wield_image = "travail_ladder_obsidian_inv.png",
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "wallmounted",
	climbable = true,
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.375, 0.4375, -0.5, 0.375, 0.5, 0.5},
		wall_bottom = {-0.375, -0.5, -0.5, 0.375, -0.4375, 0.5},
		wall_side   = {-0.5, -0.5, -0.375, -0.4375, 0.5, 0.375},
	},
	selection_box = {type = "wallmounted"},
	groups = {cracky = 1, level=3},
	sounds = default.node_sound_stone_defaults(),
})

if core.get_modpath("doors") then
	doors.register_door("travail:door_stone", {
		description = "Stone Door",
		inventory_image = "travail_doors_stone.png",
		groups = {cracky=1,level=1,door=1},
		tiles_bottom = {"travail_doors_stone_b.png", "travail_doors_stone_side.png"},
		tiles_top = {"travail_doors_stone_a.png", "travail_doors_stone_side.png"},
		only_placer_can_open = false,
		sound_gain = 0.75,
		sound_close_door = "stone_door_open_close",
		sound_open_door = "stone_door_open_close",
		sounds = default.node_sound_stone_defaults(),
		sunlight = false,
	})

	doors.register_door("travail:door_obsidian", {
		description = "Obsidian Door",
		inventory_image = "travail_doors_obsidian.png",
		groups = {cracky=1,level=3,door=1},
		sound_gain = 0.4,
		tiles_bottom = {"travail_doors_obsidian_b.png", "travail_doors_obsidian_side.png"},
		tiles_top = {"travail_doors_obsidian_a.png", "travail_doors_obsidian_side.png"},
		only_placer_can_open = true,
		sound_close_door = "stone_door_open_close",
		sound_open_door = "stone_door_open_close",
		sounds = default.node_sound_stone_defaults(),
		sunlight = false,
	})

	core.register_craft({
		output = "travail:door_obsidian 3",
		recipe = {
			{"default:obsidian", "default:obsidian"},
			{"default:obsidian", "default:obsidian"},
			{"default:obsidian", "default:obsidian"}
		}
	})

	doors.register_trapdoor("travail:trapdoor_obsidian", {
		description = "Obsidian Trapdoor",
		inventory_image = "travail_trapdoor_obsidian.png",
		wield_image = "travail_trapdoor_obsidian.png",
		tile_front = "travail_trapdoor_obsidian.png",
		tile_side = "travail_trapdoor_obsidian_side.png",
		only_placer_can_open = true,
		groups = {cracky=1, level=3, door=1},
		sound_gain = 0.4,
		sound_close_door = "stone_door_open_close",
		sound_open_door = "stone_door_open_close",
		sounds = default.node_sound_stone_defaults(),
		sound_open = "doors_door_open",
		sound_close = "doors_door_close"
	})

	core.register_craft({
		output = 'travail:trapdoor_obsidian 6',
		recipe = {
			{'default:obsidian', 'default:obsidian', 'default:obsidian'},
			{'default:obsidian', 'default:obsidian', 'default:obsidian'},
			{'', '', ''},
		}
	})
--[[
	doors.register_door("travail:door_ice", {
		description = "Ice Door",
		inventory_image = "travail_doors_ice.png",
		paramtype = "light",
		groups = {cracky=3,door=1},
		tiles_bottom = {"travail_doors_ice_b.png", "travail_doors_ice_side.png"},
		tiles_top = {"travail_doors_ice_a.png", "travail_doors_ice_side.png"},
		only_placer_can_open = true,
		sounds = default.node_sound_glass_defaults(),
		sunlight = true,
		use_texture_alpha = true,
	})
	core.register_craft({
		output = "travail:door_ice 3",
		recipe = {
			{"default:ice", "default:ice"},
			{"default:ice", "default:ice"},
			{"default:ice", "default:ice"}
		}
	})

	doors.register_trapdoor("travail:trapdoor_ice", {
		description = "Ice Trapdoor",
		inventory_image = "travail_trapdoor_ice.png",
		wield_image = "travail_trapdoor_ice.png",
		tile_front = "travail_trapdoor_ice.png",
		tile_side = "travail_trapdoor_ice_side.png",
		only_placer_can_open = true,
		paramtype = "light",
		groups = {cracky=3, door=1},
		sounds = default.node_sound_stone_defaults(),
		sound_open = "doors_door_open",
		sound_close = "doors_door_close",
		sunlight = true,
		use_texture_alpha = true,
	})

	core.register_craft({
		output = 'travail:trapdoor_ice 6',
		recipe = {
			{'default:ice', 'default:ice', 'default:ice'},
			{'default:ice', 'default:ice', 'default:ice'},
			{'', '', ''},
		}
	})
--]]
end

core.register_node("travail:fence_obsidian", {
	description = "Obsidian Fence",
	drawtype = "fencelike",
	tiles = {"default_obsidian.png"},
	inventory_image = "travail_obsidian_fence.png",
	wield_image = "travail_obsidian_fence.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky=1, level=3},
	sounds = default.node_sound_stone_defaults(),
})

core.register_craft({
	output = "travail:fence_obsidian 16",
	recipe = {
		{"default:obsidian", "default:obsidian", "default:obsidian"},
		{"default:obsidian", "", "default:obsidian"},
	}
})

core.register_node("travail:fence_ice", {
	description = "Ice Fence",
	drawtype = "fencelike",
	tiles = {"default_ice.png"},
	use_texture_alpha = true,
	inventory_image = "travail_ice_fence.png",
	wield_image = "travail_ice_fence.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky=3, slip=100},
	sounds = default.node_sound_glass_defaults(),
})

core.register_craft({
	output = "travail:fence_ice 16",
	recipe = {
		{"default:ice", "default:ice", "default:ice"},
		{"default:ice", "", "default:ice"},
	}
})

core.register_node("travail:fence_snow_brick", {
	description = "Snow Brick Fence",
	drawtype = "fencelike",
	tiles = {"snow_snow_brick.png"},
	inventory_image = "travail_snow_brick_fence.png",
	wield_image = "travail_snow_brick_fence.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky=2, slip=50},
	sounds = default.node_sound_stone_defaults(),
})

core.register_craft({
	output = "travail:fence_snow_brick 16",
	recipe = {
		{"snow:snow_brick", "snow:snow_brick", "snow:snow_brick"},
		{"snow:snow_brick", "", "snow:snow_brick"},
	}
})

core.register_node("travail:fence_cactus_brick", {
	description = "Cactus Brick Fence",
	drawtype = "fencelike",
	tiles = {"moreblocks_cactus_brick.png"},
	inventory_image = "travail_cactus_brick_fence.png",
	wield_image = "travail_cactus_brick_fence.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky=3, slip=50},
	sounds = default.node_sound_stone_defaults(),
})

core.register_craft({
	output = "travail:fence_cactus_brick 16",
	recipe = {
		{"moreblocks:cactus_brick", "moreblocks:cactus_brick", "moreblocks:cactus_brick"},
		{"moreblocks:cactus_brick", "", "moreblocks:cactus_brick"},
	}
})

core.register_node("travail:fence_bronze_block", {
	description = "Bronze Block Fence",
	drawtype = "fencelike",
	tiles = {"default_bronze_block.png"},
	inventory_image = "travail_bronze_block_fence.png",
	wield_image = "travail_bronze_block_fence.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky=1, level=2, slip=30},
	sounds = default.node_sound_metal_defaults(),
})

core.register_craft({
	output = "travail:fence_bronze_block 16",
	recipe = {
		{"default:bronze_block", "default:bronze_block", "default:bronze_block"},
		{"default:bronze_block", "default:bronze_block", "default:bronze_block"},
	}
})

core.register_node("travail:fence_gold_block", {
	description = "Gold Block Fence",
	drawtype = "fencelike",
	tiles = {"default_gold_block.png"},
	inventory_image = "travail_gold_block_fence.png",
	wield_image = "travail_gold_block_fence.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky=1, slip=30},
	sounds = default.node_sound_metal_defaults(),
})

core.register_craft({
	output = "travail:fence_gold_block 16",
	recipe = {
		{"default:goldblock", "default:goldblock", "default:goldblock"},
		{"default:goldblock", "default:goldblock", "default:goldblock"},
	}
})

core.register_node("travail:fence_diamond_block", {
	description = "Diamond Block Fence",
	drawtype = "fencelike",
	tiles = {"default_diamond_block.png"},
	inventory_image = "travail_diamond_block_fence.png",
	wield_image = "travail_diamond_block_fence.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {cracky=1, level=3, slip=70},
	sounds = default.node_sound_metal_defaults(),
})

core.register_craft({
	output = "travail:fence_diamond_block 16",
	recipe = {
		{"default:diamond_block", "default:diamond_block", "default:diamond_block"},
		{"default:diamond_block", "default:diamond_block", "default:diamond_block"},
	}
})

core.register_node("travail:stained_glass", {
	description = "Stained Glass",
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = true,
	tiles = {"homedecor_stained_glass.png"},
	inventory_image = core.inventorycube("travail_stained_glass_inventory.png"),
	use_texture_alpha = true,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},
	light_source = 3,
	groups = {snappy = 3},
	sounds = default.node_sound_glass_defaults(),
})

core.register_craft({
	type = "shapeless",
	output = "travail:stained_glass",
	recipe = {"dye:blue", "dye:red", "dye:green", "dye:yellow", "default:glass"},
})

travail.add_stairs({"stained_glass"})

minetest.register_node("travail:wood_glass", {
	description = "Glass",
	drawtype = "allfaces",
	paramtype = "light",
	tiles = {"travail_wood_glass.png"},
	inventory_image = minetest.inventorycube("travail_wood_glass.png"),
	use_texture_alpha = true,
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky=3},
	sounds = default.node_sound_glass_defaults(),
})

core.register_craft({
	type = "shapeless",
	output = "travail:wood_glass",
	recipe = {"default:wood", "default:glass"},
})

travail.add_stairs({"wood_glass"})
