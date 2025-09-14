return {
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "vici",
        atlas   = "placeholder",
        pos     = MLIB.get_coords(0,0),
        cost    = 9,
        config  = { edition = 'e_rgmc_flipped' },
        loc_vars = function(self, info_queue, card)
        end,
        can_use = function(self, card)
            return G.hand and #G.hand.cards
                and not MadLib.list_matches_all(G.hand.cards, function(v)
                    return v.edition and v.edition[card.ability.edition]
                end)
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
