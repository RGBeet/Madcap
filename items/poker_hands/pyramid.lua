-- Pyramid Base
SMODS.PokerHandPart{
    key = 'pyramid_base',
    func = function(hand)
		local minimum = 5
		if #hand < minimum then return { } end -- needs to have at least a 3-2-1 structure
		local rank_map = MadLib.get_ranks_from_cards(hand)
		print(rank_map)

		local rank_list = { }

		local get_nominal = function(ab)
			local rank = SMODS.Ranks[ab]
			return (rank and (rank.face_nominal or 0) + rank.nominal) or 0
		end

		MadLib.loop_table(rank_map, function(k) table.insert(rank_list,k) end) -- add ranks to list


		local target_size
		local test_pyramid = function()
			target_size = 1
			for i=1, #rank_list do
				if rank_map[rank_list[i]] ~= target_size then
					return false
				end
				target_size = target_size + 1 -- next rank must have i+1
			end
			return true
		end

		table.sort(rank_list, function(a,b) return get_nominal(a) > get_nominal(b) end) -- sort by nominal size
		if test_pyramid() then return { hand } end

		-- try inverting!
		table.sort(rank_list, function(a,b) return get_nominal(a) < get_nominal(b) end) -- sort by nominal size
		if test_pyramid() then return { hand } end

		return { }
	end
}

return {
    categories = {
		'Poker Hands'
    },
	data = {
        object_type = "PokerHand",
		key 	= "rgmc_pyramid",
		visible = false,
		chips 	= 90,
		mult 	= 7,
		l_chips = 30,
		l_mult 	= 3,
		example = {
			{ 'S_K',    true },
			{ 'C_8', 	true },
			{ 'H_8', 	true },
			{ 'S_4',    true },
			{ 'C_4',    true },
			{ 'D_4', 	true },
		},
		evaluate = function(parts, hand)
			return parts.rgmc_pyramid_base
		end,
	}
}
