-- Pyramid Base
SMODS.PokerHandPart{
    key = 'pyramid_base',
    func = function(hand)
		local sarcs = #SMODS.find_card('j_rgmc_sarcophagus')
		local minimum = sarcs > 0 and 3 or 5
	
		if #hand < minimum then return { } end -- needs to have at least a 3-2-1 structure
		local rank_map, rank_list = MadLib.get_ranks_from_cards(hand), {}

		-- Setting up rank map and rank list
		local get_nominal = function(ab)
			local rank = SMODS.Ranks[ab]
			return (rank and (rank.face_nominal or 0) + rank.nominal) or 0
		end
		MadLib.loop_table(rank_map, function(k) table.insert(rank_list,k) end) -- add ranks to list
		table.sort(rank_list, function(a, b) return get_nominal(a) < get_nominal(b) end) -- ascending nominal order

		local function test_pyramid()
            local function check(order)
                local height = #rank_list
                for trim_bottom = 0, sarcs do
                    for trim_top = 0, sarcs do
                        if trim_bottom + trim_top < height then
                            local valid = true
                            local target_size = 1
                            for idx = 1 + trim_bottom, height - trim_top do
                                local rank = rank_list[order[idx]]
                                if rank_map[rank] ~= target_size then
                                    valid = false
                                    break
                                end
                                target_size = target_size + 1
                            end
                        	if valid then return true end
                    	end
                	end
            	end
            	return false
        	end
            -- index orders
            local ascending = {}
            local descending = {}
            for i = 1, #rank_list do
                ascending[i] = i
                descending[i] = #rank_list - i + 1
            end
            return check(ascending) or check(descending)
        end
		return test_pyramid() and { hand } or {}
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
