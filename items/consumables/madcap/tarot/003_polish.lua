return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = 'Consumable',
        set     = "Tarot",
        key     = "polish",
        atlas   = "tarots",
        pos     = MLIB.coords(0,2),
        cost    = 4,
        config  = { max_highlighted = 1, mod_conv = 'm_rgmc_lustrous' },
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue(G.P_CENTERS[card.ability.mod_conv])
            return MadLib.collect_vars(card.ability.max_highlighted, G.localization.descriptions.Enhanced[card.ability.mod_conv].name)
        end,
        can_use = function(self, card)
        return MadLib.can_use_transform_tarot(card)
        end,
    }
}
