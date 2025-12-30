return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "terra",
        atlas   = "spatia",
        pos     = MLIB.coords(1,7),
        config  = { set = 'Tarot', xmult = 0.1, xchips = 0.05 },
        cost    = 8,
        aurinko = true,
        loc_vars = function(self, info_queue, card)
            return Madcap.Funcs.get_special_card_vars(card)
        end,
        can_use = function(self, card)
            return Madcap.Funcs.get_special_card_multiplier(card) > 0
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_consumable_specific_special_card(card)
        end,
    }
}
