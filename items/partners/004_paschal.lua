return {
	devmode = true,
    categories = {
        'Partners',
    },
    data = {
        object_type = "Partner",
        atlas = 'partners',
        pos = MLIB.coords(0,3),
		key = "paschal",
		config = { },
		link_config = { j_rgmc_easter_egg = 1 },
		loc_vars = function(self, info_queue, card)
			return { vars = { } }
		end,
		calculate = function(self, card, context)
        	if context.setting_blind then
				MadLib.simple_event(function()
					-- priotized base cards (no edition nor enhancement), then enhanced only
					MadLib.shuffle_sort_list(G.hand.cards, nil, function(a,b)
						local _a = (SMODS.has_enhancement(a) and -2 or 0) + (a.edition and -1 or 0)
						local _b = (SMODS.has_enhancement(b) and -2 or 0) + (a.edition and -1 or 0)
						return _a < _b
					end)
				end, 0.5, 'after')
			end
		end,
    }
}
