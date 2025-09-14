return {
    categories = {
        'Editions',
        'Mayhem'
    },
    data = {
        object_type = "Edition",
        key 	= 'abyssal',
        shader 	= 'abyssal',
        weight  = 2,
        in_shop = true,
        extra_cost = 6,
        config = {
            extra = { xmult_mod = 0.08 }
        },
        sound = { sound = "rgmc_e_abyssal", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            local total = (G.GAME.mayhem or 0) * self.config.extra.xmult_mod
            return MadLib.collect_vars(total, self.config.extra.xmult_mod)
        end,
        calculate = function(self, card, context)
            if 
                (context.post_joker or
                (context.main_scoring and context.cardarea == G.play))
                and G.GAME.mayhem > 0 
            then
                local total = G.GAME.mayhem * self.config.extra.xmult_mod
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, total)
            end
        end,
    }
}
