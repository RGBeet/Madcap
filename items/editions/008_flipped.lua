return {
    categories = {
        'Editions',
    },
    data = {
        object_type = "Edition",
        key     = "flipped",
        shader  = "flipped",
        weight  = 2,
        config  = { extra = { factor = 0.1 }, trigger = nil, },
        sound = { sound = "rgmc_e_flipped", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            local blind_base = SMODS.get_blind_amount(G.GAME.round_resets and G.GAME.round_resets.ante or 1)
            return MadLib.collect_vars(blind_base * self.config.extra.factor)
        end,
        calculate = function(self, card, context)
            if 
                context.post_joker or
                (context.main_scoring and context.cardarea == G.play)
            then
            local blind_base = SMODS.get_blind_amount(G.GAME.round_resets and G.GAME.round_resets.ante or 1)
                return { ascore = blind_base * (self.config.extra.factor or 0.1) }
            end
        end,
    }
}
