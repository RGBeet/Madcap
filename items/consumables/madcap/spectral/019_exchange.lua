return {
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "exchange",
        atlas   = "placeholder",
        pos     = MLIB.get_coords(0,0),
        cost    = 5,
        config  = { dollars = 5 },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.dollars,
                    cash_to_lp(card.ability.dollars)
                }
            }
        end,
        can_use = function(self, card)
            local value = G.GAME.dollars-1
            return value >= 0 and cash_to_lp(value) > 0
        end,
        use = function(self, card, area, copier)
            local value = G.GAME.dollars - 1
            ease_dollars(-value)
            ease_lp(cash_to_lp(value))
        end,
    }
}
