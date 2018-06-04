
--
-- Formspecs
--

gui_slots = "listcolors[#606060AA;#808080;#101010;#202020;#FFF]"

local function active_formspec(fuel_percent, item_percent, a_type)
	local formspec = 
		"size[8,8.5]"..
		gui_slots..
		"list[current_name;src;2.75,0.5;1,1;]"..
		"list[current_name;fuel;2.75,2.5;1,1;]"..
		"image[2.75,1.5;1,1;default_furnace_fire_bg.png^[lowpart:"..
		(100-fuel_percent)..":default_furnace_fire_fg.png]"..
		"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[lowpart:"..
		(item_percent)..":gui_furnace_arrow_fg.png^[transformR270]"..
		"list[current_name;dst;4.75,0.96;2,2;]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[current_name;dst]"..
		"listring[current_player;main]"..
		"listring[current_name;src]"..
		"listring[current_player;main]"..
		default.get_hotbar_bg(0, 4.25)
	return formspec
end

local function inactive_formspec(a_type)
	return "size[8,8.5]"..
	gui_slots..
	"list[current_name;src;2.75,0.5;1,1;]"..
	"list[current_name;fuel;2.75,2.5;1,1;]"..
	"image[2.75,1.5;1,1;default_furnace_fire_bg.png]"..
	"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_name;dst;4.75,0.96;2,2;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"listring[current_name;dst]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	default.get_hotbar_bg(0, 4.25)
end

--
-- Node callback functions that are the same for active and inactive furnace
--

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("fuel") and inv:is_empty("dst") and inv:is_empty("src")
end

local function has_locked_furnace_privilege(temp_owner, player)
	if player:get_player_name() ~= temp_owner and player:get_player_name() ~= minetest.setting_get("name") then
		return false
	end
	return true
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local temp_owner = meta:get_string("owner")
	if temp_owner and #temp_owner>0 then
		if not has_locked_furnace_privilege(temp_owner, player) then
			return 0
		end
	end
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			if inv:is_empty("src") then
				meta:set_string("infotext", "Furnace is empty")
			end
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local temp_owner = meta:get_string("owner")
	if temp_owner and #temp_owner>0 then
		if not has_locked_furnace_privilege(temp_owner, player) then
			return 0
		end
	end
	return stack:get_count()
end

local function place_locked(pos, placer)
	local meta = minetest.get_meta(pos)
	meta:set_string("owner", placer:get_player_name())
	meta:set_string("infotext", "Locked Furnace (owned by " .. placer:get_player_name() .. ")")
end

local function register_furnace_type(a_type, a_substance, a_locked, a_speed, a_fuel_rate)
	local temp_name
	local temp_after_place_function
	if a_locked then
		temp_after_place_function = place_locked
		temp_name = "Locked "..a_type:sub(1,1):upper()..a_type:sub(2)
		a_type = a_type.."_locked"
	else
		temp_after_place_function = nil
		temp_name = a_type:sub(1,1):upper()..a_type:sub(2)
	end

	minetest.register_node("travail:"..a_type.."_furnace", {
		description = temp_name.." Furnace",
		tiles = {
			"travail_"..a_type.."_furnace_side.png", "travail_"..a_type.."_furnace_side.png",
			"travail_"..a_type.."_furnace_side.png", "travail_"..a_type.."_furnace_side.png",
			"travail_"..a_type.."_furnace_side.png", "travail_"..a_type.."_furnace_front.png"
		},
		paramtype2 = "facedir",
		groups = {cracky=2},
		legacy_facedir_simple = true,
		is_ground_content = false,
		sounds = default.node_sound_stone_defaults(),

		after_place_node=temp_after_place_function,
		can_dig = can_dig,

		allow_metadata_inventory_put = allow_metadata_inventory_put,
		allow_metadata_inventory_move = allow_metadata_inventory_move,
		allow_metadata_inventory_take = allow_metadata_inventory_take,
	})

	minetest.register_node("travail:"..a_type.."_furnace_active", {
		description = temp_name.." Furnace",
		tiles = {
			"travail_"..a_type.."_furnace_side.png", "travail_"..a_type.."_furnace_side.png",
			"travail_"..a_type.."_furnace_side.png", "travail_"..a_type.."_furnace_side.png",
			"travail_"..a_type.."_furnace_side.png",
			{
				image = "travail_"..a_type.."_furnace_front_active.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 1.5
				},
			}
		},
		paramtype2 = "facedir",
		light_source = 10,
		drop = "travail:"..a_type.."_furnace",
		groups = {cracky=2, not_in_creative_inventory=1},
		legacy_facedir_simple = true,
		is_ground_content = false,
		sounds = default.node_sound_stone_defaults(),

		can_dig = can_dig,

		allow_metadata_inventory_put = allow_metadata_inventory_put,
		allow_metadata_inventory_move = allow_metadata_inventory_move,
		allow_metadata_inventory_take = allow_metadata_inventory_take,
	})

	--
	-- ABM
	--

	local function swap_node(pos, name)
		local node = minetest.get_node(pos)
		if node.name == name then
			return
		end
		node.name = name
		minetest.swap_node(pos, node)
	end

	minetest.register_abm({
		nodenames = {"travail:"..a_type.."_furnace", "travail:"..a_type.."_furnace_active"},
		interval = 1.0,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			--
			-- Inizialize metadata
			--
			local meta = minetest.get_meta(pos)
			local fuel_time = meta:get_float("fuel_time") or 0
			local src_time = meta:get_float("src_time") or 0
			local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

			--
			-- Inizialize inventory
			--
			local inv = meta:get_inventory()
			for listname, size in pairs({
					src = 1,
					fuel = 1,
					dst = 4,
			}) do
				if inv:get_size(listname) ~= size then
					inv:set_size(listname, size)
				end
			end
			local srclist = inv:get_list("src")
			local fuellist = inv:get_list("fuel")
			local dstlist = inv:get_list("dst")

			--
			-- Cooking
			--

			-- Check if we have cookable content
			local cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
			local cookable = true

			if cooked.time == 0 then
				cookable = false
			end

			if fuel_totaltime>0 then
				-- The furnace is currently active and has enough fuel
				fuel_time = fuel_time + a_fuel_rate
			end
			-- Check if we have enough fuel to burn
			if fuel_time < fuel_totaltime then

				-- If there is a cookable item then check if it is ready yet
				if cookable then
					src_time = src_time + a_speed
					if src_time >= cooked.time then
						-- Place result in dst list if possible
						if inv:room_for_item("dst", cooked.item) then
							inv:add_item("dst", cooked.item)
							inv:set_stack("src", 1, aftercooked.items[1])
							src_time = src_time - cooked.time
						end
					end
				end
			else
				-- Furnace ran out of fuel
				if cookable then
					-- We need to get new fuel
					local fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

					if fuel.time == 0 then
						-- No valid fuel in fuel list
						fuel_totaltime = 0
						fuel_time = 0
						src_time = 0
					else
						-- Take fuel from fuel list
						inv:set_stack("fuel", 1, afterfuel.items[1])

						fuel_time = fuel_time - fuel_totaltime
						fuel_totaltime = fuel.time
					end
				else
					-- We don't need to get new fuel since there is no cookable item
					fuel_totaltime = 0
					fuel_time = 0
					src_time = 0
				end
			end

			--
			-- Update formspec, infotext and node
			--
			local formspec = inactive_formspec(a_type)
			local item_state = ""
			local item_percent = 0
			if cookable then
				item_percent =  math.floor(src_time / cooked.time * 100)
				item_state = item_percent .. "%"
			else
				if srclist[1]:is_empty() then
					item_state = "Empty"
				else
					item_state = "Not cookable"
				end
			end

			local fuel_state = "Empty"
			local active = "inactive "
			if fuel_time <= fuel_totaltime and fuel_totaltime ~= 0 then
				active = "active "
				local fuel_percent = math.floor(fuel_time / fuel_totaltime * 100)
				fuel_state = fuel_percent .. "%"
				formspec = active_formspec(fuel_percent, item_percent, a_type)
				swap_node(pos, "travail:"..a_type.."_furnace_active")
			else
				if not fuellist[1]:is_empty() then
					fuel_state = "0%"
				end
				swap_node(pos, "travail:"..a_type.."_furnace")
			end

			local infotext =  temp_name.." Furnace " .. active .. "(Item: " .. item_state .. "; Fuel: " .. fuel_state .. ")"

			--
			-- Set meta values
			--
			meta:set_float("fuel_totaltime", fuel_totaltime)
			meta:set_float("fuel_time", fuel_time)
			meta:set_float("src_time", src_time)
			meta:set_string("formspec", formspec)
			meta:set_string("infotext", infotext)
		end,
	})

	local temp_centre_substance = ""
	if a_locked then
		temp_centre_substance = "group:ingot"
	end
	core.register_craft({
		output = "travail:"..a_type.."_furnace",
		recipe = {
			{a_substance, a_substance, a_substance},
			{a_substance, temp_centre_substance, a_substance},
			{a_substance, a_substance, a_substance},
		}
	})
end

travail.register_furnace = function(a_type, a_subtance, a_speed, a_fuel_rate)
	register_furnace_type(a_type, a_subtance, false, a_speed, a_fuel_rate)
	register_furnace_type(a_type, a_subtance, true, a_speed, a_fuel_rate)
end

--Last two values are: speed, fuel_rate
travail.register_furnace("desert", "default:desert_cobble", 1.15, 1)
travail.register_furnace("brick", "default:brick", 1.5, 1.5)
travail.register_furnace("basalt", "magma:basalt_cobble", 1.25, 0.5)
travail.register_furnace("mithril_brick", "travail:mithril_steel_brick", 1.5, 0.5)
