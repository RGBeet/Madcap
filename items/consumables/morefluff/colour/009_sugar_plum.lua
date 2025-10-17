return {
    categories = {
        'Colour Cards',
        'Mayhem',
    },
    data = {
        object_type = 'Consumable',
		set 	= "Colour",
		atlas 	= "mf_colours",
        pos 	= MLIB.coords(2,0),
		key       = "sugar_plum",
		config    = { val = 0, partial_rounds = 0, upgrade_rounds = 3, extra = 0.5 },
		cost      = 6,
		can_use = function(self, card)
			return card.ability.val > 0
		end,
		use = function(self, card, area, copier)
			-- do more with this
			for i=1, card.ability.val do Madcap.Funcs.ease_mayhem(card.ability.extra, i==card.ability.val) end
		end,
		loc_vars  = function(self, info_queue, card)
			local val, max = Madcap.Funcs.get_progress_bar(card.ability.partial_rounds, 	card.ability.upgrade_rounds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
		end,
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
