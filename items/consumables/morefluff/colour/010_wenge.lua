return {
    categories = {
        'Colour Cards',
    },
    data = {
        object_type = 'Consumable',
		set 	= "Colour",
		atlas 	= "mf_colours",
        pos 	= MLIB.coords(2,1),
		key       = "wenge",
		config    = { val = 0, partial_rounds = 0, upgrade_rounds = 3, extra = 30 },
		cost      = 6,
		can_use = function(self, card)
			return card.ability.val > 0
		end,
		use = function(self, card, area, copier)
			local v = pseudorandom_element(G.hand and G.hand.cards or {}, pseudoseed('wenge'))
			MadLib.event({ func = function()
				v.ability.perma_bonus = v.ability.perma_bonus + (card.ability.val * card.ability.extra)
				v:juice_up(0.5, 0.5)
				return true
			end })
		end,
		loc_vars  = function(self, info_queue, card)
			local val, max = Madcap.Funcs.get_progress_bar(card.ability.partial_rounds, 	card.ability.upgrade_rounds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds, card.ability.extra, card.ability.extra * card.ability.val)
		end,
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
