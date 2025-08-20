return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "gibbous_moon",
        atlas   = "spatia",
        pos     = MLIB.coords(1,2),
        cost    = 8,
        aurinko = false,
        config = { subhand = 'High', levels = 1 },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("rgmc_moon"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        can_use = function(self, card)
            return true
        end,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_moon_card_vars(self.config.subhand, self.config.levels)
        end,
    }
}
