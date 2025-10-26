return {
    categories = {
        'Rotarots',
        'Tarots',
    },
    mods = {
        'aikoyorisshenanigans',
        'MoreFluff'
    },
    data = {
        object_type = 'Consumable',
		set   = "Rotumbral",
		atlas = "crossmod_rotumbrals",
		pos   = MLIB.coords(1,9),
		key   = "rot_umbral_mantle",
		config = { extra = 0.2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra)
        end,
        can_use = function (self, card)
            return false
        end,
        use = function (self, card, area, copier)
        end
    }
}