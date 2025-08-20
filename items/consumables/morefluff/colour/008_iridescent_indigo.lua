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
		can_use   = Madcap.Funcs.colour_can_use(self,card),
		use       = Madcap.Funcs.colour_add_consumable_exact(self, card, area, copier, 'rgmc_sleeping_ships'),
		loc_vars  = Madcap.Funcs.get_colour_loc_vars(self, info_queue, card),
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}