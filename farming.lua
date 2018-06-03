core.register_node("travail:soil_wet_mineral_water", {
	description = "Wet Soil",
	tiles = {"default_dirt.png^travail_soil_wet_mineral_water.png", "default_dirt.png^travail_soil_wet_mineral_water_side.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet_mineral_water"
	},
	soil_water_type = "mineral_water"
})

core.register_node("travail:soil_wet_blood_water", {
	description = "Wet Soil",
	tiles = {"default_dirt.png^travail_soil_wet_blood_water.png", "default_dirt.png^travail_soil_wet_blood_water_side.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet_blood_water"
	},
	soil_water_type = "blood_water"
})

core.register_node("travail:soil_wet_sulphur_water", {
	description = "Wet Soil",
	tiles = {"default_dirt.png^travail_soil_wet_sulphur_water.png", "default_dirt.png^travail_soil_wet_sulphur_water_side.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet_sulphur_water"
	},
	soil_water_type = "sulphur_water"
})


farming.register_plant("travail:carrot", {
	description = "Carrot seed",
	inventory_image = "travail_carrot_seed.png",
	steps = 5,
	minlight = 12,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
	on_use = core.item_eat(2),
})

core.register_alias("farming:carrot", "travail:carrot")
for i=1,5 do
	core.register_alias("farming:carrot_"..i, "travail:carrot_"..i)
end

core.register_abm{
	nodenames = {"default:desert_sand"},
	neighbors = {"air"},
	interval = 150,
	chance = 25000,
	action = function(a_position)
		if a_position.y>30 then
			a_position.y = a_position.y + 1
			local temp_node = core.get_node_or_nil(a_position)
			if temp_node and temp_node.name=="air" then
				local temp_light = core.get_node_light(a_position)
				if temp_light>=13 then
					minetest.set_node(a_position, {name = "travail:carrot_1"})
				end
			end
		end
	end,
}