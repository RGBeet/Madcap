

return {
    categories = {
        'Editions',
    },
    data = {
        object_type = "Edition",
        key 	= 'iridescent',
        shader 	= 'iridescent',
        weight 	= 2,
        in_shop = true,
        extra_cost = 4,
        config  = { x_chips = 2.5, trigger = nil },
        sound   = { sound = "rgmc_e_iridescent", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            return MadLib.collect_vars(self.config.x_chips)
        end,
        on_apply = function(card)
            if not card.ability.rgmc_iridescent then
                card.ability.rgmc_iridescent = true
                if card.config.center.iridescentize then
                    card.config.center:apply_iridescent(card, function(card)
                        Madcap.Funcs.mayhemize(card, {
                            force_values 	= true,
                            min_mult 		= 2,
                            max_mult 		= 2
                        }, false)
                    end)
                else
                    Madcap.Funcs.mayhemize(card, {
                        force_values 	= true,
                        min_mult 		= 2,
                        max_mult 		= 2
                    }, false)
                end
            end
        end,
        on_remove = function(card)
            card.ability.rgmc_iridescent = nil
        end,
    }
}
