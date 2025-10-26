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
		pos   = MLIB.coords(0,6),
		key   = "rot_umbral_break_up",
		config = { select = 2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.select)
        end,
        can_use = function (self, card)
            return false
        end,
        use = function (self, card, area, copier)
        end
    }
}