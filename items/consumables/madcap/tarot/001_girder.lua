return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = 'Consumable',
        set     = "Tarot",
        key     = "girder",
        atlas   = "tarots",
        pos     = MLIB.get_coords(0,0),
        cost    = 4,
        config  = { max_highlighted = 2, mod_conv = 'm_rgmc_ferrous' },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS[mod_conv]
            return MadLib.collect_vars(card.ability.max_highlighted, G.localization.descriptions.Enhanced[card.ability.mod_conv].name)
        end,
        can_use = function(self, card)
        return MadLib.can_use_transform_tarot(card)
        end,
    }
}
