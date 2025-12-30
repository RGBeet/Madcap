return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "pagoon",
        atlas   = "spatia",
        pos     = MLIB.coords(2,1),
        config  = { set = 'CosmaTarot', xmult = 0.05, xchips = 0.15 },
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
