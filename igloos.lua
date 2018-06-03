-- Negative moves down a line after moving across that amount positive
-- Every alternate switches block building from off to on
local building_plan = {
	igloo1 = {
		{ -5, -5, -5, -4, -3, 1, 1},
		{ -5, -5, -4, -4, -3, 0, -3 },
		{ -5, -5, -4, 3, -1, 2, -2, 0, 2 },
		{ 4, -1, 4, -1, 4, -1, 2, -2, 0, -3 },
		{ 3, -1, 3, -1, 2, -2, 0, 3 },
		{ 1, -2, 1, -2, 0, 2 },
	},
	igloo2 = {
		{ -1, -1, -1, -1, -1, -1, -1 },
		{ -6, -6, -5, -4, -3, -2, 0, 2},
		{ -6, -6, -5, -4, -3, 1, -2, 0, 2 },
		{ -5, -5, -5, 3, -1, 2, -2, 0, 3 },
		{ 4, -1, 4, -1, 4, -1, 3, -2, 0, -4, 0, 2 },
		{ 3, -2, 3, -2, 2, -2, 0, -3, 0, 2 },
		{ 1, -2, 1, -2, 0, 2 },
	},
}

local orient_x = {  0, 1, 0, -1  }
local orient_z = {  -1, 0, 1, 0  }

function travail.place_plan(a_building_plan, a_pos, a_orientation, a_material, a_flip)
	local temp_orient_x = orient_x[a_orientation]
	local temp_orient_z = orient_z[a_orientation]
	local temp_direction_x = temp_orient_z
	local temp_direction_z = temp_orient_x
	if a_flip then
		temp_orient_x = -temp_orient_x
		temp_orient_z = -temp_orient_z
	end

	local temp_material = {name = a_material}
	local temp_origin = {x=math.floor(a_pos.x), y=math.floor(a_pos.y), z=math.floor(a_pos.z)}
	local temp_pos = {x=temp_origin.x, y=temp_origin.y, z=temp_origin.z}
	for temp_slice_index=1, #a_building_plan do
		local temp_slice = a_building_plan[temp_slice_index]
		local temp_switch = 0
		for i=1, #temp_slice do
			local temp_amount = temp_slice[i]
			local temp_is_nextline = (temp_amount<0)
			if temp_is_nextline then
				temp_amount = -temp_amount
			end
			if temp_switch==1 then
				while temp_amount>0 do
					core.set_node(temp_pos, temp_material)
					temp_pos.x = temp_pos.x + temp_orient_x
					temp_pos.z = temp_pos.z + temp_orient_z
					temp_amount = temp_amount - 1
				end
				temp_switch = 0
			else
				while temp_amount>0 do
					core.remove_node(temp_pos)
					temp_pos.x = temp_pos.x + temp_orient_x
					temp_pos.z = temp_pos.z + temp_orient_z
					temp_amount = temp_amount - 1
				end
				temp_switch = 1
			end
			if temp_is_nextline then
				temp_pos.x = temp_origin.x
				temp_pos.y = temp_pos.y + 1
				temp_pos.z = temp_origin.z
				temp_switch = 0
			end
		end
		temp_origin.x = temp_origin.x + temp_direction_x
		temp_origin.z = temp_origin.z + temp_direction_z
		temp_pos.x = temp_origin.x
		temp_pos.y = temp_origin.y
		temp_pos.z = temp_origin.z
	end
end

function travail.place_igloo(a_building_plan, a_pos, a_material)
	for temp_orient = 1, 4 do
		travail.place_plan(a_building_plan, a_pos, temp_orient, a_material)
		travail.place_plan(a_building_plan, a_pos, temp_orient, a_material, true)
	end
end

local choices = { 1, 2, 3, 4 }

function travail.generate_maze()
	local result_maze = {
		{-1,-1,-1,-1,-1,-1,-1},
		{-1,0,0,0,0,0,-1},
		{-1,0,0,0,0,0,-1},
		{-1,0,0,0,0,0,-1},
		{-1,0,0,0,0,0,-1},
		{-1,0,0,0,0,0,-1},
		{-1,-1,-1,-1,-1,-1,-1}
	}
	local result_entry_orient = nil
	local temp_node_match = 0
	local temp_remaining_nodes = 5*5 - math.random(5)
	local temp_remaining = 4
	repeat
		local temp_place
		local temp_x = math.random(5) + 1
		local temp_z = math.random(5) + 1
		if temp_remaining~=0 or result_maze[temp_z][temp_x]~=0 then
			repeat
				local temp_direction, temp_dir_x, temp_dir_z, temp_choice
				temp_remaining = 4
				repeat
					temp_choice = math.random(temp_remaining)
					temp_direction = choices[temp_choice]
					temp_dir_x = orient_x[temp_direction]
					temp_dir_z = orient_z[temp_direction]

					choices[temp_choice] = choices[temp_remaining]
					choices[temp_remaining] = temp_direction
					temp_remaining = temp_remaining - 1
					if temp_remaining==0 then
						break
					end
					temp_place = result_maze[temp_z+temp_dir_z][temp_x+temp_dir_x]
				until temp_place==0
				if temp_remaining>0 then
					if not result_entry_orient then
						result_entry_orient = temp_direction
					end
					local temp_passage_bit = bit.lshift(1, temp_direction-1)
					result_maze[temp_z][temp_x] = bit.bor(result_maze[temp_z][temp_x], temp_passage_bit)
					temp_remaining_nodes = temp_remaining_nodes - 1
					temp_x = temp_x + temp_dir_x
					temp_z = temp_z + temp_dir_z
				end
			until temp_remaining==0 or temp_remaining_nodes==0
		end
	until temp_remaining_nodes==0
	print(dump(result_maze))
	return result_maze, result_entry_orient
end

function travail.connect_igloo(a_position, a_orient_x, a_orient_z, a_length, a_material, a_filler_material, a_U_shaped)
	local temp_wall = {name = a_material}
	local temp_filler = {name = a_filler_material or "air"}
	for temp_tunnel = 1, a_length do
		core.set_node(a_position, temp_filler)
		a_position.y = a_position.y + 1
		core.set_node(a_position, temp_filler)

		a_position.y = a_position.y - 2
		core.set_node(a_position, temp_wall)

		a_position.y = a_position.y + 1
		a_position.x = a_position.x - a_orient_z
		a_position.z = a_position.z - a_orient_x

		core.set_node(a_position, temp_wall)
		a_position.y = a_position.y + 1
		core.set_node(a_position, temp_wall)

		a_position.y = a_position.y + 1
		if a_U_shaped then
			core.set_node(a_position, temp_wall)
		end

		a_position.x = a_position.x + a_orient_z
		a_position.z = a_position.z + a_orient_x
		core.set_node(a_position, temp_wall)

		a_position.x = a_position.x + a_orient_z
		a_position.z = a_position.z + a_orient_x
		if a_U_shaped then
			core.set_node(a_position, temp_wall)
		end

		a_position.y = a_position.y - 1
		core.set_node(a_position, temp_wall)
		a_position.y = a_position.y - 1
		core.set_node(a_position, temp_wall)

		a_position.x = a_position.x + a_orient_x - a_orient_z
		a_position.z = a_position.z + a_orient_z - a_orient_x
	end
end

function travail.pipe(a_position, a_height, a_material)
	local temp_position = {x=0, y=a_position.y, z=0}
	for i=1, a_height do
		for z=-1, 1 do
			for x=-1, 1 do
				temp_position.x = a_position.x + x
				temp_position.z = a_position.z + z
				if z~=0 or x~=0 then
					core.set_node(temp_position, {name=a_material})
				else
					core.remove_node(temp_position)
				end
			end
		end
		temp_position.y = temp_position.y + 1
	end
end

function travail.place_base(a_position, a_size, a_material, a_corner, a_corner_material)
	local temp_position = {x=0, y=a_position.y, z=0}
	for z=-a_size, a_size do
		temp_position.z = a_position.z + z

		local temp_size = a_size
		if a_corner==1 and (z==-a_size or z==a_size) then
			if a_corner_material then
				temp_position.x = a_position.x - a_size
				core.set_node(temp_position, {name=a_corner_material})
				temp_position.x = a_position.x + a_size
				core.set_node(temp_position, {name=a_corner_material})
			end
			temp_size = temp_size - a_corner
		end
		for x=-temp_size, temp_size do
			temp_position.x = a_position.x + x
			core.set_node(temp_position, {name=a_material})
		end
	end
end

function travail.place_wall(a_position, a_width, a_height, a_direction, a_material, a_corner, a_corner_material)
	local temp_position = {x=0, y=a_position.y, z=0}
	for y=1, a_height do
		local temp_size = a_width
		if a_corner==1 and (y==1 or y==a_height) then
			if a_corner_material then
				local temp_mount = (y==a_height) and 20 or 0
				temp_position.x = a_position.x - a_width*orient_z[a_direction]
				temp_position.z = a_position.z - a_width*orient_x[a_direction]
				core.set_node(temp_position, {name=a_corner_material, param2=temp_mount})
				temp_position.x = a_position.x + a_width*orient_z[a_direction]
				temp_position.z = a_position.z + a_width*orient_x[a_direction]
				core.set_node(temp_position, {name=a_corner_material, param2=temp_mount})
			end
			temp_size = temp_size - a_corner
		end
		for x=-temp_size, temp_size do
			temp_position.x = a_position.x + x*orient_z[a_direction]
			temp_position.z = a_position.z + x*orient_x[a_direction]
			core.set_node(temp_position, {name=a_material})
		end
		temp_position.y = temp_position.y + 1
	end
end

function travail.place_stair_tunnel(a_position, a_height, a_direction, a_material, a_stair)
	local temp_position = {x=a_position.x, y=a_position.y, z=a_position.z}
	local temp_down_stair = (5-a_direction) % 4
	local temp_top_down_stair = 20 + ((a_direction+1) % 4)
	local temp_left_stair = ((a_direction+2) % 4)
	local temp_top_left_stair = 20 + ((6-a_direction) % 4)
	local temp_right_stair = (a_direction % 4)
	local temp_top_right_stair = 20 + ((4-a_direction) % 4)
	local temp_fill = "air"
	for y=1, a_height do
		temp_position.x = a_position.x + (y-1)*orient_x[a_direction]
		temp_position.y = temp_position.y - 1
		temp_position.z = a_position.z + (y-1)*orient_z[a_direction]
		core.set_node(temp_position, {name=a_stair, param2=temp_down_stair})
		for i=1, 3 do
			temp_position.y = temp_position.y + 1
			core.set_node(temp_position, {name=temp_fill})
		end
		temp_position.y = temp_position.y + 1
		core.set_node(temp_position, {name=a_stair, param2=temp_top_down_stair})
		if y>1 then
			temp_position.y = temp_position.y + 1
			core.set_node(temp_position, {name=a_material})
			temp_position.y = temp_position.y - 1
		end

		temp_position.x = temp_position.x + orient_z[a_direction]
		temp_position.z = temp_position.z + orient_x[a_direction]
		if y>1 then
			temp_position.y = temp_position.y + 1
			core.set_node(temp_position, {name=a_material})
			temp_position.y = temp_position.y - 1
		end
		temp_position.y = temp_position.y - 3
		core.set_node(temp_position, {name=a_stair, param2=temp_left_stair})
		temp_position.y = temp_position.y - 1
		core.set_node(temp_position, {name=a_material})
		temp_position.y = temp_position.y + 2
		core.set_node(temp_position, {name=temp_fill})
		temp_position.y = temp_position.y + 1
		core.set_node(temp_position, {name=temp_fill})
		temp_position.y = temp_position.y + 1
		core.set_node(temp_position, {name=a_stair, param2=temp_top_left_stair})

		temp_position.x = temp_position.x + orient_z[a_direction]
		temp_position.z = temp_position.z + orient_x[a_direction]
		temp_position.y = temp_position.y - 1
		core.set_node(temp_position, {name=a_material})
		temp_position.y = temp_position.y - 1
		core.set_node(temp_position, {name=a_material})

		temp_position.x = temp_position.x - orient_z[a_direction]*4
		temp_position.z = temp_position.z - orient_x[a_direction]*4
		core.set_node(temp_position, {name=a_material})
		temp_position.y = temp_position.y + 1
		core.set_node(temp_position, {name=a_material})
		temp_position.y = temp_position.y + 1
		temp_position.x = temp_position.x + orient_z[a_direction]
		temp_position.z = temp_position.z + orient_x[a_direction]
		if y>1 then
			temp_position.y = temp_position.y + 1
			core.set_node(temp_position, {name=a_material})
			temp_position.y = temp_position.y - 1
		end
		core.set_node(temp_position, {name=a_stair, param2=temp_top_right_stair})
		temp_position.y = temp_position.y - 1
		core.set_node(temp_position, {name=temp_fill})
		temp_position.y = temp_position.y - 1
		core.set_node(temp_position, {name=temp_fill})
		temp_position.y = temp_position.y - 1
		core.set_node(temp_position, {name=a_stair, param2=temp_right_stair})
		temp_position.y = temp_position.y - 1
		core.set_node(temp_position, {name=a_material})
	end
	return temp_position
end

function travail.generate_igloo_complex(temp_pos, temp_material, temp_window_material, temp_floor_material, temp_tunnel_material, temp_corner_materal)
	travail.place_igloo(building_plan.igloo2, temp_pos, temp_material)
	temp_pos.y = temp_pos.y - 1
	travail.place_base(temp_pos, 5, temp_floor_material, 1)
	temp_pos.y = temp_pos.y + 1
	if math.random(4)==1 then
		travail.pipe(temp_pos, 1, temp_material)
		temp_pos.y = temp_pos.y + 7
		travail.pipe(temp_pos, 3, temp_material)
		temp_pos.y = temp_pos.y - 7
	end
	local temp_has_door = false
	local temp_has_stairs = false
	for temp_spoke = 1, 4 do
		local temp_orient_x = orient_x[temp_spoke]
		local temp_orient_z = orient_z[temp_spoke]

		if math.random(2)==1 then
			local temp_exit_pos = {x=temp_pos.x+temp_orient_x*6, y=temp_pos.y, z=temp_pos.z+temp_orient_z*6}
			travail.connect_igloo(temp_exit_pos, temp_orient_x, temp_orient_z, 6, temp_material, math.random(10)==1 and "default:ice" or "air")

			local temp_sub_pos = {x=temp_pos.x+temp_orient_x*16, y=temp_pos.y, z=temp_pos.z+temp_orient_z*16}
			travail.place_igloo(building_plan.igloo1, temp_sub_pos, temp_material)
			temp_sub_pos.y = temp_sub_pos.y - 1
			travail.place_base(temp_sub_pos, 4, temp_floor_material, 1)
			temp_sub_pos.y = temp_sub_pos.y + 1
			if math.random(5)==1 then
				travail.pipe(temp_sub_pos, 1, temp_material)
				temp_sub_pos.y = temp_sub_pos.y + 6
				travail.pipe(temp_sub_pos, 3, temp_material)
				temp_sub_pos.y = temp_sub_pos.y - 6
			end
			for temp_outer_face = 1, 4 do
				temp_orient_x = orient_x[temp_outer_face]
				temp_orient_z = orient_z[temp_outer_face]
				if temp_outer_face~=1+((temp_spoke+1) % 4) then
					if not temp_has_door and math.random(4)==1 then
						local temp_exit_pos = {x=temp_sub_pos.x+temp_orient_x*5, y=temp_sub_pos.y, z=temp_sub_pos.z+temp_orient_z*5}
						travail.connect_igloo(temp_exit_pos, temp_orient_x, temp_orient_z, 3, temp_material, math.random(10)==1 and "default:ice" or "air", true)
						temp_has_door = true
					else
						local temp_exit_pos = {x=temp_sub_pos.x+temp_orient_x*5, y=temp_sub_pos.y, z=temp_sub_pos.z+temp_orient_z*5}
						core.set_node(temp_exit_pos, {name=temp_material})
						temp_exit_pos.y = temp_exit_pos.y + 1
						if math.random(3)==1 then
							core.set_node(temp_exit_pos, {name=temp_material})
						else
							core.set_node(temp_exit_pos, {name=temp_window_material})
						end
					end
				end
			end
		else
			if not temp_has_door and (math.random(4)==1 or temp_spoke==4) then
				local temp_exit_pos = {x=temp_pos.x+temp_orient_x*6, y=temp_pos.y, z=temp_pos.z+temp_orient_z*6}
				travail.connect_igloo(temp_exit_pos, temp_orient_x, temp_orient_z, 3, temp_material, math.random(10)==1 and "default:ice" or "air", true)
				temp_has_door = true
			elseif not temp_has_stairs and (math.random(4)==1 or ((temp_spoke==3 and not temp_has_door) or temp_spoke==4)) then
				local temp_maze, temp_entry_orient = travail.generate_maze()
				local temp_exit_pos = {x=temp_pos.x+orient_z[temp_entry_orient]*-2, y=temp_pos.y, z=temp_pos.z+orient_x[temp_entry_orient]*-2}
				temp_exit_pos = travail.place_stair_tunnel(temp_exit_pos, 10, temp_spoke, temp_material, "moreblocks:stair_snowblock")
				temp_exit_pos.x = temp_exit_pos.x - orient_x[temp_entry_orient]
				temp_exit_pos.y = temp_exit_pos.y + 1
				temp_exit_pos.z = temp_exit_pos.z - orient_z[temp_entry_orient]
				local temp_scale = 10
				travail.generate_maze_structures(temp_exit_pos, temp_maze, temp_scale, temp_material, temp_window_material, temp_floor_material, temp_tunnel_material, temp_corner_materal)
				temp_has_stairs = true
			else
				local temp_exit_pos = {x=temp_pos.x+temp_orient_x*6, y=temp_pos.y, z=temp_pos.z+temp_orient_z*6}
				core.set_node(temp_exit_pos, {name=temp_material})
				temp_exit_pos.y = temp_exit_pos.y + 1
				if math.random(3)==1 then
					core.set_node(temp_exit_pos, {name=temp_material})
				else
					core.set_node(temp_exit_pos, {name=temp_window_material})
				end
			end
		end
	end
end

function travail.generate_maze_structures(temp_pos, temp_maze, temp_scale, temp_material, temp_window_material, temp_floor_material, temp_tunnel_material, temp_corner_material)
	for z = 2, 6 do
		for x = 2, 6 do
			local temp_bits = temp_maze[z][x]
			if temp_bits>0 then
				local pos = {x=temp_pos.x+(x-4)*temp_scale, y=temp_pos.y-1, z=temp_pos.z+(z-4)*temp_scale}
				travail.place_base(pos, 1, temp_material, 0)
				pos.y = pos.y + 1
				travail.place_base(pos, 1, temp_tunnel_material, 1, temp_material)
				pos.y = pos.y + 1
				travail.place_base(pos, 1, temp_tunnel_material, 1, temp_material)
				pos.y = pos.y + 1
				travail.place_base(pos, 1, temp_material, 0)
				pos.y = pos.y + 1
				travail.place_base(pos, 1, temp_material, 0)
				for dir=1, 4 do
					pos = {x=temp_pos.x+(x-4)*temp_scale, y=temp_pos.y, z=temp_pos.z+(z-4)*temp_scale}
					pos.x = pos.x + orient_x[dir]
					pos.z = pos.z + orient_z[dir]
					if bit.band(temp_bits, bit.lshift(1, dir-1))~=0 then
						for i=4, temp_scale do
							pos.x = pos.x + orient_x[dir] - orient_z[dir] * 2
							pos.z = pos.z + orient_z[dir] - orient_x[dir] * 2
							pos.y = pos.y - 1
							core.set_node(pos, {name = temp_floor_material})
							pos.y = pos.y + 1
							for y=1, 3 do
								core.set_node(pos, {name=temp_material})
								pos.y = pos.y + 1
							end
							for a=1, 3 do
								pos.x = pos.x + orient_z[dir]
								pos.z = pos.z + orient_x[dir]
								core.set_node(pos, {name=temp_material})
							end
							pos.x = pos.x + orient_z[dir]
							pos.z = pos.z + orient_x[dir]
							for y=1, 3 do
								pos.y = pos.y - 1
								core.set_node(pos, {name=temp_material})
							end
							pos.y = pos.y - 1
							pos.x = pos.x - orient_z[dir]
							pos.z = pos.z - orient_x[dir]
							core.set_node(pos, {name = temp_floor_material})
							pos.x = pos.x - orient_z[dir]
							pos.z = pos.z - orient_x[dir]
							pos.y = pos.y + 1
							travail.place_wall(pos, 1, 3, dir, temp_tunnel_material, 1, temp_corner_material)
							pos.y = pos.y - 1
							core.set_node(pos, {name = temp_floor_material})
							pos.y = pos.y + 1
						end
					else
						local temp_ahead_bits = temp_maze[z+orient_z[dir]][x+orient_x[dir]]
						if temp_ahead_bits<=0 or bit.band(temp_ahead_bits, bit.lshift(1, (dir+1) % 4))==0 then
							pos.x = pos.x + orient_x[dir]
							pos.z = pos.z + orient_z[dir]
							travail.place_wall(pos, 1, 3, dir, temp_material)
						end
					end
				end
			else
				for dir=1, 4 do
					local pos = {x=temp_pos.x+(x-4)*temp_scale, y=temp_pos.y, z=temp_pos.z+(z-4)*temp_scale}
					pos.x = pos.x + orient_x[dir]
					pos.z = pos.z + orient_z[dir]
					local temp_ahead_bits = temp_maze[z+orient_z[dir]][x+orient_x[dir]]
					if temp_ahead_bits>0 then
						pos.x = pos.x + orient_x[dir]
						pos.z = pos.z + orient_z[dir]
						travail.place_wall(pos, 1, 3, dir, temp_material)
					end
				end
			end
		end
	end
end

--TODO: water hole/pillars inside

core.register_chatcommand("igloo", {
	params="<enable/disable>",
	description = "Places igloos",
	func = function(a_username, a_param)
		local temp_player = core.get_player_by_name(a_username)
		local temp_pos = temp_player:getpos()
		temp_pos.x = math.floor(temp_pos.x)
		temp_pos.y = math.floor(temp_pos.y) + 1
		temp_pos.z = math.floor(temp_pos.z)

		local temp_material = "default:snowblock"
		local temp_window_material = math.random(3)==1 and "default:ice" or "air"
		local temp_floor_material = "default:ice"
		local temp_tunnel_material = "air"
		local temp_corner_material = "moreblocks:slab_snowblock"

		travail.generate_igloo_complex(temp_pos, temp_material, temp_window_material, temp_floor_material, temp_tunnel_material, temp_corner_material)
	end
})