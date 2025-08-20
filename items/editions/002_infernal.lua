return {
    categories = {
        'Editions',
        'Score'
    },
    data = {
        object_type = "Edition",
        key 	= 'infernal',
        shader 	= 'infernal',
        weight 	= 2,
        extra_cost = 5,
        config = { x_score = 3, odds = 3, will_shatter = false, trigger = nil
        },
        sound = { sound = "rgmc_e_infernal", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(self.config.x_score, G.GAME.probabilities.normal or 1, self.config.odds)
        end,
        calculate = function(self, card, context)
            if Madcap.Funcs.edition_in_play(context, card) or context.joker_main then
                card.ability.infernaled = true
                return {
                    message = "...?",
                    colour = G.C.PURPLE
                }
            end
            if context.after and card.ability.infernaled then
                return MadLib.do_x_score(self.config.x_score)
            end
            -- If card was activated at any time during blind, 1 in 3 chance it BURNS UP!
            if context.end_of_blind then
                if card.ability.infernaled and not card.ability.eternal then
                    if SMODS.pseudorandom_probability(card, 'infernal', 1, card.ability.extra.odds) then
                        if Yahimod then -- yahimod make card go BOOM!
                            tell('Card asplode')
                            explodeCard(card)
                        else
                            card:start_dissolve()
                            card = nil
                        end
                    end

                end
                if card then card.ability.infernaled = nil end
            end

            if context.joker_main then
                card.config.trigger = true
            end

            if context.after then
                card.config.trigger = nil
            end
        end,
    }
}
