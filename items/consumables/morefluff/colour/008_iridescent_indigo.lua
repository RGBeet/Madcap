return {
    categories = {
        'Colour Cards',
        'Unusual',
    },
    data = {
        object_type = 'Consumable',
		set 	= "Colour",
		atlas 	= "mf_colours",
        pos 	= MLIB.coords(1,3),
		key       = "iridescent_indigo",
		config    = { val = 0, partial_rounds = 0, upgrade_rounds = 8, },
		cost      = 12,
		can_use = function(self, card)
			return card.ability.val > 0
		end,
		use       = Madcap.Funcs.colour_add_consumable_exact(self, card, area, copier, 'rgmc_sleeping_ships'),
		loc_vars  = function(self, info_queue, card)
			local val, max = Madcap.Funcs.get_progress_bar(card.ability.partial_rounds, 	card.ability.upgrade_rounds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
		end,
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
