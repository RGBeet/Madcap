if JokerDisplay then

    local jod = JokerDisplay.Definitions
    tell("LOADING JOKERDISPLAY VALUES FOR MADCAP")

    jod['j_rgmc_vari_seala'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
            { text = " Seals" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        text_config     = { colour = G.C.WHITE },
        extra_config    = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            -- Loop throgh cards
            local count =  0
            if G.play then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v.seal; end) end
                else
                count = 0
            end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'vari_seala', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_bball_pasta'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT }
        },
        extra = {
            {
                { text = "( +", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") +", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chip_mod", colour = G.C.CHIPS },
                { text = " +", colour = G.C.MULT },
                { ref_table = "card.joker_display_values", ref_value = "mult_mod",  colour = G.C.MULT }
            }
        },
        text_config     = { colour = G.C.WHITE },
        extra_config    = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local numerator, denominator        = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bball_pasta')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
		    card.joker_display_values.chips         = card.ability.extra.chips
		    card.joker_display_values.mult          = card.ability.extra.mult
		    card.joker_display_values.chip_nod      = card.ability.extra.chip_mod
		    card.joker_display_values.mult_mod      = card.ability.extra.mult_mod
        end
    }

    jod['j_rgmc_joker_squared'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            local mult = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                MadLib.loop_func(scoring_hand, function(v)
                    if MadLib.list_matches_one(MadLib.RankTypes['Square'], function(c)
                        return MadLib.is_rank(v, SMODS.Ranks[c].id) 
                    end) then
                        mult = MadLib.multiply(card.ability.extra.mult, JokerDisplay.calculate_card_triggers(v, scoring_hand))
                    end
                end)
            end
            card.joker_display_values.mult = mult
            card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",4,9)"
        end,
    }

    jod['j_rgmc_spectator'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local mult = 0
            local hand = G.hand.highlighted
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                mult = MadLib.multiply(card.ability.extra.mult, (#hand - #scoring_hand))
            end
            card.joker_display_values.mult = mult
        end,
    }

    jod['j_rgmc_neighborhood_watch'] = {
        text = {
            { text = "+$" },
            { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "dollars" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local dollars_held = 0
            MadLib.loop_func(G.hand.cards, function(v)
                if 
                    v.highlighted 
                    or not (MadLib.is_rank(v, G.GAME.current_round and G.GAME.current_round.rgmc_edwin_card.id or 5)
                    and v:is_suit(G.GAME.current_round and G.GAME.current_round.rgmc_edwin_card.suit or 'Diamonds'))
                then
                    return
                end
                dollars_held = dollars_held + 1
            end)
            card.joker_display_values.dollars = MadLib.multiply(dollars_held, 
                card.ability.extra.money_mod)
        end,
    }

    jod['j_rgmc_penrose_stairs'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
            { text = " Cards" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        text_config     = { colour = G.C.WHITE },
        extra_config    = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            -- Loop throgh cards
            local count =  0
            if G.play then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return not v:is_rankless(); end) end
                else
                count = 0
            end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'penrose_stairs', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_bball_pasta'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        },
        text_config     = { colour = G.C.WHITE },
        calc_function   = function(card)
            local numerator, denominator        = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bball_pasta')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
		    card.joker_display_values.chips         = card.ability.extra.chips
		    card.joker_display_values.mult          = card.ability.extra.mult
		    card.joker_display_values.chip_nod      = card.ability.extra.chip_mod
		    card.joker_display_values.mult_mod      = card.ability.extra.mult_mod
        end
    }
end