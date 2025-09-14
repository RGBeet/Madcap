return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = 'Consumable',
        set     = "Tarot",
        key     = "conundrum",
        atlas   = "placeholder",
        pos     = MLIB.coords(0,0),
        cost    = 4,
        config  = { max_highlighted = 1, edition = 'e_rgmc_flipped' },
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue(G.P_CENTERS[card.ability.edition])
            return MadLib.collect_vars(card.ability.max_highlighted, G.localization.descriptions.Edition[card.ability.edition].name)
        end,
        can_use = function(self, card)
            return G.hand and #G.hand.highlighted > 0 
                and #G.hand.highlighted <= card.ability.max_highlighted
                and not MadLib.list_matches_all(G.hand.highlighted, function(v)
                    return v.edition and v.edition[card.ability.edition]
                end)
        end,
        use = function(self, card, area, copier) --Good enough
            MadLib.loop_func(G.hand.highlighted, function(v)
                MadLib.simple_event(function()
                    v:set_edition(card.ability.edition, true)
                    card:juice_up(0.3, 0.5)
                    return true
                end, 0.4, 'after')
            end)
        end,
    }
}
