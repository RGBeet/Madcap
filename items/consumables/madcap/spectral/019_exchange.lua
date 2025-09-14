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
                    card.ability.extra.dollars,
                    cash_to_lp(card.ability.extra.dollars)
                }
            }
        end,
        can_use = function(self, card)
            return to_big(G.GAME.dollars - 1) >= to_big(0)
        end,
        use = function(self, card, area, copier)
            MadLib.loop_func(G.hand.cards, function(v)
                MadLib.simple_event(function()
                    v:set_edition(card.ability.edition, true)
                    card:juice_up(0.3, 0.5)
                    return true
                end, 0.4, 'after')
            end)
        end,
    }
}
