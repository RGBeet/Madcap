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
			luxury_pts 	= 1
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
		return MadLib.collect_vars(self.config.extra.luxury_pts, self.config.extra.money_mod)
	end,
	calculate = function(self, card, context)

		-- adds luxury points
		if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
			return { rgmc_luxury_pts = self.config.extra.luxury_pts or 1 }
		end

		if
            ((context.cardarea == G.hand and context.playing_card_end_of_round and card.area ~= G.deck )
			or (context.cardarea == G.jokers and context.end_of_round))
			and not context.repetition and not context.individual
        then
			-- Remove $2 at end of round
            MadLib.event({
                func = function()
					ease_dollars(-self.config.extra.money_mod)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'p_dollars', vars = { -self.config.extra.money_mod } } },
                        context.blueprint_card or card)
                    return true
                end
            })
			return nil, true
        end
	end,
    }
}
