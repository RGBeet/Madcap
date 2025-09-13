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
        config  = { set = 'Spectral', xmult = 0.1, xchips = 0.1 },
        cost    = 8,
        aurinko = true,
        loc_vars = function(self, info_queue, center)
            local amt = (Madcap.Lists.ConsumableSpatias[card.ability.set] or 0)
            return Madcap.Funcs.get_special_card_vars(self.config.set, (amt * self.config.xchips) + 1, (amt * self.config.xmult) + 1)
        end,
        can_use = function(self, card)
            return (Madcap.Lists.ConsumableSpatias[card.ability.set] or 0) > 0
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_consumable_specific_special_card(card)
        end,
    }
}
