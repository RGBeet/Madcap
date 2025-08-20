return {
    categories = {
        'Demicolon',
        'Unusual'
    },
    data = {
        object_type = "Joker",
        key = 'cry_demivas',
		atlas = 'jokers_cryptid',
        pos = MLIB.coords(0,1),
		rarity = 'cry_Epic',
		generate_ui = Madcap.Funcs.generate_special_ui,
		long_title = { "The Demicolon Canvas" },
		cost = 21,
		config = { immutable = { min_rarity = 'rgmc_unusual', max_retriggers = 20, current_retriggers 	= 0, target_list = {} }, },
		loc_vars = function(self, info_queue, card)
			card.ability.demicoloncompat_ui = card.ability.demicoloncompat_ui or ""
			card.ability.demicoloncompat_ui_check = nil
			local check = card.ability.check
			return {
				vars = { math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers) },
				main_end = (card.area and card.area == G.jokers)
                    and Madcap.Funcs.get_demicolon_ui(card)
                    or nil,
			}
		end,
		atlas = 'jokers_cryptid',
		update = function(self, card, front)
		end,
		calculate = function(self, card, context)
			if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
				local num_retriggers = 0
				for i = 1, #G.jokers.cards do
					if
						card.T.x + card.T.w / 2 < G.jokers.cards[i].T.x + G.jokers.cards[i].T.w / 2
						and G.jokers.cards[i].config.center.rarity ~= 1
						and (G.jokers.cards[i].config.center.rarity ~= "cry_candy" or Card.get_gameset(card) ~= "modest")
					then
						num_retriggers = num_retriggers + 1
					end
				end
				if
					context.other_card
					and context.other_card ~= card
					and Cryptid.demicolonGetTriggerable(card)[1]
				then -- retrigger self if
					return {
						message = localize("k_again_ex"),
						repetitions = to_number(
							math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers)
						),
						card = card,
						func = function()
							local results = Cryptid.forcetrigger(G.jokers.cards[1], context)
							if results and results.jokers then
								results.jokers.message = localize("cry_demicolon")
								results.jokers.colour = G.C.RARITY.cry_epic
								results.jokers.sound = "cry_demitrigger"
								return results.jokers
							end
							return {
								message = localize("cry_demicolon"),
								colour = G.C.RARITY.cry_epic,
								sound = "cry_demitrigger",
							}
						end
					}
				else
					return nil, true
				end
			end
			-- the demicolon part
			if
				((context.joker_main and not context.blueprint) or context.forcetrigger)
				and G.jokers.cards[1] ~= card
			then
				if Cryptid.demicolonGetTriggerable(G.jokers.cards[1])[1] then
					local results = Cryptid.forcetrigger(G.jokers.cards[1], context)
					if results and results.jokers then
						results.jokers.message = localize("cry_demicolon")
						results.jokers.colour = G.C.RARITY.cry_epic
						results.jokers.sound = "cry_demitrigger"
						return results.jokers
					end
					return {
						message = localize("cry_demicolon"),
						colour = G.C.RARITY.cry_epic,
						sound = "cry_demitrigger",
					}
				end
			end
		end,
		blueprint_compat  = false, -- for now?
		demicoloncompat   = true,
    }
}
