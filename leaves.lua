core.register_node("travail:leaves_falling", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	special_tiles = {"default_leaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	drop = "default:leaves",
	groups = {snappy = 3, leaffalldecay = 3, flammable = 2, leaves = 1, falling_node = 1},
	sounds = default.node_sound_leaves_defaults(),
})

for temp_name, temp_node in pairs(core.registered_nodes) do
	if temp_node.groups then
		if temp_node.groups.leaves then
--			temp_node.groups.falling_node = 1
			temp_node.drop = {
				max_items = 1,
				items = {
					{
						-- player will get sapling with 1/50 chance
						items = {'default:sapling'},
						rarity = 50,
					},
					{
						-- player will get leaves only if he get no saplings,
						-- this is because max_items is 1
						items = {temp_name},
					}
				}
			}

			local temp_falling_name = "travail"..temp_name:sub(string.find(temp_name, ":", 1, true)).."_falling"
			core.register_node(temp_falling_name, {
				description = temp_node.description,
				drawtype = temp_node.drawtype,
				waving = temp_node.waving,
				visual_scale = temp_node.visual_scale,
				tiles = temp_node.tiles,
				special_tiles = temp_node.special_tiles,
				paramtype = temp_node.paramtype,
				is_ground_content = false,
				drop = temp_node.drop,
				groups = {snappy = 3, leaffalldecay = 3, flammable = 2, leaves = 1, falling_node = 1},
				sounds = temp_node.sounds,
			})
		elseif temp_node.groups.tree then
			temp_node.groups.falling_node = 1
		end

	end
end

local function find_abm(a_nodenames, a_neighbors)
	for temp_index, temp_abm in pairs(core.registered_abms) do
		if temp_abm then
			local temp_found = false
			if temp_abm.nodenames then
				for i=1, #temp_abm.nodenames do
					temp_found = false
					for j=1, #a_nodenames do
						if a_nodenames[j]==temp_abm.nodenames[i] then
							temp_found = true
							break
						end
					end
					if not temp_found then
						break
					end
				end
			end
			if temp_found and temp_abm.neighbors then
				for i=1, #temp_abm.neighbors do
					temp_found = false
					for j=1, #a_neighbors do
						if a_neighbors[j]==temp_abm.neighbors[i] then
							temp_found = true
							break
						end
					end
					if not temp_found then
						break
					end
				end
			end
			if temp_found then
				return temp_abm, temp_index
			end
		end
	end
	return nil, 0
end

local function falling_leaves(p0, node, _, _)
	local do_preserve = false
	local d = core.registered_nodes[node.name].groups.leafdecay
	if not d or d == 0 then
		--print("not groups.leafdecay")
		return
	end
	local n0 = core.get_node(p0)
	if n0.param2 ~= 0 then
		--print("param2 ~= 0")
		return
	end
	local p0_hash = nil
	if default.leafdecay_enable_cache then
		p0_hash = core.hash_node_position(p0)
		local trunkp = default.leafdecay_trunk_cache[p0_hash]
		if trunkp then
			local n = core.get_node(trunkp)
			local reg = core.registered_nodes[n.name]
			-- Assume ignore is a trunk, to make the thing
			-- work at the border of the active area
			if n.name == "ignore" or (reg and reg.groups.tree and
					reg.groups.tree ~= 0) then
				--print("cached trunk still exists")
				return
			end
			--print("cached trunk is invalid")
			-- Cache is invalid
			table.remove(default.leafdecay_trunk_cache, p0_hash)
		end
	end
	if default.leafdecay_trunk_find_allow_accumulator <= 0 then
		return
	end
	default.leafdecay_trunk_find_allow_accumulator = default.leafdecay_trunk_find_allow_accumulator - 1
	-- Assume ignore is a trunk, to make the thing
	-- work at the border of the active area
	local p1 = core.find_node_near(p0, d, {"ignore", "group:tree"})
	if p1 then
		do_preserve = true
		if default.leafdecay_enable_cache then
			--print("caching trunk")
			-- Cache the trunk
			default.leafdecay_trunk_cache[p0_hash] = p1
		end
	end
	if not do_preserve then
		-- Drop stuff other than the node itself
		local itemstacks = core.get_node_drops(n0.name)
		for _, itemname in ipairs(itemstacks) do
			if core.get_item_group(n0.name, "leafdecay_drop") ~= 0 or
					itemname ~= n0.name then
				local p_drop = {
					x = p0.x - 0.5 + math.random(),
					y = p0.y - 0.5 + math.random(),
					z = p0.z - 0.5 + math.random(),
				}
				core.add_item(p_drop, itemname)
			end
		end
		-- Remove node
		local temp_leaves_falling_name = "travail"..node.name:sub(string.find(node.name, ":", 1, true)).."_falling"
		if math.random(3)~=1 and core.registered_nodes[temp_leaves_falling_name] then
			core.set_node(p0, {name=temp_leaves_falling_name})
		else
			core.remove_node(p0)
		end
		nodeupdate(p0)
	end
end

local temp_abm, temp_index = find_abm({"group:leafdecay"}, {"air", "group:liquid"})
if temp_abm then
	temp_abm.action = falling_leaves

	core.register_abm({
		nodenames = {"group:leaffalldecay"},
		neighbors = {"air", "group:liquid"},
		-- A low interval and a high inverse chance spreads the load
		interval = 2,
		chance = 5,

		action = function(a_position, a_node, _, _)
			core.remove_node(a_position)
			nodeupdate(a_position)
		end
	})
end
