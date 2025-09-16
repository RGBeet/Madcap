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
            local amt = to_big(G.GAME.dollars - 1)
            MadLib.simple_event(function()
                ease_dollars(-amt, true)
                card:juice_up(0.3, 0.5)
                return true
            end, 1.0, 'after')
            MadLib.simple_event(function()
                ease_lp((to_big(amt) / math.floor(to_big(G.GAME.dollars) or to_big(5))), true)
                play_sound('rgmc_kaching', 0.8)
                card:juice_up(0.3, 0.5)
                return true
            end, 1.0, 'after')
        end,
    }
}
