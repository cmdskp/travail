local get_node = core.get_node

minetest.register_abm({
	nodenames = {"default:water_source"},
	neighbors = {"air"},
	interval = 77,
	chance = 1000,
	catch_up = false,
	action = function(a_position)
		if not core.is_protected(a_position, "") then
			local temp_x = a_position.x
			local temp_z = a_position.z
			a_position.x = a_position.x - 1
			if get_node(a_position).name~="default:water_flowing" then
				a_position.x = a_position.x + 2
				if get_node(a_position).name~="default:water_flowing" then
					a_position.x = a_position.x - 1
					a_position.z = a_position.z - 1
					if get_node(a_position).name~="default:water_flowing" then
						a_position.z = a_position.z + 2
						if get_node(a_position).name~="default:water_flowing" then
							return
						end
					end
				end
			end
			a_position.x = temp_x
			a_position.z = temp_z
			minetest.remove_node(a_position)
			nodeupdate(a_position)
		end
	end,
})

if LICHEN then
core.register_node("travail:lichen", {
	description = "Lichen",
	drawtype = "allfaces_optional",
	tiles = {"travail_lichen.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})

local lichen_blocks = {["default:stone"] = 1, ["default:cobble"] = 2, ["default:sandstone"] = 3, ["default:desert_stone"] = 4, ["default:desert_cobble"] = 5}
local erosion_blocks = {"default:dirt", "default:dirt", "default:sand", "default:desert_sand", "default:desert_sand"}

for temp_block_name, temp_index in pairs(lichen_blocks) do
	local temp_name = string.sub(temp_block_name, 9)
	local temp_node_def = core.registered_nodes[temp_block_name]
	local temp_erosion_block = erosion_blocks[temp_index]
	local temp_to_type = (temp_index>2) and "sand" or "dirt"

	core.register_node("travail:"..temp_name.."_eroded", {
		description = "Eroding "..string.gsub(temp_name, "_", " ").." to "..temp_to_type,
		tiles = {temp_node_def.tiles[1].."^travail_erosion_"..temp_to_type..".png"},
		is_ground_content = true,
		drop = temp_erosion_block,
		groups = {cracky = 3, stone = 1, falling_node = 1},
		sounds = default.node_sound_dirt_defaults(),
	})
end

core.register_node("travail:stone_with_lichen", {
	description = "Lichen on stone",
	tiles = {"default_stone.png^travail_lichen.png"},
	is_ground_content = true,
	drop = "travail:lichen",
	groups = {cracky = 3, stone = 1, falling_node = 1},
	sounds = default.node_sound_dirt_defaults(),
})

local function get_random_about(a_position, a_random_value)
	local temp_offset = {x=0, y=0, z=0}
	local temp_direction = a_random_value % 4
	if temp_direction==0 then
		temp_offset.x = -1
	elseif temp_direction==1 then
		temp_offset.x = 1
	elseif temp_direction==2 then
		temp_offset.z = -1
	else
		temp_offset.z = 1
	end
	return vector.add(a_position, temp_offset)
end

minetest.register_abm({
	nodenames = {"travail:blood_water_source"},
	neighbours = {"default:stone"},
	interval = 5,
	chance = 2,
	catch_up = false,
	action = function(a_position)
		local temp_random = math.random(60000)
		local temp_touching = get_random_about(a_position, temp_random)
		local temp_name =  get_node(temp_touching).name
		if temp_name=="default:stone" then
			core.set_node(temp_touching, {name="travail:stone_with_lichen"})
		end
	end,
})

local function check_lichen_spread(a_position)
	local temp_y = a_position.y
	local temp_name = get_node(a_position).name
	if lichen_blocks[temp_name] then
		a_position.y = temp_y
		core.set_node(a_position, {name="travail"..string.sub(temp_name, 8).."_eroded"})

		a_position.y = temp_y + 1
		local temp_above_name = get_node(a_position).name
		if temp_above_name=="air" then
			core.set_node(a_position, {name="travail:lichen"})
		end
	elseif temp_name=="air" then
		a_position.y = temp_y - 1
		local temp_below_name = get_node(a_position).name
		if lichen_blocks[temp_below_name] then
			core.set_node(a_position, {name="travail"..string.sub(temp_below_name, 8).."_eroded"})
			a_position.y = temp_y
			core.set_node(a_position, {name="travail:lichen"})
		end
	end
	a_position.y = temp_y
end

minetest.register_abm({
	nodenames = {"travail:lichen"},
	neighbors = {"air"},
	interval = 7,
	chance = 2,
	catch_up = false,
	action = function(a_position)
		a_position.x = a_position.x - 1
		check_lichen_spread(a_position)

		a_position.x = a_position.x + 2
		check_lichen_spread(a_position)

		a_position.x = a_position.x - 1
		a_position.z = a_position.z - 1
		check_lichen_spread(a_position)

		a_position.z = a_position.z + 2
		check_lichen_spread(a_position)
		a_position.z = a_position.z - 1
		
		local temp_life = 20
		local temp_meta = core.get_meta(a_position)
		if temp_meta then
			temp_life = temp_meta:get_int("life")
			if temp_life==0 then
				temp_life = 20
			end
			temp_life = temp_life - 1
		end
		core.remove_node(a_position)
		if temp_life>0 then
			a_position.y = a_position.y + 1
			local temp_name = get_node(a_position).name
			if temp_name=="air" then
				core.set_node(a_position, {name="travail:lichen"})
				core.get_meta(a_position):set_int("life", temp_life)
			elseif lichen_blocks[temp_name] then
				core.set_node(a_position, {name="travail"..string.sub(temp_name, 8).."_eroded"})
			else
--				nodeupdate(a_position)
			end
		else
--			nodeupdate(a_position)
		end
	end,
})

local function set_eroded(a_node_name, a_position)
	local temp_eroded
	if string.find(a_node_name, "desert", 9, true) then
		temp_eroded = "default:desert_sand"
	elseif string.find(a_node_name, "sand", 9, true) then
		temp_eroded = "default:sand"
	else
		temp_eroded = "default:dirt"
	end
	core.set_node(a_position, {name=temp_eroded})
end

local random_direction = { {0, -1}, {0, 1}, {1, 0}, {-1, 0} }
minetest.register_abm({
	nodenames = {"travail:stone_eroded", "travail:cobble_eroded", "travail:sandstone_eroded", "travail:desert_stone_eroded", "travail:desert_cobble_eroded"},
	interval = 3,
	chance = 3,
	catch_up = false,
	action = function(a_position, a_node)
		local temp_y = a_position.y
		a_position.y = a_position.y - 1
		local temp_name = get_node(a_position).name
		if temp_name=="air" or string.find(temp_name, "_eroded", 1, true) then
			a_position.y = temp_y + 1
			temp_name = get_node(a_position).name
			if temp_name~="air" then
				a_position.y = temp_y
				local temp_object = core.add_entity(a_position, "__builtin:falling_node")
				temp_object:get_luaentity():set_node(a_node)
			end

			local temp_x = a_position.x
			local temp_z = a_position.z
			local temp_remaining = 4
			while temp_remaining>0 do
				local temp_choice = math.random(temp_remaining)
				local temp_direction = random_direction[temp_choice]
				a_position.x = temp_x + temp_direction[1]
				a_position.y = temp_y
				a_position.z = temp_z + temp_direction[2]
				local temp_name = get_node(a_position).name 
				if temp_choice<temp_remaining then
					random_direction[temp_choice] = random_direction[temp_remaining]
					random_direction[temp_remaining] = temp_direction
				end
				temp_remaining = temp_remaining - 1
				if lichen_blocks[temp_name] then
					a_position.y = temp_y + 1
					if get_node(a_position).name=="air" then
						a_position.y = temp_y
						core.set_node(a_position, {name="travail"..string.sub(temp_name, 8).."_eroded"})
					end
				end
			end
			a_position.x = temp_x
			a_position.y = temp_y + 1
			a_position.z = temp_z
		else
			local temp_x = a_position.x
			local temp_z = a_position.z
			local temp_remaining = 4
			while temp_remaining>0 do
				local temp_choice = math.random(temp_remaining)
				local temp_direction = random_direction[temp_choice]
				a_position.x = temp_x + temp_direction[1]
				a_position.y = temp_y
				a_position.z = temp_z + temp_direction[2]
				if temp_choice<temp_remaining then
					random_direction[temp_choice] = random_direction[temp_remaining]
					random_direction[temp_remaining] = temp_direction
				end
				temp_remaining = temp_remaining - 1
				if get_node(a_position).name=="air" then
					a_position.y = temp_y + 1
					if get_node(a_position).name=="air" then
						a_position.y = temp_y
						core.set_node(a_position, {name=a_node.name})
--						nodeupdate_single(a_position)
					end
				end
			end
			a_position.x = temp_x
			a_position.y = temp_y
			a_position.z = temp_z
			set_eroded(a_node.name, a_position)

			a_position.y = temp_y - 1
		end
		local temp_name = get_node(a_position).name
		if lichen_blocks[temp_name] then
			core.after(0.1, function(a_position)
				local temp_name = get_node(a_position).name
				if lichen_blocks[temp_name] then
					core.set_node(a_position, {name="travail"..string.sub(temp_name, 8).."_eroded"})
				end
			end, a_position);
		end
	end,
})
end