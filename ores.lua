core.register_node("travail:desert_stone_with_mithril", {
	description = "Mithril Ore",
	tiles = {"default_desert_stone.png^travail_mineral_mithril.png"},
	is_ground_content = true,
	groups = {crumbly = 1, cracky = 3},
	drop = {
		items = {
			{items = {"default:desert_cobble"}},
			{items = {"travail:mithril_lump"}},
			{items = {"maptools:copper_coin 4"}, rarity = 25},
		},
	},
	sounds = default.node_sound_stone_defaults(),
})

core.register_node("travail:mithril_block", {
	description = "Mithril Block",
	tiles = {"travail_mithril_block.png"},
	is_ground_content = true,
	groups = {cracky = 1, level = 2, ingot_block = 1},
	sounds = default.node_sound_stone_defaults(),
})

core.register_craftitem("travail:mithril_lump", {
	description = "Mithril Lump",
	wield_scale = {x = 1, y = 1, z = 2},
	inventory_image = "travail_mithril_lump.png",
	groups = {ingot_lump = 1},
})

core.register_craftitem("travail:mithril_ingot", {
	description = "Mithril Ingot",
	wield_scale = {x = 1, y = 1, z = 2},
	inventory_image = "travail_mithril_ingot.png",
	groups = {ingot = 1},
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "travail:desert_stone_with_mithril",
	wherein        = "default:desert_stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 3,
	clust_size     = 2,
	y_min     = -31000,
	y_max     = -12,
	flags          = "absheight",
})

core.register_tool("travail:pick_mithril", {
	description = "Mithril Pickaxe",
	inventory_image = "travail_tool_mithrilpick.png",
	tool_capabilities = {
		full_punch_interval = 0.75,
		max_drop_level = 2,
		groupcaps = {
			cracky = {times = {[1] = 2.25, [2] = 0.55, [3] = 0.35}, uses = 13, maxlevel = 3},
			crumbly = {times = {[1] = 1.8, [2] = 0.8, [3] = 0.3}, uses = 13, maxlevel = 2},
		},
		damage_groups = {fleshy = 9},
	},
})

core.register_tool("travail:shovel_mithril", {
	description = "Mithril Shovel",
	inventory_image = "travail_tool_mithrilshovel.png",
	tool_capabilities = {
		full_punch_interval = 0.75,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1] = 1, [2] = 0.35, [3] = 0.20}, uses = 13, maxlevel = 2},
		},
		damage_groups = {fleshy = 4},
	},
})

core.register_tool("travail:axe_mithril", {
	description = "Mithril Axe",
	inventory_image = "travail_tool_mithrilaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.75,
		max_drop_level = 1,
		groupcaps = {
			choppy = {times = {[1] = 1.75, [2] = 0.65, [3] = 0.45}, uses = 13, maxlevel = 2},
			snappy = {times = {[2] = 0.95, [3] = 0.30}, uses = 13, maxlevel = 2}
		},
		damage_groups = {fleshy = 6},
	},
})

core.register_tool("travail:sword_mithril", {
	description = "Mithril Sword",
	inventory_image = "travail_tool_mithrilsword.png",
	tool_capabilities = {
		full_punch_interval = 0.75,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times = {[2] = 0.95, [3] = 0.30}, uses = 13, maxlevel = 2}
		},
		damage_groups = {fleshy = 9},
	},
})

farming.register_hoe("travail:hoe_mithril", {
	description = "Mithril Hoe",
	inventory_image = "travail_tool_mithrilhoe.png",
	max_uses = 150,
	recipe = {
		{"travail:mithril_ingot", "travail:mithril_ingot"},
		{"", "group:stick"},
		{"", "group:stick"},
	}
})

core.register_craft({
	output = "travail:pick_mithril",
	recipe = {
		{"travail:mithril_ingot", "travail:mithril_ingot", "travail:mithril_ingot"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

core.register_craft({
	output = "travail:shovel_mithril",
	recipe = {
		{"travail:mithril_ingot"},
		{"group:stick"},
		{"group:stick"},
	}
})

core.register_craft({
	output = "travail:axe_mithril",
	recipe = {
		{"travail:mithril_ingot", "travail:mithril_ingot"},
		{"travail:mithril_ingot", "group:stick"},
		{"", "group:stick"},
	}
})

core.register_craft({
	output = "travail:sword_mithril",
	recipe = {
		{"travail:mithril_ingot"},
		{"travail:mithril_ingot"},
		{"group:stick"},
	}
})

core.register_craft({
	output = "travail:mithril_block",
	recipe = {
		{"travail:mithril_ingot", "travail:mithril_ingot", "travail:mithril_ingot"},
		{"travail:mithril_ingot", "travail:mithril_ingot", "travail:mithril_ingot"},
		{"travail:mithril_ingot", "travail:mithril_ingot", "travail:mithril_ingot"},
	}
})

core.register_craft({
	output = "travail:mithril_ingot 9",
	recipe = {{"travail:mithril_block"},}
})

core.register_craft({
	type = "cooking", output = "travail:mithril_ingot", recipe = "travail:mithril_lump",
})

core.register_node("travail:mithril_steel_brick", {
	description = "Mithril Steel Brick",
	tiles = {"travail_mithril_steel_brick.png"},
	is_ground_content = true,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

core.register_craft({
	output = "travail:mithril_steel_brick 4",
	recipe = {
		{"travail:mithril_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "travail:mithril_ingot"},
	}
})

core.register_craft({
	output = "travail:mithril_steel_brick 4",
	recipe = {
		{"default:steel_ingot", "travail:mithril_ingot"},
		{"travail:mithril_ingot", "default:steel_ingot"},
	}
})

core.register_alias("moreores:desert_stone_with_mithril", "travail:desert_stone_with_mithril")
core.register_alias("moreores:mithril_lump", "travail:mithril_lump")
core.register_alias("moreores:mithril_ingot", "travail:mithril_ingot")

core.register_alias("moreores:axe_mithril", "travail:axe_mithril")
core.register_alias("moreores:shovel_mithril", "travail:shovel_mithril")
core.register_alias("moreores:pick_mithril", "travail:pick_mithril")
core.register_alias("moreores:hoe_mithril", "travail:hoe_mithril")
core.register_alias("moreores:sword_mithril", "travail:sword_mithril")

travail.add_stairs_and_fence({"mithril_block", "mithril_steel_brick"})
