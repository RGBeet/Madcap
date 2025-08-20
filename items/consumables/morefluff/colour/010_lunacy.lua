return {
    categories = {
        'Colour Cards',
        'Mayhem',
    },
    data = {
        object_type = 'Consumable',
		set  = "Colour",
		atlas = "mf_colours_lunacy",
		pos = MLIB.coords(0,4),
		key = "lunacy",
		config = { val = 0, partial_rounds = 0, upgrade_rounds = 3, },
		cost = 12,
		can_use = Madcap.Funcs.colour_can_use(self,card),
		use = function(self, card, area, copier)
			--n_random_colour_rounds(card.ability.val)
		end,
		loc_vars = Madcap.Funcs.get_colour_loc_vars(self, info_queue, card),
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
