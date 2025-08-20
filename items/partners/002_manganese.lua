return {
	devmode = true,
    categories = {
        'Partners',
    },
    data = {
        object_type = "Partner",
        atlas = 'partners',
        pos = MLIB.coords(0,2),
		key = "traveller",
		config = {
			extra = { bonus_levels = 0.5, }
		},
		link_config = { j_rgmc_rocket_keychain = 1 },
		loc_vars = function(self, info_queue, card)
			return {
				vars = {
					card.ability.bonus_levels,
					(G.GAME and G.GAME.previous_poker_hand) or "High Card" -- get previous poker hand
				}
			}
		end,
    }
}
