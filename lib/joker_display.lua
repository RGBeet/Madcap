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
            local numerator, denominator            = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bball_pasta')
            card.joker_display_values.odds          = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
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

    jod['j_rgmc_lady_liberty'] = {
        text = {
            { text = "X" },
            { ref_table = "card.joker_display_values", ref_value = "count" },
            { text = "Patina" }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            card.joker_display_values.count = card.ability.extra.seals or 1
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

    jod['j_rgmc_house_of_cards'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        calc_function = function(card)
            local numerator, denominator        = SMODS.get_probability_vars(card, MadLib.add(1, card.ability.immutable.increase), card.ability.immutable.odds, 'house_of_cards')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.chips     = card.ability.extra.chips + card.ability.extra.chip_mod
        end,
        style_function = function(card, text, reminder_text, extra)
            local numerator, denominator        = SMODS.get_probability_vars(card, MadLib.add(1, card.ability.immutable.increase), card.ability.immutable.odds, 'house_of_cards')
            if extra and extra.children then
                local div = MadLib.divide(numerator, denominator)
                print(div)
                return true
            end
            return false
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

    jod['j_rgmc_lady_null_and_void'] = {
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
            card.joker_display_values.active_text = localize(active and 'k_active' or 'k_inactive')
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
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS['rgmc_goblets'], 0.35) },
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
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS['rgmc_towers'], 0.35) },
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
            { text = ")", colour = G.C.UI.TEXT_INACTIVE },
        },
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local suit = G.GAME.current_round
                and G.GAME.current_round.rgmc_barbershop
                and G.GAME.current_round.rgmc_barbershop.suit
                or 'Spades'
            local mult = 0
            if text ~= 'Unknown' then
                mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return MadLib.list_matches_one(Madcap.Lists.PentagonalNumbers, function(c)
                        return c:is_suit(suit)
                    end)
                end), card.ability.extra.mult)
            end
            card.joker_display_values.mult              = mult
            card.joker_display_values.localized_text    = localize(card.ability.extra.suit, 'suits_plural')
        end
    }

    jod['j_rgmc_cup_of_joeker'] = {
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active_text" },
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            card.joker_display_values.count = card.ability.extra.seals or 1
            card.joker_display_values.active_text = localize(G.GAME.current_round.hands_played == 0 and 'k_active' or 'k_inactive')
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
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_chips", retrigger_type = "exp" }
                }
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "rounds" },
            { text = "/" },
            { ref_table = "card.ability.extra", ref_value = "max_rounds" },
            { text = ")" },
        },
        text_config = { colour = G.C.MULT },
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children then
                local w = MadLib.get_warning_colour(card.ability.extra.rounds / card.ability.extra.max_rounds)
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
                }
            }
        },
        text_config = { colour = G.C.CHIPS },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
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
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "e_chips", retrigger_type = "exp" }
                }
            }
        },
        text_config = { colour = G.C.DARK_EDITION },
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

    jod['j_rgmc_changing_had'] = {
        text = {
            { text = "Pos. #" },
            { ref_table = "card.ability.immutable", ref_value = "position" }
        },
        text_config = { colour = G.C.ATTENTION },
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand then return 0 end
            local positioned = scoring_hand and MadLib.JokerDisplay.calculate_card_position(scoring_hand)
            return positioned and playing_card == positioned and
                joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
        end,
    }

    jod['j_rgmc_iron_joker'] = {
        text = {
            { text = "X" },
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
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["rgmc_goblets"], 0.35) },
            { text = ")" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = "- " },
                { text = "+", colour = G.C.MULT},
                { ref_table = "card.ability.extra", ref_value = "mult_mod", colour = G.C.MULT },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local count =  0
            if G.play then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit("rgmc_goblets"); end) end
                else
                count = 0
            end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'plentiful_ametrine', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.localized_text = localize("rgmc_goblets", 'suits_plural')
        end
    }

    jod['j_rgmc_fortified_shungite'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["rgmc_towers"], 0.35) },
            { text = ")" }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = "- +" },
                { ref_table = "card.ability.extra", ref_value = "chip_mod", colour = G.C.CHIPS },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local count =  0
            if G.play then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v:is_suit("rgmc_goblets"); end) end
                else
                count = 0
            end
            card.joker_display_values.count     = count
            local numerator, denominator    = MadLib.JokerDisplay.get_stacked_probabilities(card, 'fortified_shungite', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.localized_text = localize("rgmc_towers", 'suits_plural')
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
                { text = "- " },
                { text = "+", colour = G.C.CHIPS },
                { ref_table = "card.ability.extra", ref_value = "chip_mod", colour = G.C.CHIPS },
                { text = ")" },
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
            local numerator, denominator        = MadLib.JokerDisplay.get_stacked_probabilities(card, 'vari_seala', count)
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.rank      = localize(card.ability.extra.rank, "ranks")
        end,
        style_function = function(card, text, reminder_text, extra)
            if text and text.children[1] and text.children[2] then
                text.children[1].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Spectral or
                    G.C.UI.TEXT_INACTIVE
                text.children[2].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Spectral or
                    G.C.UI.TEXT_INACTIVE
            end
            return false
        end
    }

    jod['j_rgmc_conspiracy_wizard'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" },
            { text = " / " },
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rank" },
            { text = "/" },
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
                    rank_text = localize(card.ability.extra.rank, "ranks")
                end
                if G.GAME.current_round.rgmc_wizard_card.suit_discovered then
                    suit = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                        return MadLib:is_suit(v, G.GAME.current_round.rgmc_wizard_card.suit)
                    end), card.ability.extra.mult)
                    suit_text = localize(card.ability.extra.suit, 'suits_plural')
                end
            end

            card.joker_display_values.rank      = rank_text
            card.joker_display_values.suit      = suit_text
            card.joker_display_values.mult      = chips
            card.joker_display_values.rank      = suit
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
                    reminder_text.children[5].config.colour = w.suit_discovered and G.C.MULT or
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
                    { ref_table = "card.joker_display_values", ref_value = "x_chips", retrigger_type = "exp" }
                }
            }
        },
        calc_function = function(card)
            local playing_hand = next(G.play.cards)
            card.joker_display_values.x_mult = playing_hand and MadLib.exponentiate(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                return MadLib.is_rank(v, SMODS.Ranks['rgmc_Knight'].id)
            end), card.ability.extra.x_chips) or to_big(1)
        end
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
            card.joker_display_values.x_mult = playing_hand and MadLib.exponentiate(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                return MadLib.is_rank(v, SMODS.Ranks['rgmc_Sum'].id)
            end), card.ability.extra.x_chips) or to_big(1)
        end
    }

    jod['j_rgmc_venn_diagram'] = {
        text = {
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
        },
        calc_function = function(card)
            local mult = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()

            local rank_text, suit_text = "??", "??"
            if text ~= 'Unknown' then
                mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return (not MadLib.has_suit_in_list(context.other_card, MadLib.SuitTypes.Base)
                        or MadLib.has_rank_in_list(context.other_card, MadLib.RankTypes.Base))
                end), card.ability.extra.chips)
            end
            card.joker_display_values.mult      = mult
        end
    }

    jod['j_rgmc_continuum'] = {
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if not scoring_hand then return 0 end
            local retriggers = 1
            MadLib.loop_func(scoring_hand, function(v)
                if not MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id) then return end
                local index, selection, cutoff = 1, nil, nil

                index = 1 -- go to start
                cutoff = #scoring_hand
                while index <= #scoring_hand do
                    selection = scoring_hand[index]
                    if selection == card and i == repeats then
                        break -- we're done here
                    end
                    retriggers = retriggers + 1
                    index = (selection == card) and (#scoring_hand + 1) or (index + 1)
                end
            end)
            return retriggers
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
            MadLib.loop_table(MadLib.get_suits_from_cards(sorted_hand), function()
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
            card.joker_display_values.active_text = localize(active and 'k_active' or 'ph_no_boss_active')
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
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
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
        end,
    }
end
