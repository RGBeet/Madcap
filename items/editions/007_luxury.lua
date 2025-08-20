return {
    categories = {
        'Editions',
    },
    data = {
        object_type = "Edition",
        key     = "luxury",
        shader  = "luxury",
        weight  = 2,
	config = {
		extra = {
			money_mod 	= 3,
			extra = 1
		},
		trigger = nil,
	},
	sound = {
		sound = "rgmc_e_luxury",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		return MadLib.collect_vars(self.config.extra.extra, self.config.extra.money_mod)
	end,
	calculate = function(self, card, context)

		-- adds luxury points
		if Madcap.Funcs.edition_in_play(context,card) then
			G.GAME.luxury_points = G.GAME.luxury_points + 1
            return {
				message = "!!",
				colour	= G.C.PURPLE,
				card 	= card
			}
		end

		if -- takes money at end of round
            context.playing_card_end_of_round
			and to_big(G.GAME.dollars) - to_big(self.config.extra.money_mod) >= to_big(0)
        then
            ease_dollars(-self.config.extra.money_mod)
        end
	end,
    }
}
