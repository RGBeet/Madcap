return {
    devmode = true,
    categories = {
        'Partners',
    },
    data = {
        object_type = "Partner",
        atlas = 'partners',
        pos = MLIB.coords(1,1),
		key = "aces",
		config = {
			extra = { rank_from = "2", rank_to = "King" }
		},
		link_config = { j_rgmc_legend_rio = 1 },
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.rank } }
		end,
		calculate = function(self, card, context)

		end,
    }
}
