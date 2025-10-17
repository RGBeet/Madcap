
return {
    categories = {
        'Colour Cards',
        'Editions'
    },
    data = {
        object_type = 'Consumable',
		set 	= "Colour",
		atlas 	= "mf_colours",
        pos 	= MLIB.coords(1,1),
		key       = "torch_red",
		cost      = 5,
		config    = { val = 0, partial_rounds = 0, upgrade_rounds = 1, },
		loc_vars  = Madcap.Funcs.get_colour_loc_vars(self, info_queue, card),
		can_use = function(self, card)
			return #G.hand.cards > 1 and card.ability.val > 0
		end,
		use = function(self, card, area, copier)
			for i=1, card.ability.val do
				MadLib.simple_event(function()
					local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v)
						return not v.edition
					end) or {}
					local backup_pool = MadLib.get_list_matches(G.hand.cards, function(v)
						return v.edition and not v.edition['rgmc_infernal']
					end) or {}

					local pool = (#temp_pool > 0 and temp_pool) or (#backup_pool > 0 and backup_pool)
					if pool then
						local eligible_card = pseudorandom_element(pool, pseudoseed(self.config.key))
						if SMODS.pseudorandom_probability(card, 'mf_torch_red', 1, card.ability.extra.odds) then
							eligible_card:set_edition({ ['rgmc_infernal'] = true }, true)
							check_for_unlock({type = 'have_edition'})
						else
							eligible_card:start_dissolve({G.C.RED}, nil, 1.6) -- roll failed...
						end
						card:juice_up(0.3, 0.5)
					end
					return true
				end, 0.4, 'after')
			end
		end,
		loc_vars  = function(self, info_queue, card)
			local val, max = Madcap.Funcs.get_progress_bar(card.ability.partial_rounds, 	card.ability.upgrade_rounds)
			return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
		end,
		display_size 	= { w = 71, h = 87 },
		pixel_size 		= { w = 71, h = 87 },
    }
}
