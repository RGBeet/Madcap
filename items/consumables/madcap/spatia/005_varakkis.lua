return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "varakkis",
        atlas   = "spatia",
        pos     = MLIB.coords(0,4),
        cost    = 4,
        aurinko = false,
        config  = {
            subhands		= { 'ml_sh_high', 'ml_sh_low' },
            level_factor	= 1
        },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_spatia_vars(self.config.subhands)
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_spatia_card(card, card.ability.subhands, card.ability.level_factor)
        end,
    }
}
