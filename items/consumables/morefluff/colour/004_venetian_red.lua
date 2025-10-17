
return {
    categories = {
        'Colour Cards'
    },
    data = {
        object_type = 'Consumable',
		set 	= "Colour",
		atlas 	= "mf_colours",
        pos 	= MLIB.coords(0,3),
		key       = "venetian_red",
		config    = { val = 0, partial_rounds = 0, upgrade_rounds = 1, },
		cost      = 4,
		can_use = function(self, card)
			return #G.hand.cards > 1 and card.ability.val > 0
		end,
		use       = Madcap.Funcs.colour_convert_suit(self, card, area, copier, 'rgmc_daggers'),
		loc_vars  = function(self, info_queue, card)
			local val, max = Madcap.Funcs.get_progress_bar(card.ability.partial_rounds, 	card.ability.upgrade_rounds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
		end,
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
