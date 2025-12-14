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
        config = { triggered = false, x_score = 2, odds = 3, will_shatter = false },
        sound = { sound = "rgmc_e_infernal", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(self.config.x_score, G.GAME.probabilities.normal or 1, self.config.odds)
        end,
        calculate = function(self, card, context)
            if 
                context.post_joker or
                (context.main_scoring and context.cardarea == G.play)
            then
                card.ability.triggered = true
                print('triggered')
                return { 
                    xscore          = self.config.x_score or 3,
                    after_scoring   = true
                }
            end

            -- If card was activated at any time during blind, 1 in 3 chance it BURNS UP!
            if context.end_of_blind then
                if 
                    card.ability.triggered == true
                then
                    print('Triggered?')
                    if
                        not card.ability.eternal 
                        and SMODS.pseudorandom_probability(card, 'infernal', 1, card.ability.extra.odds) 
                    then
                        print('DIE!')
                        card:start_dissolve({ G.C.DARK }, nil, 1.6)
                        card = nil
                    else
                        print('LIVE')
                        card.ability.triggered = false
                    end
                end
            end
        end,
    }
}
