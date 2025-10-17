return {
    categories = {
        'Colour Cards',
    },
    data = {
        object_type = 'Consumable',
		set 	= "Colour",
		atlas 	= "mf_colours",
        pos 	= MLIB.coords(2,2),
		key       = "dark_magenta",
		config    = { val = 0, partial_rounds = 0, upgrade_rounds = 3, extra = 2 },
		cost      = 6,
		can_use = function(self, card)
			return card.ability.val > 0
		end,
		use = function(self, card, area, copier)
			ease_lp(card.ability.val * card.ability.extra)
			delay(0.6)
		end,
		loc_vars  = function(self, info_queue, card)
			local val, max = Madcap.Funcs.get_progress_bar(card.ability.partial_rounds, 	card.ability.upgrade_rounds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds, card.ability.extra, card.ability.extra * card.ability.val)
		end,
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
