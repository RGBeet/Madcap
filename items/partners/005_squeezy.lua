return {
	devmode = true,
    categories = {
        'Partners',
    },
    data = {
        object_type = "Partner",
        atlas = 'partners',
        pos = MLIB.coords(0,4),
		key = "squeezy",
		config = {
			extra = { x_mult 	= 0.25, a_chips = 50 },
			immutable = { before_score = 0 }
		},
		link_config = { j_rgmc_squeezy_cheeze = 1 },
		loc_vars = function(self, info_queue, card)
			return MadLib.collect_vars(card.ability.x_mult,card.ability.a_chips)
		end,
		calculate = function(self, card, context)
			-- calculate before score
			if context.before then
				card.ability.immutable.before_score = 0
			end
			-- final step of scoring
		end,
    }
}
