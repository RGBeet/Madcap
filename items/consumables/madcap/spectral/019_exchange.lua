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
            return MadLib.is_positive_number(cash_to_lp(G.GAME.dollars))
        end,
        use = function(self, card, area, copier)
            local amt = MadLib.subtract(G.GAME.dollars, 1)
            MadLib.simple_event(function()
                ease_dollars(MadLib.multiply(amt, -1), true)
                card:juice_up(0.3, 0.5)
                return true
            end, 1.0, 'after')
            MadLib.simple_event(function()
                ease_lp(cash_to_lp(G.GAME.dollars))
                play_sound('rgmc_kaching', 0.8)
                card:juice_up(0.3, 0.5)
                return true
            end, 1.0, 'after')
        end,
    }
}
