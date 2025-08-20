return {
    categories = {
        'Rotarots',
        'Tarots',
    },
    data = {
        object_type = 'Consumable',
		set   = "Rotarot",
		atlas = "mf_rotarots",
		pos   = MLIB.coords(0,1),
		key   = "rot_filament",
		config = { max_highlighted = 2, mod_conv = 'm_rgmc_signal' },
		cost  = 4,
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue(G.P_CENTERS[card.ability.mod_conv])
            return MadLib.collect_vars(card.ability.max_highlighted, G.localization.descriptions.Enhanced[card.ability.mod_conv].name)
        end,
		can_use   = Madcap.Funcs.consumable_highlight_check(self, card)
    }
}