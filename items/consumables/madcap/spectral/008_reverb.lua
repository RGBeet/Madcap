return {
    categories = {
        'Seals'
    },
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "reverb",
        atlas   = "placeholder",
        pos     = MLIB.get_coords(0,0),
        cost    = 4,
        config  = { seal = 'rgmc_jade', max_highlighted = 1 },
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue(G.P_SEALS[card.ability.extra])
            return MadLib.collect_vars(card.ability.max_highlighted)
        end,
        can_use = function(self, card)
            return Madcap.Funcs.can_use_selection_card(card.ability.max_highlighted)
        end,
        use = function(self, card, area, copier)
            MadLib.apply_seals(G.hand.highlighted, card.ability.seal)
        end,
    }
}
