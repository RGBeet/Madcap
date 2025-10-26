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
		pos   = MLIB.coords(1,0),
		key   = "rot_umbral_misfortune",
		config = { },
        loc_vars = function(self, info_queue, card)
            return { vars = {} }
        end,
        can_use = function (self, card)
            return false
        end,
        use = function (self, card, area, copier)
        end
    }
}