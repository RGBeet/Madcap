return {
    devmode = true,
    categories = {
        'Partners',
    },
    data = {
        object_type = "Partner",
        atlas = 'partners',
        pos = MLIB.coords(1,0),
		key = "foolish",
		config = {  },
		link_config = { j_rgmc_catch_the_clown = 1 },
		loc_vars = function(self, info_queue, card)
			return { vars = { } }
		end,
		calculate = function(self, card, context)

		end,
    }
}
