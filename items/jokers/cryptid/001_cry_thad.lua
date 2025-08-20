if Cryptid then
    function Madcap.Funcs.get_demicolon_ui(card)
        return (card.area and card.area == G.jokers) and
        {
            {
                n = G.UIT.C,
                config = { align = "bm", minh = 0.4 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            ref_table = card,
                            align = "m",
                            -- colour = (check and G.C.cry_epic or G.C.JOKER_GREY),
                            colour = card.ability.colour,
                            r = 0.05,
                            padding = 0.08,
                            func = "blueprint_compat",
                        },
                        nodes = {
                            {
                                n = G.UIT.T,
                                config = {
                                    ref_table = card.ability,
                                    ref_value = "demicoloncompat",
                                    colour = G.C.UI.TEXT_LIGHT,
                                    scale = 0.32 * 0.8,
                                },
                            },
                        },
                    },
                },
            },
        }
    end

    function Madcap.Funcs.get_demicolon_update(self, card, front)
        local other_joker = nil
        if G.STAGE ~= G.STAGES.RUN then return nil end
        if G.jokers.cards[1] ~= card then other_joker = G.jokers.cards[1] end

        local m = Cryptid.demicolonGetTriggerable(other_joker)
        if m[1] and not m[2] then
            card.ability.demicoloncompat = "Compatible"
            card.ability.check = true
            card.ability.colour = G.C.GREEN
        elseif m[2] then
            card.ability.demicoloncompat = "Dangerous!"
            card.ability.check = true
            card.ability.colour = G.C.MULT
        else
            card.ability.demicoloncompat = "Incompatable"
            card.ability.check = false
            card.ability.colour = G.C.BLACK
        end
    end
end

return {
    categories = {
        'Demicolon',
        'Unusual'
    },
    data = {
        object_type = "Joker",
        key = 'cry_thad',
		atlas = 'jokers_cryptid',
        pos = MLIB.coords(0,0),
		rarity = 'rgmc_unusual',
		generate_ui = Madcap.Funcs.generate_special_ui,
		long_title = { "The Demicolon Chad" },
		cost = 21,
		config = { extra = { retriggers = 1 }, immutable = { max_retriggers = 25 }, },
		blueprint_compat = false,
		demicoloncompat = true,
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
				-- the chad part
				if G.jokers.cards[1] ~= card and Cryptid.demicolonGetTriggerable(G.jokers.cards[1])[1] then
					local me = card
					return {
						message = localize("k_again_ex"),
						repetitions = to_number(
							math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers)
						),
						card = me,
					}
				else
					return nil, true
				end
			end
			-- the demicolon part
			if ((context.joker_main and not context.blueprint) or context.forcetrigger) and G.jokers.cards[1] ~= card then
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
    }
}
