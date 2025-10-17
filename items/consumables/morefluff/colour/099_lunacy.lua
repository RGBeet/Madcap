return {
    categories = {
        'Colour Cards',
        'Mayhem',
    },
    data = {
        object_type = 'Consumable',
		set  = "Colour",
		atlas = "mf_lunacy",
		pos = MLIB.coords(0,4),
		key = "lunacy",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 3, },
		cost = 12,
		can_use = Madcap.Funcs.colour_can_use(self,card),
		use = function(self, card, area, copier)
			--n_random_colour_rounds(card.ability.val)
		end,
		loc_vars  = function(self, info_queue, card)
			local val, max = Madcap.Funcs.get_progress_bar(card.ability.partial_rounds, 	card.ability.upgrade_rounds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
		end,
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
