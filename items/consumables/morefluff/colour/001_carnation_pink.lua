
return {
    categories = {
        'Colour Cards'
    },
    data = {
        object_type = 'Consumable',
		set 	= "Colour",
		atlas 	= "mf_colours",
        pos 	= MLIB.coords(0,0),
		key       = "carnation_pink",
		config    = { val = 0, partial_rounds = 0, upgrade_rounds = 1, },
		cost      = 4,
		can_use   = Madcap.Funcs.colour_can_use(self,card),
		use       = Madcap.Funcs.colour_convert_suit(self, card, area, copier, 'rgmc_goblets'),
		loc_vars  = Madcap.Funcs.get_colour_loc_vars(self, info_queue, card),
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}