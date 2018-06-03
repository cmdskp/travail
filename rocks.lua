local GRANITE_COLOURS = {"pink", "orange", "yellow", "cream", "green"}

for i=1, #GRANITE_COLOURS do
	local temp_colour = GRANITE_COLOURS[i]
	core.register_node("travail:"..temp_colour.."_granite", {
		description = "Granite, "..temp_colour,
		tiles = {"travail_"..temp_colour.."_granite.png"},
		is_ground_content = true,
		groups = {cracky=1, level=2},
		sounds = default.node_sound_stone_defaults()
	})
	core.register_node("travail:"..temp_colour.."_granite_cobble", {
		description = "Granite cobble, "..temp_colour,
		tiles = {"travail_"..temp_colour.."_granite_cobble.png"},
		is_ground_content = true,
		groups = {cracky=2, level=2},
		sounds = default.node_sound_stone_defaults()
	})
end
