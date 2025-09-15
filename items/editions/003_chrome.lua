return {
    categories = {
        'Editions',
        'Score'
    },
    data = {
        object_type = "Edition",
        key 	= 'chrome',
        shader 	= 'chrome',
        weight 	= 3,
        in_shop = true,
        extra_cost = 5,
        config = { triggered = false, x_score = 1.5, },
        sound = { sound = "rgmc_e_chrome", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(self.config.x_score)
        end,
        calculate = function(self, card, context)
            if 
                context.post_joker or
                (context.main_scoring and context.cardarea == G.play) 
            then
                card.ability.triggered = true
                return {
                    message = "...?",
                    colour = G.C.PURPLE
                }
            end

            if context.after and card.ability.triggered then
                card.ability.triggered = nil -- not needed now
                return { 
                    xscore = self.config.x_score or 1,
                }
            end

        end
    }
}
