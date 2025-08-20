return {
    categories = {
        'Subhands',
        'Spatia'
    },
    data = {
        object_type = 'Consumable',
        set     = "SpatiaPlanet",
        key     = "prometheus",
        atlas   = "spatia",
        pos     = MLIB.coords(0,0),
        cost    = 4,
        aurinko = false,
        config  = {
            hands 			= { 'Flush', MadLib.SpectrumId .. 'Spectrum' },
            subhands		= { 'Dark' },
            level_factor	= 1
        },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        loc_vars = function(self, info_queue, center)
            return Madcap.Funcs.get_spatia_vars(self.config.hands,self.config.subhands)
        end,
        can_use = function(self, card)
            return true
        end,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.use_spatia_card(card, card.ability.subhands, card.ability.level_factor)
        end,
    }
}
