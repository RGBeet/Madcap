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
            local numerator, denominator        = MadLib.JokerDisplay.get_stacked_probabilities(card, 'vari_seala', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_xray_vision'] = {
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config    = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local numerator, denominator        = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'xray_vision')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_weighted_die'] = {
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config    = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local numerator, denominator        = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'weighted_die')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_captain_viridian'] = {
        text = {
            { text = "x" },
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
            if next(G.play.cards) then return end
            local count                 = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then 
                local matches = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) 
                    return not (v.edition and v.edition.flipped) 
                end)
                count = matches
            end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'captain_viridian', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_thorium_joker'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
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
                    if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                        local new_rank = Madcap.ThoriumJokerConversions[tostring(context.other_card:get_id())]
                        return new_rank;
                    end) end
                else
                count = 0
            end
            card.joker_display_values.count     = count
            local numerator, denominator        = MadLib.JokerDisplay.get_stacked_probabilities(card, 'thorium_joker', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_primordial_joker'] = {
        text = {
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT }
        },
        calc_function   = function(card)
            card.joker_display_values.mult = MadLib.multiply(card.ability.extra.mult, (G.GAME and G.GAME.mayhem or 0))
        end
    }

    jod['j_rgmc_bball_pasta'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT }
        },
        reminder_text = {
            { text = "(", colour = G.C.INACTIVE },
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "chip_mod", colour = G.C.CHIPS },
            { text = ", ", colour = G.C.INACTIVE },
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "mult_mod",  colour = G.C.MULT },
            { text = ")", colour = G.C.INACTIVE },
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") " },
            }
        },
        text_config     = { colour = G.C.WHITE },
        extra_config    = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local numerator, denominator            = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bball_pasta')
            card.joker_display_values.odds          = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
		    card.joker_display_values.chips         = card.ability.extra.chips
		    card.joker_display_values.mult          = card.ability.extra.mult
		    card.joker_display_values.chip_nod      = card.ability.extra.chip_mod
		    card.joker_display_values.mult_mod      = card.ability.extra.mult_mod
        end
    }

    jod['j_rgmc_golden_house'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT }
        },
        text_config     = { colour = G.C.WHITE },
        calc_function   = function(card)
		    card.joker_display_values.chips         = card.ability.extra.chips
		    card.joker_display_values.mult          = card.ability.extra.mult
        end
    }

    jod['j_rgmc_spam'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") " },
            }
        },
        text_config     = { colour = G.C.WHITE },
        extra_config    = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local numerator, denominator            = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'spam')
            card.joker_display_values.odds          = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
		    card.joker_display_values.chips         = card.ability.extra.chips
		    card.joker_display_values.mult          = card.ability.extra.mult
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
                mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return MadLib.list_matches_one(MadLib.RankTypes['Square'], function(c)
                        return MadLib.is_rank(v, SMODS.Ranks[c].id)
                    end)
                end), card.ability.extra.mult)
            end
            card.joker_display_values.mult = mult
            card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",4,9)"
        end,
    }

    jod['j_rgmc_pentagon'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            local chips = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                chips = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return MadLib.list_matches_one(Madcap.Lists.PentagonalNumbers, function(c)
                        return MadLib.is_rank(v, SMODS.Ranks[c].id)
                    end)
                end), card.ability.extra.chips)
            end
            card.joker_display_values.chips = chips
            card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",5," .. localize("Queen", "ranks") .. ")"
        end,
    }

    jod['j_rgmc_ball_breaker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
        },
        extra = {
            { { ref_table = "card.joker_display_values", ref_value = "active_text", scale = 0.3 } }
        },
        text_config     = { colour = G.C.CHIPS },
        extra_config    = { colour = G.C.CHIPS },
        reminder_text   = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            local all_fibs                              = MadLib.list_matches_all(G.hand.highlighted, function(v) return MadLib.has_fib_rank(v) end)
            card.joker_display_values.active_text       = all_fibs and ("+" .. number_format(card.ability.extra.chips)) or ''
            card.joker_display_values.localized_text    = "(" .. localize("Ace", "ranks") .. ",2,3,5,8)"
        end,
    }

    jod['j_rgmc_spectator'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            if G.STATE ~= G.STATES.HAND_PLAYED then
                local mult = 0
                local hand = G.hand.highlighted
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                if text ~= 'Unknown' then
                    local available = not (G.STATE == G.STATES.DRAW_TO_HAND)
                    if G.play and #G.play.cards > 0 then
                        mult = lenient_bignum(card.ability.extra.mult)
                    elseif available then
                        local num = math.max(#hand, #scoring_hand) - math.min(#hand, #scoring_hand)
                        mult = MadLib.multiply(card.ability.extra.mult_mod, num)
                    else
                        mult = 0
                    end
                end
                card.joker_display_values.mult = mult
            end
        end,
    }

    jod['j_rgmc_neighborhood_watch'] = {
        text = {
            { text = "+$" },
            { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "dollars" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "edwin_card", colour = G.C.ORANGE },
            { text = ")" },
        },
        text_config = { colour = G.C.MONEY },
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
            card.joker_display_values.dollars = MadLib.multiply(dollars_held, card.ability.extra.money_mod)
            card.joker_display_values.edwin_card = localize { type = 'variable', key = "jdis_rank_of_suit", vars = { localize(G.GAME.current_round.rgmc_edwin_card.rank, 'ranks'), localize(G.GAME.current_round.rgmc_edwin_card.suit, 'suits_plural') } }
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[2] then
                reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.current_round.rgmc_edwin_card.suit], 0.35)
            end
            return false
        end
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

    jod['j_rgmc_lady_liberty'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
            { text = " Patina" }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            card.joker_display_values.count = card.ability.extra.seals or 1
            card.joker_display_values.active_text = localize(G.GAME.current_round.hands_played == 0 and 'k_active_ex' or 'rgmc_inactive')
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] then
                reminder_text.children[1].config.colour     = (G.GAME.current_round.hands_played == 0 and G.C.GREEN or G.C.RED)
                reminder_text.children[1].config.scale      = 0.3
                return true
            end
            return false
        end
    }

    jod['j_rgmc_liberty_bell'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
            { text = " Cuprum" }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            card.joker_display_values.count = card.ability.extra.seals or 1
            card.joker_display_values.active_text = localize(G.GAME.current_round.discards_used == 0 and 'k_active_ex' or 'rgmc_inactive')
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] then
                reminder_text.children[1].config.colour     = (G.GAME.current_round.discards_used == 0 and G.C.GREEN or G.C.RED)
                reminder_text.children[1].config.scale      = 0.3
                return true
            end
            return false
        end
    }

    jod['j_rgmc_house_of_cards'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        },
        calc_function = function(card)
            if G.STATE == G.STATES.HAND_PLAYED then return end
            local numerator, denominator        = SMODS.get_probability_vars(card, MadLib.add(1, card.ability.immutable.increase), card.ability.immutable.odds, 'house_of_cards')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.chips     = MadLib.add(card.ability.extra.chips, card.ability.extra.chip_mod)
        end,
    }

    jod['j_rgmc_glass_michel'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'gros_michel')
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            local count = 0
            if G.hand then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return SMODS.has_enhancement(v, 'm_glass') end) end
                else
                count = 0
            end
            card.joker_display_values.count = count
        end,
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand then return 0 end
            return SMODS.has_enhancement(playing_card, 'm_glass') and
                1 * JokerDisplay.calculate_joker_triggers(joker_card) or 0 --??
        end
    }

    jod['j_rgmc_balutro'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local count = 0
            card.joker_display_values.count = count
        end,
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            return MadLib.list_matches_all(scoring_hand, function(v)
                return MadLib.has_rank_in_list(v, Madcap.BalutroList)
            end) 
                and JokerDisplay.calculate_joker_triggers(joker_card)    
                or 0
        end
    }

    jod['j_rgmc_jestrogen'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local count = 0
            card.joker_display_values.count = count
        end,
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand or not SMODS.in_scoring(playing_card, scoring_hand) then return 0 end
            local _, poker_hands, _ = JokerDisplay.evaluate_hand()
            local flush     = poker_hands[card.ability.extra.poker_hands[1] or 'Flush']
            local spectrum  = poker_hands[card.ability.extra.poker_hands[2] or  Madcap.Funcs.get_spectrum()]
            if 
                (flush or spectrum) 
                and MadLib.is_rank(playing_card, SMODS.Ranks[card.ability.extra.rank].id)
            then
                return MadLib.multiply(joker_card.ability.extra.repetitions, JokerDisplay.calculate_joker_triggers(joker_card))
            end
            return 0
        end
    }

    jod['j_rgmc_pogladontasaurus'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rank" },
            { text = ")" },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local count = 0
            card.joker_display_values.rank      = localize(card.ability.extra.rank, "ranks")
        end,
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if not held_in_hand then return 0 end
            if MadLib.is_rank(playing_card, SMODS.Ranks[card.ability.extra.rank].id) then
                local repetitions = MadLib.maximum(joker_card.ability.extra.repetitions, joker_card.ability.extra.max_repetitions)
                return MadLib.multiply(joker_card.ability.extra.repetitions, JokerDisplay.calculate_joker_triggers(joker_card))
            end
            return 0
        end
    }

    jod['j_rgmc_metallurgist'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rank" },
            { text = ")" },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local count = 0
            card.joker_display_values.rank      = localize(card.ability.extra.rank, "ranks")
        end,
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            local pass = (playing_card.area == G.hand and MadLib.has_enhancement_in_list(playing_card, Madcap.Metals.held))
                or (playing_card.area == G.play and MadLib.has_enhancement_in_list(playing_card, Madcap.Metals.score))
            if pass then
                local repetitions = MadLib.maximum(joker_card.ability.extra.repetitions, joker_card.ability.extra.max_repetitions)
                return MadLib.multiply(joker_card.ability.extra.repetitions, JokerDisplay.calculate_joker_triggers(joker_card))
            end
            return 0
        end
    }

    jod['j_rgmc_chinese_takeout'] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "prefix" },
            { ref_table = "card.joker_display_values", ref_value = "value" },
            { text = " " },
            { ref_table = "card.joker_display_values", ref_value = "suffix" },
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rounds" },
            { text = "/" },
            { ref_table = "card.joker_display_values", ref_value = "max_rounds" },
            { text = ")" },
        },
        calc_function = function(card)
            local j = card.ability.immutable.mode
            local suffix = (j == 1 or j == 3 or j == 5) and "Chips" or (j < 8) and "Mult" or "Score"
            local prefix = (j < 6) and "+" or "X"
            card.joker_display_values.rounds        = card.ability.extra.rounds
            card.joker_display_values.max_rounds    = card.ability.extra.max_rounds
            card.joker_display_values.value         = card.ability.extra.effects[card.ability.immutable.mode]
            card.joker_display_values.suffix        = suffix
            card.joker_display_values.prefix        = prefix
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children then
                local j = card.ability.immutable.mode
                local c = (j == 1 or j == 3 or j == 5) and G.C.BLUE or (j < 8) and G.C.RED or G.C.PURPLE
                for i=1,#text.children do text.children[i].config.colour = c end
            end
            if reminder_text and reminder_text.children then
                local w = MadLib.get_warning_colour(card.ability.extra.rounds / card.ability.extra.max_rounds)
                for i=1,#reminder_text.children do reminder_text.children[i].config.colour = w end
            end
            return false
        end
    }

    jod['j_rgmc_radioactive_chinese'] = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rounds" },
            { text = "/" },
            { ref_table = "card.joker_display_values", ref_value = "max_rounds" },
            { text = ")" },
        },
        calc_function = function(card)
            card.joker_display_values.rounds        = card.ability.extra.rounds
            card.joker_display_values.max_rounds    = card.ability.extra.max_rounds
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children then
                local j = card.ability.immutable.mode
                local c = (j == 1 or j == 3 or j == 5) and G.C.BLUE or (j < 8) and G.C.RED or G.C.PURPLE
                for i=1,#text.children do text.children[i].config.colour = c end
            end
            if reminder_text and reminder_text.children then
                local w = MadLib.get_warning_colour(card.ability.extra.rounds / card.ability.extra.max_rounds)
                for i=1,#reminder_text.children do reminder_text.children[i].config.colour = w end
            end
            return false
        end
    }

    jod['j_rgmc_quick_brown_fox'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        calc_function = function(card)
            card.joker_display_values.chips = MadLib.multiply((G.GAME and G.GAME.ante.unique_ranks or 0), card.ability.extra.chips)
        end,
    }

    jod['j_rgmc_easter_egg'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "value" },
        },
        reminder_text = {
            { text = "(+" },
            { ref_table = "card.joker_display_values", ref_value = "value_mod" },
            { text = ")" },
        },
        text_config = { colour = G.C.RGMC_BISMUTH },
        calc_function = function(card)
            card.joker_display_values.value         = card.ability.extra.value
            card.joker_display_values.value_mod     = card.ability.extra.value_mod
        end,
    }

    jod['j_rgmc_null_and_void'] = {
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            local self_index    = MadLib.get_item_index(card, G.jokers.cards)
            local end_point     = math.min(self_index + (card.ability.extra.cards_to_debuff or 1), #G.jokers.cards)
            local active = false
            for i=1,#G.jokers.cards do
                local v = G.jokers.cards[i]
                local debuffed = v.ability.debuff_sources and v.ability.debuff_sources['rgmc_null_and_void']
                if (i < self_index or i > end_point) and not debuffed then
                    active = true
                    break
                end
            end
            card.joker_display_values.active_text = localize(not active and 'k_active_ex' or 'rgmc_inactive')
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] then
                reminder_text.children[1].config.colour     = card.joker_display_values.active and G.C.GREEN or G.C.RED
                reminder_text.children[1].config.scale      = 0.3
                return true
            end
            return false
        end
    }

    jod['j_rgmc_pretentious_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE },
        },
        calc_function = function(card)
            local mult = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit) end), card.ability.extra.mult) end
            card.joker_display_values.mult              = mult
            card.joker_display_values.localized_text    = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_deceitful_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE },
        },
        calc_function = function(card)
            local mult = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit) end), card.ability.extra.mult) end
            card.joker_display_values.mult              = mult
            card.joker_display_values.localized_text    = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_voracious_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE },
        },
        calc_function = function(card)
            local mult = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit) end), card.ability.extra.mult) end
            card.joker_display_values.mult              = mult
            card.joker_display_values.localized_text    = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_arrogant_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE },
        },
        calc_function = function(card)
            local mult = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit) end), card.ability.extra.mult) end
            card.joker_display_values.mult              = mult
            card.joker_display_values.localized_text    = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_barbershop_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            {
                ref_table = "card.joker_display_values",
                ref_value = "localized_text",
            },
            { text = ")" },
        },
        calc_function = function(card)
            if next(G.play.cards) then return end -- currently playing hand
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local suit = G.GAME.current_round
                and G.GAME.current_round.rgmc_barbershop
                and G.GAME.current_round.rgmc_barbershop.suit
                or 'Spades'
            local mult = 0
            if text ~= 'Unknown' then
                mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return v:is_suit(suit)
                end), card.ability.extra.mult)
            end
            card.joker_display_values.mult              = mult
            card.joker_display_values.localized_text    = localize(suit, 'suits_plural')
        end
    }

    jod['j_rgmc_joker_in_binary'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local suit = G.GAME.current_round
                and G.GAME.current_round.rgmc_barbershop
                and G.GAME.current_round.rgmc_barbershop.suit
                or 'Spades'
            local chips = 0
            if text ~= 'Unknown' then
                MadLib.loop_func(scoring_hand, function(v)
                    if not (MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.ranks[1]].id)
                    or MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.ranks[2]].id)) then return end
                    chips = MadLib.add(chips, card.ability.extra.chips)
                end)
            end
            card.joker_display_values.chips     = chips
            local rank1     = localize(card.ability.extra.ranks[1], 'ranks')
            local rank2     = localize(card.ability.extra.ranks[2], 'ranks')
            card.joker_display_values.localized_text = "(" .. rank1 .. ", " .. rank2 .. ")"
        end
    }

    jod['j_rgmc_sticker_shock'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        calc_function = function(card)
            card.joker_display_values.chips = MadLib.multiply(card.ability.extra.chips, MadLib.get_card_stickers())
        end
    }
    
    jod['j_rgmc_bolstered_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
            { text = ")" },
        },
        calc_function = function(card)
            local mult = 0
            local _, poker_hands, _ = JokerDisplay.evaluate_hand()
            if poker_hands[card.ability.type] and next(poker_hands[card.ability.extra.poker_hand]) then
                mult = card.ability.t_mult
            end
            card.joker_display_values.mult = mult
            card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
        end
    }

    jod['j_rgmc_fortified_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
            { text = ")" },
        },
        calc_function = function(card)
            local chips = 0
            local _, poker_hands, _ = JokerDisplay.evaluate_hand()
            if poker_hands[card.ability.type] and next(poker_hands[card.ability.extra.poker_hand]) then
                chips = card.ability.t_chips
            end
            card.joker_display_values.chips = chips
            card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
        end
    }

    jod['j_rgmc_cup_of_joeker'] = {
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            card.joker_display_values.active_text   = localize(G.GAME.current_round.hands_played == 0 and 'k_active' or 'k_inactive')
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] then
                reminder_text.children[1].config.colour     = card.joker_display_values.active and G.C.GREEN or G.C.RED
                reminder_text.children[1].config.scale      = 0.3
                return true
            end
            return false
        end
    }

    jod['j_rgmc_supreme_with_cheese'] = {
        text = {
            {
                border_nodes = {
                    { text = "X", colour = G.C.WHITE  },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp", colour = G.C.WHITE }
                }
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "rounds" },
            { text = "/" },
            { ref_table = "card.ability.immutable", ref_value = "max_rounds" },
            { text = ")" },
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local playing_hand = next(G.play.cards)
            if playing_hand then return end
            card.joker_display_values.x_mult   = (G.GAME.current_round.hands_played == 0 and card.ability.extra.x_mult) or 1
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children then
                local w = MadLib.get_warning_colour(card.ability.extra.rounds / card.ability.immutable.max_rounds)
                for i=1,#reminder_text.children do reminder_text.children[i].config.colour = w end
            end
            return false
        end
    }

    jod['j_rgmc_bluenana'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_chips", retrigger_type = "exp" }
                },
                border_colour = G.C.CHIPS
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local numerator, denominator    = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bluenana')
            numerator = MadLib.add(numerator, card.ability.numer_factor or 0)
            card.joker_display_values.odds  = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_redd_dacca'] = {
        text = {
            {
                border_nodes = {
                    { text = "^" },
                    { ref_table = "card.ability.extra", ref_value = "e_mult", retrigger_type = "exp" }
                },
                border_colour = G.C.DARK_EDITION
            }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'redd_dacca', true)
            numerator = MadLib.add(numerator, card.ability.numer_factor or 0)
            card.joker_display_values.odds  = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgmc_lobster_thermidor'] = {
        text = {
            {
                border_nodes = {
                    { text = "^" },
                    { ref_table = "card.joker_display_values", ref_value = "extra", retrigger_type = "exp" }
                },
                border_colour = G.C.DARK_EDITION
            }
        },
        calc_function = function(card)
            card.joker_display_values.extra = (1+card.ability.extra.emult) * card.ability.extra.extra
        end
    }
    
    jod['j_rgmc_chicken_jokey'] = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "active" },
            { text = ")" },
        },
        calc_function = function(card)
            card.joker_display_values.active = card.ability.extra.rounds .. "/" .. card.ability.extra.max_rounds
        end
    }

    jod['j_rgmc_talking_bacteria_jim'] = {
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'talking_bacteria_jim', true)
            card.joker_display_values.odds  = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }
    
    jod['j_rgmc_egglike_joker'] = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "active" },
            { text = ")" },
        },
        calc_function = function(card)
            card.joker_display_values.active = card.ability.extra.rounds .. "/" .. card.ability.extra.max_rounds
        end
    }

    jod['j_rgmc_changing_had'] = {
        reminder_text = {
            { text = "(Pos. #" },
            { ref_table = "card.ability.immutable", ref_value = "position", colour = G.C.ATTENTION },
            { text = ")" },
        },
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand then return 0 end
            local positioned = scoring_hand and MadLib.JokerDisplay.calculate_card_position(scoring_hand)
            return positioned and playing_card == positioned and
                joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
        end,
    }

    jod['j_rgmc_iron_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult" },
        },
        calc_function   = function(card)
            card.joker_display_values.chips = MadLib.multiply(card.ability.extra.chips, #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement))
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children then
                local w = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement) > 0 and G.C.MULT or G.C.INACTIVE
                for i=1,#reminder_text.children do reminder_text.children[i].config.colour = w end
            end
            return false
        end
    }

    jod['j_rgmc_tungsten_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
        },
        calc_function   = function(card)
            card.joker_display_values.mult = MadLib.multiply(card.ability.extra.mult, #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement))
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children then
                local w = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement) > 0 and G.C.MULT or G.C.INACTIVE
                for i=1,#reminder_text.children do reminder_text.children[i].config.colour = w end
            end
            return false
        end
    }

    jod['j_rgmc_jeweler_joker'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
                }
            }
        },
        calc_function   = function(card)
            card.joker_display_values.mult = MadLib.multiply(card.ability.extra.x_mult, #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement))
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children then
                local w = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement) > 0 and G.C.MULT or G.C.INACTIVE
                for i=1,#reminder_text.children do reminder_text.children[i].config.colour = w end
            end
            return false
        end
    }

    jod['j_rgmc_plentiful_ametrine'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") " },
                { text = "+", colour = G.C.MULT},
                { ref_table = "card.ability.extra", ref_value = "mult_mod", colour = G.C.MULT },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            if next(G.play.cards) then return end
            local count =  0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit); end) end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'plentiful_ametrine', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_toughened_shungite'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") " },
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chip_mod", colour = G.C.CHIPS },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            if next(G.play.cards) then return end
            local count =  0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit); end) end
            card.joker_display_values.count     = count
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'fortified_shungite', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_vibrant_tourmaline'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "money" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") " },
                { text = "+", colour = G.C.MONEY},
                { ref_table = "card.ability.extra", ref_value = "money_mod", colour = G.C.MONEY },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            if next(G.play.cards) then return end
            local count =  0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit); end) end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'vibrant_tourmaline', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_obsidian_blade'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "x_mult" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.RED, 0.35) },
            { text = ")" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") " },
                { text = "+", colour = G.C.MONEY},
                { ref_table = "card.ability.extra", ref_value = "xmult_mod", colour = G.C.MONEY },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            if next(G.play.cards) then return end
            local count =  0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit(card.ability.extra.suit); end) end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'j_rgmc_obsidian_blade', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_six_shooter'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rank" },
            { text = ")" },
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
                { text = " +", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chip_mod", colour = G.C.CHIPS },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local count = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return MadLib.is_rank(v, SMODS.Ranks['2'].id)
                end)
            end
            card.joker_display_values.count     = count
            local numerator, denominator        = MadLib.JokerDisplay.get_stacked_probabilities(card, 'six_shooter', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.rank      = localize(card.ability.extra.rank, "ranks")
        end
    }

    jod['j_rgmc_nope_joker'] = {
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "odds" },
        },
        calc_function = function(card)
            local numerator, denominator        = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'nope_joker')
            local odds2                         = MadLib.subtract(denominator, 0)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } } .. "(" .. number_format(odds2) .. ")"
        end
    }

    jod['j_rgmc_conspiracy_wizard'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
            { text = ", ", colour = G.C.INACTIVE },
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rank" },
            { text = " / " },
            { ref_table = "card.joker_display_values", ref_value = "suit" },
            { text = ")" },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local suit  = 0
            local rank  = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()

            local rank_text, suit_text = "??", "??"
            if text ~= 'Unknown' then
                if G.GAME.current_round.rgmc_wizard_card.rank_discovered then
                    rank = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                        return MadLib.is_rank(v, SMODS.Ranks[G.GAME.current_round.rgmc_wizard_card.rank].id)
                    end), card.ability.extra.chips)
                    rank_text = localize(G.GAME.current_round.rgmc_wizard_card.rank, "ranks")
                end
                if G.GAME.current_round.rgmc_wizard_card.suit_discovered then
                    suit = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                        return v:is_suit(G.GAME.current_round.rgmc_wizard_card.suit)
                    end), card.ability.extra.mult)
                    suit_text = localize(G.GAME.current_round.rgmc_wizard_card.suit, 'suits_plural')
                end
            end
            card.joker_display_values.chips     = rank
            card.joker_display_values.rank      = rank_text

            card.joker_display_values.mult      = suit
            card.joker_display_values.suit      = suit_text
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] and reminder_text.children[2] then
                if
                    G.GAME.current_round
                    and G.GAME.current_round.rgmc_wizard_card
                then
                    local w = G.GAME.current_round.rgmc_wizard_card
                    reminder_text.children[2].config.colour = w.rank_discovered and G.C.CHIPS or
                        G.C.UI.TEXT_INACTIVE
                    reminder_text.children[4].config.colour = w.suit_discovered and G.C.MULT or
                        G.C.UI.TEXT_INACTIVE
                end
            end
            return false
        end
    }

    jod['j_rgmc_cavalier'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_chips", retrigger_type = "exp", G.C.WHITE }
                }
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rank" },
            { text = ")" },
        },
        calc_function = function(card)
            local playing_hand = next(G.play.cards)
            local count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_hand or not playing_card.highlighted then
                    if 
                        not (playing_card.facing == 'back')
                        and not playing_card.debuff 
                        and MadLib.is_rank(playing_card, SMODS.Ranks['rgmc_Knight'].id)
                    then
                        count = MadLib.add(count, JokerDisplay.calculate_card_triggers(playing_card, nil, true))
                    end
                end
            end
            card.joker_display_values.x_chips   = MadLib.exponent(card.ability.extra.x_chips, count)
            card.joker_display_values.rank      = localize(card.ability.extra.rank, "ranks")
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.CHIPS
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_solar_eclipse'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_chips", retrigger_type = "exp", colour = G.C.WHITE }
                }
            }
        },
        calc_function = function(card)
            local playing_hand  = next(G.play.cards)
            local x_chips          = 1
            if playing_hand then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local subhands = MadLib.get_subhands(scoring_hand)
            if MadLib.list_has_string(subhands, 'ml_sh_light') then
                x_chips = card.ability.extra.x_chips
            end
            card.joker_display_values.x_chips   = number_format(x_chips)
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.CHIPS
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_lunar_eclipse'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp", colour = G.C.WHITE }
                }
            }
        },
        calc_function = function(card)
            local playing_hand  = next(G.play.cards)
            local x_mult          = 1
            if playing_hand then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local subhands = MadLib.get_subhands(scoring_hand)
            if MadLib.list_has_string(subhands, 'ml_sh_dark') then
                x_mult = card.ability.extra.x_mult
            end
            card.joker_display_values.x_mult   = number_format(x_mult)
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.MULT
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_penumbral'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp", colour = G.C.WHITE }
                }
            }
        },
        calc_function = function(card)
            local playing_hand    = next(G.play.cards)
            local x_mult          = 1
            if playing_hand then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local subhands = MadLib.get_subhands(scoring_hand)
            if MadLib.list_has_string(subhands, 'ml_sh_dark') then
                local num_suits = 0
                MadLib.loop_table(MadLib.get_suits_from_cards(scoring_hand), function(k,v)
                    if v < 1 then return end
                    num_suits = num_suits+1
                end)
                if num_suits>4 then
                    x_mult = card.ability.extra.x_mult
                end 
            end
            card.joker_display_values.x_mult   = number_format(x_mult)
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.MULT
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_photovoltaic'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp", colour = G.C.WHITE }
                }
            }
        },
        calc_function = function(card)
            local playing_hand    = next(G.play.cards)
            local x_mult          = 1
            if playing_hand then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local subhands = MadLib.get_subhands(scoring_hand)
            if MadLib.list_has_string(subhands, 'ml_sh_dark') then
                local num_suits = 0
                MadLib.loop_table(MadLib.get_suits_from_cards(scoring_hand), function(k,v)
                    if v < 1 then return end
                    num_suits = num_suits+1
                end)
                if num_suits>4 then
                    x_mult = card.ability.extra.x_mult
                end 
            end
            card.joker_display_values.x_mult   = number_format(x_mult)
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.MULT
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_palette'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_chips", retrigger_type = "exp", colour = G.C.WHITE }
                }
            }
        },
        calc_function = function(card)
            local playing_hand    = next(G.play.cards)
            local x_chips          = 1
            if playing_hand then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local subhands = MadLib.get_subhands(scoring_hand)
            if MadLib.get_unique_enhancements(G.hand.highlighted) then
                x_chips = card.ability.extra.x_chips
            end
            card.joker_display_values.x_chips   = number_format(x_chips)
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.CHIPS
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_sanguine'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp", G.C.WHITE }
                }
            }
        },
        calc_function = function(card)
            local playing_hand  = next(G.play.cards)
            local x_mult          = 1
           
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()

            -- Has both Daggers and Goblets
            if MadLib.list_matches_one(scoring_hand, function(v)
                return v:is_suit(card.ability.extra.suits[1])
            end) and MadLib.list_matches_one(scoring_hand, function(v)
                return v:is_suit(card.ability.extra.suits[2])
            end) then
                x_mult = card.ability.extra.x_mult
            end
            card.joker_display_values.x_mult = x_mult
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.MULT
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_stonebound'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        calc_function = function(card)
            local playing_hand  = next(G.play.cards)
            local chips          = 1
           
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()

            -- Has both Blooms and Towers
            if MadLib.list_matches_one(scoring_hand, function(v)
                return v:is_suit(card.ability.extra.suits[1])
            end) and MadLib.list_matches_one(scoring_hand, function(v)
                return v:is_suit(card.ability.extra.suits[2])
            end) then
                chips = card.ability.extra.x_mult
            end
            card.joker_display_values.chips = chips
        end,
    }

    jod['j_rgmc_outrageous_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local playing_hand  = next(G.play.cards)
            local mult          = 0
            if playing_hand then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local subhands = MadLib.get_subhands(scoring_hand)
            if MadLib.list_has_string(subhands, 'ml_sh_spectrum') then
                mult = card.ability.extra.mult
            end
            card.joker_display_values.mult   = number_format(mult)
        end,
    }

    jod['j_rgmc_arkose_michel'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        },
        calc_function = function(card)
            if not next(G.play.cards) then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local stones = MadLib.get_list_matches(scoring_hand, function(v) 
                    return SMODS.has_enhancement(v, 'm_stone') 
                end)
                local numerator, denominator    = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'arkose_michel')
                card.joker_display_values.mult  = MadLib.multiply(#stones, card.ability.extra.mult)
                card.joker_display_values.odds  = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            end
        end,
    }

    -- TODO: Add Clown detection
    jod['j_rgmc_catch_the_clown'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extras", ref_value = "chips", retrigger_type = "mult" }
        },
        extra = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "caught" },
            { text = " Wild" }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "caught" },
            { text = " " },
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "misses" },
            { text = ")" },
        },
        calc_function = function(card)
            if next(G.play.cards) then return end
            local _result = (card.ability.extra.caught and 'k_mission_in_progress')
                or (card.ability.extra.failed and 'k_mission_failed')
                or 'k_mission_in_progress'

            card.joker_display_values.caught = localize(_result)
            card.joker_display_values.misses = number_format(card.ability.extra.misses) .. "/" .. number_format(card.ability.extra.max_misses)
        end,
    }

    jod['j_rgmc_all_star_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extras", ref_value = "money", retrigger_type = "mult" }
        },
        extra = {
            { text = "+$" },
            { ref_table = "card.joker_display_values", ref_value = "money_mod" },
        },
        reminder_text = {
            { text = "(=24)" },
        },
        calc_function = function(card)
            if next(G.play.cards) then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local money_mod = 0
            if MadLib.get_hand_sum(scoring_hand) == card.ability.immutable.total_sum then
                for i=1,#G.jokers.cards do
                    money_mod = MadLib.multiply(money_mod, card.ability.extra.money_mod)

                end
            end
            card.joker_display_values.money_mod = money_mod
        end,
    }

    jod['j_rgmc_microfiche'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
                }
            }
        },
    }

    jod['j_rgmc_flamboyant_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        calc_function = function(card)
            local playing_hand  = next(G.play.cards)
            local chips         = 0
            if playing_hand then return end
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local subhands = MadLib.get_subhands(scoring_hand)
            if MadLib.list_has_string(subhands, 'ml_sh_spectrum') then
                chips = card.ability.extra.chips
            end
            card.joker_display_values.chips   = number_format(chips)
        end,
    }

    jod['j_rgmc_blindfold_joker'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
                }
            }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        calc_function = function(card)
            card.joker_display_values.active_text = localize(card.ability.extra.active and 'k_active' or 'ph_no_boss_active')
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] and card.joker_display_values then
                reminder_text.children[1].config.colour     = card.ability.extra.active and G.C.GREEN or G.C.RED
                reminder_text.children[1].config.scale      = card.ability.extra.active and 0.35 or 0.3
                return true
            end
            return false
        end,
    }

    -- Needs fixing
    jod['j_rgmc_sigma_joker'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_chips", retrigger_type = "exp" }
                }
            }
        },
        calc_function = function(card)
            local playing_hand = next(G.play.cards)
            card.joker_display_values.x_mult = playing_hand and MadLib.exponent(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                return MadLib.is_rank(v, SMODS.Ranks['rgmc_Sum'].id)
            end), card.ability.extra.x_chips) or 1
        end
    }

    jod['j_rgmc_venn_diagram'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.RED },
        calc_function = function(card)
            local count = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()

            if text ~= 'Unknown' then
                count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return not MadLib.has_suit_in_list(v, MadLib.SuitTypes.Base)
                        and not MadLib.has_rank_in_list(v, MadLib.RankTypes.Base)
                end)
            end
            card.joker_display_values.mult = MadLib.multiply(card.ability.extra.mult, count)
        end
    }

    jod['j_rgmc_continuum'] = {
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            card.joker_display_values.localized_text = "(" .. localize(card.ability.extra.rank or '8', "ranks") .. ")"
        end,
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            local c = 1
            local index, selection = 1, nil
            while
                index <= #scoring_hand   -- haven't gone through the whole thing
            do
                selection = scoring_hand[index]
                if selection == playing_card then break end
                c = c + 1
                index = (selection == playing_card) and (#scoring_hand + 1) or (index + 1)
            end
            return c
        end,
    }

    jod['j_rgmc_three_trees'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
                }
            }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        calc_function = function(card)
            local sorted_hand = MadLib.shuffle_sort_list(context.scoring_hand, #context.scoring_hand, function(v)
                return not Card:is_suitless()
            end, function(a,b)
                return MadLib.has_suit_in_list(a, MadLib.SuitTypes.Base, true)
            end)

            local num_suits = 0
            MadLib.loop_table(MadLib.get_suits_from_cards(sorted_hand), function(k,v)
                if v < 1 then return end
                num_suits = num_suits+1
            end)

            local dark_suit = MadLib.get_first_match_info(sorted_hand, function(v)
                return MadLib.has_suit_in_list(v, MadLib.SuitTypes.Dark, true)
            end, function(v)
                return v.base.suit
            end)

            local light_suit = MadLib.get_first_match_info(sorted_hand, function(v)
                return MadLib.has_suit_in_list(v, MadLib.SuitTypes.Light, true)
            end, function(v)
                return v.base.suit
            end)

            local modded_suit = MadcapConfig['Modded Suits'] and (MadLib.get_first_match_info(sorted_hand, function(v)
                return not MadLib.has_suit_in_list(v, MadLib.SuitTypes.Base, true)
                    and v.base.suit ~= dark_suit
                    and v.base.suit ~= light_suit
            end, function(v)
                return v.base.suit
            end)) or num_suits >= 3

            card.joker_display_values.active = dark_suit and light_suit and modded_suit
            card.joker_display_values.active_text = localize(active and 'k_active' or 'rgmc_inactive')
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] and card.joker_display_values then
                reminder_text.children[1].config.colour     = card.joker_display_values.active and G.C.GREEN or G.C.RED
                reminder_text.children[1].config.scale      = card.joker_display_values.active and 0.35 or 0.3
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_jimbos_funeral'] = {
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        calc_function = function(card)
            card.joker_display_values.active_text = card.ability.extra.active and localize("k_active_ex") or localize("rgmc_inactive")
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] and card.joker_display_values then
                reminder_text.children[1].config.colour     = card.joker_display_values.active and G.C.GREEN or G.C.RED
                reminder_text.children[1].config.scale      = card.joker_display_values.active and 0.35 or 0.3
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_shovel_joker'] = {
        text = {
            {
                border_nodes = {
                    { text = "X", colour = G.C.WHITE },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp", colour = G.C.WHITE }
                }
            }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text",  colour = G.C.ORANGE },
            { text = ")" },
        },
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local count = 0
            for _, playing_card in ipairs(scoring_hand) do
                if 
                    not (playing_card.facing == 'back') 
                    and not playing_card.debuff 
                    and MadLib.is_rank(playing_card, SMODS.Ranks['rgmc_Knight'].id)
                    and MadLib.has_suit_in_list(playing_card, MadLib.SuitTypes.Dark)
                then
                    count = MadLib.add(count, JokerDisplay.calculate_card_triggers(playing_card, nil, true))
                end
            end
            card.joker_display_values.x_mult = MadLib.exponent(card.ability.extra.x_mult, count)
            card.joker_display_values.localized_text = localize(card.ability.extra.rank or 'rgmc_Knight', "ranks")
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.MULT
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_rhodochrosite'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
            { text = ", ", colour = G.C.INACTIVE },
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "suit1", colour = G.C.ATTENTION },
            { text = ", " },
            { ref_table = "card.joker_display_values", ref_value = "suit2", colour = G.C.CHIPS },
            { text = ", " },
            { ref_table = "card.joker_display_values", ref_value = "suit3", colour = G.C.MULT },
            { text = ")" },
        },
        calc_function = function(card)
            local chips = 0
            local mult  = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            for i=2,#scoring_hand do
                local playing_card = scoring_hand[i]
                if playing_card:is_suit(card.ability.extra.suits[1] or 'Diamonds') then -- is a diamond
                    local other_card = scoring_hand[i-1]
                    if other_card:is_suit(card.ability.extra.suits[2] or 'Spades') then
                        mult = mult + card.ability.extra.mult
                    end
                    if other_card:is_suit(card.ability.extra.suits[3] or 'Clubs') then
                        chips = chips + card.ability.extra.chips
                    end
                end
            end
            card.joker_display_values.chips     = chips
            card.joker_display_values.mult      = mult
            card.joker_display_values.suit1     = localize(card.ability.extra.suits[1], "suits_plural")
            card.joker_display_values.suit2     = localize(card.ability.extra.suits[2], "suits_plural")
            card.joker_display_values.suit3     = localize(card.ability.extra.suits[3], "suits_plural")
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.CHIPS
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_waveworx'] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "poker_hand" },
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            card.joker_display_values.poker_hand = card.ability.extra.target_hand or '???'
            card.joker_display_values.active_text = localize(G.GAME.current_round.hands_played == 0 and 'k_active' or 'k_inactive')
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[1] then
                reminder_text.children[1].config.colour     = (G.GAME.current_round.hands_played == 0 and G.C.GREEN or G.C.RED)
                reminder_text.children[1].config.scale      = 0.3
                return true
            end
            return false
        end
    }

    jod['j_rgmc_miracle_pop'] = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
            { text = ", ", colour = G.C.INACTIVE },
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "suit1", colour = G.C.ATTENTION },
            { text = ", " },
            { ref_table = "card.joker_display_values", ref_value = "suit2", colour = G.C.MULT },
            { text = ")" },
        },
        extra = {
            {
                { text = "(", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chip_mod1", colour = G.C.CHIPS },
                { text = "/", colour = G.C.CHIPS },
                { ref_table = "card.joker_display_values", ref_value = "chip_mod2",  colour = G.C.CHIPS },
                { text = ")", colour = G.C.CHIPS },
            }
        },
        calc_function = function(card)
            card.joker_display_values.suit1         = localize(card.ability.extra.suits[1] or 'Hearts', "suits_plural")
            card.joker_display_values.suit2         = localize(card.ability.extra.suits[2] or 'Goblets', "suits_plural")
            card.joker_display_values.chip_mod1     = number_format(card.ability.extra.chip_mod)
            card.joker_display_values.chip_mod2     = number_format(MadLib.multiply(card.ability.extra.chip_mod,2))
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and card.joker_display_values then
                text.children[1].config.colour = G.C.CHIPS
                return true
            end
            return false
        end,
    }

    jod['j_rgmc_doom_bunny'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
            { text = " Wild" }
        },
        calc_function = function(card)
            if not next(G.play.cards) then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                local wilds = 0
                MadLib.loop_func(scoring_hand, function(v)
                    if not SMODS.has_enhancement(v, 'm_wild') then return end
                    wilds = wilds + 1
                end)
                card.joker_display_values.count = wilds
            end
        end,
    }

    jod['j_rgmc_rocket_keychain'] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "target_hand" },
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "most_played" },
            { text = ", " },
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "level_ups" },
            { text = ")" },
        },
        calc_function = function(card)
            card.joker_display_values.most_played = MadLib.get_most_played_hand()
            card.joker_display_values.target_hand = localize(MadLib.get_most_played_hand(), 'poker_hands')
        end,
    }

    jod['j_rgmc_squash_keychain'] = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "target_card" },
            { text = ")" },
        },
        calc_function = function(card)
            card.joker_display_values.target_card = MadLib.localize_name_text('Tarot', card.ability.extra.tarot_id)
        end,
    }

    jod['j_rgmc_legend_picky'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
                }
            }
        },
    }

    jod['j_rgmc_legend_foreman'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp" }
                }
            }
        }
    }

    function MadLib.JokerDisplay.valid_card(playing_card)
        return playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff
    end

    -- Overhaul

    --[[
        Fibonacci
        Odd Todd
        Even Steven
        Lusty Joker
        Wrathful Joker
        Gluttonous Joker
        Greedy JOker
        8-Ball
        Scholar
        Sixth Sense
        Superposition
        Baron
        Cloud 9
        Mail-In Rebate
        Walkie Talkie
        Wee Joker
        The Idol
        Hit the Road
        Invicible Joker
        Triboulet
        Canio
        Yorick
        Perkeo
        Erosion

        Half Joker
        Driver's License
        Swashbuckler
        Glass Joker
        Raised Fist
        Steel Joker
        Stone Joker
        Abstract Joker
        Square Joker
        Baseball Joker
        Trading Card
        Castle
    ]]

    -- Fibonacci
    jod['j_fibonacci'].calc_function = function(card)
        local mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                mult = MadLib.has_fib_rank(scoring_card)
                    and MadLib.add(mult, MadLib.multiply(MadLib.is_base_rank(card) 
                        and card.ability.extra.mult 
                        or card.ability.extra.mult2, JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)))
                    or mult
            end
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",2,3,5,8)"
    end

    -- Odd Todd
    jod['j_odd_todd'].calc_function = function(card)
        local chips = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                chips = MadLib.has_odd_rank(scoring_card)
                    and MadLib.add(chips, MadLib.multiply(card.ability.extra.chips, JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)))
                    or chips
            end
        end
        card.joker_display_values.chips = chips
        card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",9,7,5,3)"
    end

    -- Even Steven
    jod['j_even_steven'].reminder_text = { ref_table = "card.joker_display_values", ref_value = "localized_text" }
    jod['j_even_steven'].calc_function = function(card)
        local mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                mult = MadLib.has_even_rank(scoring_card)
                    and MadLib.add(mult, MadLib.multiply(card.ability.extra.mult, JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)))
                    or mult
            end
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.localized_text = "(10,8,6,4,2)"
    end

    -- Shoot the Moon
     jod['j_shoot_the_moon'].calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local mult = 0
        
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if 
                    MadLib.JokerDisplay.valid_card(playing_card) 
                    and MadLib.joker_check_rank(playing_card, card, 'Queen')
                then
                    mult = MadLib.add(mult, MadLib.multiply(card.ability.extra.mult, JokerDisplay.calculate_card_triggers(playing_card, nil, true)))
                end
            end
        end
        card.joker_display_values.mult = mult
    end

    -- 8-Ball
    jod['j_8_ball'].calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if MadLib.joker_check_rank(scoring_card, card, card.ability.extra.rank or '8') then
                    count   = MadLib.add(count, JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                end
            end
        end
        card.joker_display_values.count = count
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra, '8_ball')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end

    -- Scholar
    jod['j_scholar'].calc_function = function(card)
        local chips, mult = 0, 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if MadLib.joker_check_rank(scoring_card, card, card.ability.extra.rank or 'Ace') then
                    local retriggers = JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    chips   = MadLib.add(chips, MadLib.multiply(card.ability.extra.chips, retriggers))
                    mult    = MadLib.add(mult, MadLib.multiply(card.ability.extra.mult, retriggers))
                end
            end
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.chips = chips
        card.joker_display_values.localized_text = "(" .. localize("k_aces") .. ")"
    end

    -- Sixth Sense
    jod['j_sixth_sense'].calc_function = function(card)
        local _, _, scoring_hand = JokerDisplay.evaluate_hand()
        local sixth_sense_eval = #scoring_hand == 1 and MadLib.joker_check_rank(scoring_hand[1], card, card.ability.extra.rank or '6')
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_played == 0
        card.joker_display_values.count = sixth_sense_eval and 1 or 0
    end

    -- Superposition
    jod['j_superposition'].calc_function = function(card)
        local is_superposition = false
        local _, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        if 
            poker_hands[card.ability.extra.poker_hand or 'Straight']
            and next(poker_hands[card.ability.extra.poker_hand or 'Straight'])
        then
            for _, scoring_card in pairs(scoring_hand) do
                if MadLib.joker_check_rank(scoring_card, card, card.ability.extra.rank or 'Ace') then
                    is_superposition = true
                end
            end
        end
        card.joker_display_values.count = is_superposition and 1 or 0
        card.joker_display_values.localized_text_straight = localize(card.ability.extra.poker_hand or 'Straight', "poker_hands")
        card.joker_display_values.localized_text_ace = localize(card.ability.extra.rank or "Ace", "ranks")
    end

    -- Baron
    jod['j_baron'].calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if 
                    MadLib.JokerDisplay.valid_card(playing_card)
                    and MadLib.joker_check_rank(scoring_card, card, card.ability.extra.rank or 'King')
                then
                    count = MadLib.add(count, JokerDisplay.calculate_card_triggers(playing_card, nil, true))
                end
            end
        end
        card.joker_display_values.x_mult = MadLib.exponent(card.ability.extra.x_mult, count)
    end

    -- Cloud 9
    jod['j_cloud_9'].calc_function = function(card)
        local nines = MadLib.get_card_count(G.playing_cards, function(v)
            return MadLib.joker_check_rank(v, card, card.ability.extra.rank or '9')
        end)
        card.joker_display_values.dollars = MadLib.multiply(card.ability.extra.dollars, nine)
        card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
    end
end
