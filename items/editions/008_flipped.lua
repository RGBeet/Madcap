return {
    categories = {
        'Editions',
    },
    data = {
        object_type = "Edition",
        key     = "flipped",
        shader  = "flipped",
        weight  = 2,
        config  = { extra = { chips = 16 }, trigger = nil, },
        sound = { sound = "rgmc_e_flipped", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(self.config.extra.chips)
        end,
        calculate = function(self, card, context)
        end,
    }
}
