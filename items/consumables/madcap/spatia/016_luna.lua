return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "luna",
        atlas   = "spatia",
        pos     = MLIB.coords(2,0),
        config  = { set = 'Spectral', xmult = 0.15, xchips = 0.15 },
        cost    = 8,
        aurinko = true,
        loc_vars = function(self, info_queue, center)
             return Madcap.Funcs.get_special_card_vars(self.config.set, self.config.xchips, self.config.xmult)
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_consumable_specific_special_card(card)
        end,
    }
}
