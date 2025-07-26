-- used for legendary joker atlas stuff
local legend = function(num,front)
    local n = num%3
    local a,b = n*2, math.floor(num/3)
    if front then a = a+1 end
    return {x = a, y = b}
end

local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

local name = function(n)
    return 'rgmc_'..tostring(n)
end

local get_xmod = function(key)
    return key and
    (key == "x_mult" or key == "xmult" or key == "Xmult"
    or key == "x_mult_mod" or key == "xmult_mod" or key == "Xmult_mod")
end

--[[
    UPDATE ONE JOKERS
]]

local sprites = 'jokers'

-- 1. Vari-Seala (WORKS)
local vari_seala = {
    key     = 'vari_seala',
    atlas   = sprites,
    pos     = get_pos(0,0),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            odds = 4,
            seals = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
            number_format(MadLib.base_prob(card)),
            number_format(card.ability.extra.odds),
            number_format(card.ability.extra.seals))
    end,
    calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.cardarea == G.hand
            and context.other_card
            and context.other_card.seal
        then

            -- If roll is successful, loop through X random cards in shuffled hand
            if Madcap.Funcs.calculate_card_odds(card,'vari_seala') then
                local shuffle = MadLib.get_cards_from_shuffled_deck(G.hand.cards)

                MadLib.loop_func(MadLib.list_pick_range(shuffle, 1, card.ability.extra.seals), function(c)
                    MadLib.seal_event(c,context.other_card.seal)
                end)
            end

        end
    end
}

-- 2. B-Ball Pasta (WORKS?)
local bball_pasta = {
    key     = 'bball_pasta',
    atlas   = sprites,
    pos     = get_pos(0,1),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            odds = 6,
            chips = 5,
            mult = 2,
            chip_mod = 5,
            mult_mod = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(MadLib.base_prob(card)),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.mult_mod),
                number_format(card.ability.extra.chips),
                number_format(card.ability.extra.mult))
    end,
    calculate = function(self, card, context)

		if context.joker_main or context.forcetrigger then
			return {
				message = localize("rgmc_what"),
				chip_mod = lenient_bignum(card.ability.extra.chips),
				mult_mod = lenient_bignum(card.ability.extra.mult),
			}
		end

        if Madcap.Funcs.get_end_of_round(context) and Madcap.Funcs.calculate_card_odds(card,'bball_pasta') then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return { message = localize("k_upgrade_ex") }
        end
    end
}

-- 3. Squeezy Cheeze (WORKS)
local squeezy_cheeze = {
	key     = 'squeezy_cheeze',
    atlas   = sprites,
    pos     = get_pos(0,2),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true, -- do an xchips for every currently stored x_mult
    config =  {
        extra = {
            x_chips          = 1,
            xchip_mod        = 0.2,
            xmult_mod        = 1,
            xmult_store      = 0,
            rounds_remaining = 8,
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(card.ability.extra.xchip_mod),
                number_format(card.ability.extra.xmult_mod),
                number_format(card.ability.extra.rounds_remaining))
    end,
    calculate = function(self, card, context)
        -- Most of this is handled in hooks
        if Madcap.Funcs.get_end_of_round(context) then
            return MadLib.food_joker_logic(card)
        end

        if context.after then
            card.ability.extra.xmult_store = 0
        end
    end
}

-- 4. Joker Squared
local joker_squared = {
    key     = 'joker_squared',
    atlas   = sprites,
    pos     = get_pos(0,3),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { mult = 5 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.mult))
    end,
    calculate = function(self, card, context)
        if
            (context.cardarea == G.play
            and context.individual
            and context.other_card
            and MadLib.list_matches_one(rank_patterns['Square'], function(c)
                    return context.other_card:get_id() == c -- square number
                end))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult,card,card.ability.extra.mult)
        end
    end
}

-- 5. Spectator
local spectator = {
    key     = 'spectator',
    atlas   = sprites,
    pos     = get_pos(0,4),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { mult_mod = 2, mult = 0 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.mult_mod))
    end,
    calculate = function(self, card, context)

        -- Before scoring, count the unscored cards.
		if
            context.cardarea == G.jokers
            and context.before
            and not context.blueprint
        then
			for k, v in ipairs(context.scoring_hand) do v.rgmc_garbage_incompat = true end

            local cards = 0
            MadLib.loop_func(context.full_hand, function(v)
				if not v.rgmc_garbage_incompat then
					cards = cards + 1
					MadLib.simple_juice(v)
				end
            end)

            MadLib.loop_func(context.scoring_hand, function(v)
                v.rgmc_garbage_incompat = nil
            end)

            card.ability.extra.mult = cards * card.ability.extra.mult_mod or 0
        end

        if
            context.joker_main
            and card.ability.extra.mult > 0
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult,card,card.ability.extra.mult)
        end
    end
}

-- 6. Lady Liberty
local lady_liberty = {
    key     = 'lady_liberty',
    atlas   = sprites,
    pos     = get_pos(0,5),
    rarity  = 1,
    cost    = 3,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = {
            seals = 1
        },
        immutable = {
            max_seals = 10
        }
    },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { set = "Other", key = "rgmc_patina_seal" }
		return MadLib.collect_vars(math.floor(math.min(card.ability.extra.seals, card.ability.immutable.max_seals)))
    end,
    calculate = function(self, card, context)
        if
            context.after
            and G.GAME.current_round.hands_played == 0  -- first round only!
        then
            local shuffled    = MadLib.get_cards_from_shuffled_deck(context.scoring_hand)
            local index,seals_done = 0,0

            MadLib.loop_check_func_limited(shuffled, function(v)
                return not v.seal -- no seal
            end, function(v)
                MadLib.seal_event(v,'rgmc_patina')
            end, card.ability.extra.seals)
        end
    end
}

-- 7. Neighborhood Watch
local neighborhood_watch = {
    key     = 'neighborhood_watch',
    atlas   = sprites,
    pos     = get_pos(0,6),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
		extra = {
			money_mod = 2,
			money = 0,
		},
    },
	loc_vars = function(self, info_queue, card)
		local vars = MadLib.collect_vars_colours(
                number_format(card.ability.extra.money_mod),
                localize(Madcap.Funcs.safe_get(G.GAME, "current_round", "rgmc_edwin_card", "rank") or "5", "ranks"),
                localize(G.GAME.current_round.rgmc_edwin_card
                    and G.GAME.current_round.rgmc_edwin_card.suit
                    or "Diamonds", "suits_plural"),
                { G.C.SUITS[G.GAME.current_round.rgmc_edwin_card and G.GAME.current_round.rgmc_edwin_card.suit or "Diamonds"] })
        return vars
	end,
	calc_dollar_bonus = function(self, card)
		if to_big(card.ability.extra.money) > to_big(0) then
			return lenient_bignum(card.ability.extra.money)
		end
	end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.money = 0
        end

        if context.end_of_round -- at end of round, check hand for target card
            and context.cardarea == G.hand
            and not context.repetition
			and not context.blueprint
			and context.other_card
			and context.other_card:get_id() == G.GAME.current_round.rgmc_edwin_card.id
			and context.other_card:is_suit(G.GAME.current_round.rgmc_edwin_card.suit)
		then -- has both suit and rank
			if context.other_card.debuff then -- don't count debuffed cards haha
				return MadLib.get_debuff_data(card)
			else
				card.ability.extra.money = lenient_bignum(to_big(card.ability.extra.money) + card.ability.extra.money_mod)
				card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_upgrade_ex") })
				return nil, true
			end
        end
    end
}

-- 8. Penrose Stairs
local penrose_stairs = {
    key     = 'penrose_stairs',
    atlas   = sprites,
    pos     = get_pos(0,7),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = {  times = 1 },
        immutable = { odds = 6 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(MadLib.base_prob(card), card.ability.immutable.odds, card.ability.extra.times)
    end,
    calculate = function(self, card, context)
        if
            (context.after or context.forcetrigger)
            and context.scoring_hand
        then
            -- Each card has a 1 in 6 chance of being picked
            local random_pick = MadLib.get_list_matches(MadLib.get_list_matches, function(v)
                return Madcap.Funcs.calculate_card_odds(card,'penrose_stairs')
            end)

            -- Take random cards and strengthify them
            Madcap.Funcs.flip_cards(random_pick, function(v)
                assert(SMODS.modify_rank(v, card.ability.extra.times))
            end)
        end
    end
}

-- 9. Quick Brown Fox
local quick_brown_fox = {
    key     = 'quick_brown_fox',
    atlas   = sprites,
    pos     = get_pos(0,8),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {  extra = { chips = 7 } },
    loc_vars = function(self, info_queue, card)
        local amt = (G.GAME and G.GAME.MADCAP
            and G.GAME.MADCAP.ante.ante.unique_ranks) or 0
        return MadLib.collect_vars(number_format(card.ability.extra.chips),
                number_format(card.ability.extra.chips * amt))
    end,
    calculate = function(self, card, context)
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            local amt = G.GAME.MADCAP.ante and G.GAME.MADCAP.ante.unique_ranks or 0
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips * amt)
        end
    end
}

-- 10. House of Cards
local house_of_cards = {
    key     = 'house_of_cards',
    atlas   = sprites,
    pos     = get_pos(0,9),
    rarity  = 1,
    cost    = 3,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        immutable = { odds = 6 }, -- if this was mutable, it would ruin the card
        extra = {
            chip_mod = 6,
            chips = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.chip_mod),
            number_format(MadLib.base_prob(card)),
            number_format(card.ability.immutable.odds),
            number_format(card.ability.extra.chips))
    end,
    calculate = function(self, card, context)

        if -- upgrade!
            context.cardarea == G.jokers
            and (context.before or context.forcetrigger)
        then
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
        end

        if  -- the cards :)
            context.joker_main -- playing the hand
			and (to_big(card.ability.extra.chips) > to_big(0))
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips,card,card.ability.extra.chips)
        end

        if  -- 1 in ? chance to fucking knock the house down
            context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
        then
            if Madcap.Funcs.calculate_card_odds(card,'house_of_cards') then
                return MadLib.get_simple_reset_data(MadLib.ScoreKeys.AddChips, card, 'chips')
            end
        end
    end
}

-- 11. Glass Michel
local glass_michel = {
    key     = 'glass_michel',
    atlas   = sprites,
    pos     = get_pos(1,0),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { odds = 6 }
    },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return MadLib.collect_vars(
            number_format(MadLib.base_prob(card)),
            number_format(card.ability.extra.odds))
    end,
    calculate = function(self, card, context) -- also keeps glass cards safe

        if
            context.repetition
            and context.cardarea == G.play
            and (SMODS.has_enhancement(context.other_card, 'm_glass')
                or context.forcetrigger)
        then
            context.other_card.ability.glass_michel = true
            return MadLib.get_retrigger_data(card,1)
		end

        -- End of round stuff
		if
			context.end_of_round2
			and not context.individual
			and not context.repetition
			and not context.blueprint
			and not context.retrigger_joker
		then
            -- Reset the cards
            for _, v in pairs(G.playing_cards) do
                if v.ability.glass_michel then v.ability.glass_michel = nil end
            end

            return Madcap.Funcs.calculate_card_odds(card,'glass_michel')
                and MadLib.banana_remove(card)
                or MadLib.get_safe_data(card)
        end
    end
}

-- 12. Chinese Takeout
local chinese_takeout = {
    key     = 'chinese_takeout',
    atlas   = sprites,
    pos     = get_pos(1,1),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            rounds_remaining = 8,
            effects = {
                20,     -- +chips
                4,      -- +mult
                70,     -- +chips
                9,      -- +mult
                120,    -- +chips
                1.5,    -- Xmult
                2.5,    -- Xmult
                2.5     -- Xscore
            }
        },
        immutable = {
            mode = 1    -- starts off at just fried rice
        }
    },
    loc_vars = function(self, info_queue, card)
        local str = "null"
		if
            card.ability.immutable.mode > 0
            and card.ability.immutable.mode < 8
        then
             str = "rgmc_chinese_effect"..tostring(card.ability.immutable.mode)
        end

        tell(card.ability.immutable.mode)

		info_queue[#info_queue + 1] = {
            set = "Other",
            key = str,
            vars = { card.ability.extra.effects[card.ability.immutable.mode] }
        }

        return MadLib.collect_vars(number_format(card.ability.extra.rounds_remaining),
            number_format(card.ability.extra.effects[card.ability.immutable.mode]))
    end,
    calculate = function(self, card, context)

        -- Start of blind
        if
            context.setting_blind
            and not context.blueprint
        then

            local new_food = math.random(1, 8)
            card.ability.immutable.mode = new_food

            if -- if doable, show a line
                card.ability.immutable.mode > 0
                and card.ability.immutable.mode <= 8
            then
                return { message = localize("rgmc_chinese_line" .. card.ability.immutable.mode) }
            end
		end

        -- At scoring time...
		if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            tell('Value: '..number_format(card.ability.extra.effects[card.ability.immutable.mode]))
            if
                card.ability.immutable.mode == 1
                or card.ability.immutable.mode == 3
                or card.ability.immutable.mode == 5
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.effects[card.ability.immutable.mode])
            elseif
                card.ability.immutable.mode == 2
                or card.ability.immutable.mode == 4
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.effects[card.ability.immutable.mode])
            elseif
                card.ability.immutable.mode == 6
                or card.ability.immutable.mode == 7
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.effects[card.ability.immutable.mode])
            else
                -- Xscore
                card.ability.rgmc_tsao_chicken = true
                return {
                    message = "...?",
                    colour = G.C.PURPLE
                }
            end
        end

        -- If you get the tsao chicken...
        if
			context.after
			and card.ability.rgmc_tsao_chicken
		then
            MadLib.simple_event(function()
                G.GAME.chips = (to_big(G.GAME.chips))*(to_big(card.ability.extra.effects[card.ability.immutable.mode]))
                G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)

                play_sound('holo1')
                card.ability.rgmc_tsao_chicken = nil -- not needed now
                return true
            end, 0.4, 'after')

            return {
				message = "X" .. tostring(card.ability.extra.effects[card.ability.immutable.mode]),
				colour = G.C.PURPLE
			}
        end

        -- End of round
		if Madcap.Funcs.get_end_of_round(context) then
            return MadLib.food_joker_logic(card)
        end
    end
}

-- 13. Easter Egg
local easter_egg= {
    key     = 'easter_egg',
    atlas   = sprites,
    pos     = get_pos(1,2),
    rarity  = 1,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { value = 2, value_mod = 1 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.value, card.ability.extra.value_mod)
    end,
    calculate = function(self, card, context)

        -- At end of blind, increase value by value_mod
        if
            (context.end_of_round
                and context.cardarea == G.jokers
                and not context.blueprint
                and not context.repetition
                and not context.individual)
            or context.forcetrigger
        then
            card.ability.extra.value = lenient_bignum(card.ability.extra.value + card.ability.extra.value_mod)
            return {
                message = "+" .. number_format(card.ability.extra.value_mod), -- Upgrade!
                card = card,
            }
        end
		if
            (context.selling_self
                and not context.blueprint)
                or context.forcetrigger
        then

            local shuffle = MadLib.get_cards_from_shuffled_deck(G.deck.cards)

            table.sort(shuffle, function(a, b)
                return (a.edition and not b.edition)
            end)

            shuffle = MadLib.list_pick_range(shuffle, 1, math.min(#shuffle, card.ability.extra.value))

            Madcap.Funcs.flip_cards(shuffle, function(v)
                MadLib.simple_event(function()
                    v:set_edition(MadLib.get_weighted_edition(), true)
                    v:juice_up(0.5, 0.7)
                    v.ability.rgmc_easter_egg = true
                    return true
                end, 0.4, 'immediate')
            end)

            if context.forcetrigger then card.ability.extra.value = 0 end -- force trigger resets it
        end
    end
}

-- 14. Null and Void
local null_and_void = {
    key     = 'null_and_void',
    atlas   = sprites,
    pos     = get_pos(1,3),
    rarity  = 1,
    cost    = 3,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            cards_to_debuff = 1
        },
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.cards_to_debuff or 1)
    end,
    calculate = function(self, card, context)
        if
            context.before
            and context.blueprint
        then
            card.ability.blueprint_extra = cards_to_debuff
        end

		if
            context.cardarea == G.jokers
            and (context.before or context.forcetrigger)
        then
            local self_index = MadLib.get_item_index(card, G.jokers.cards)

            -- enable to the left of the joker + the joker
            local enable    = MadLib.list_pick_range(G.jokers.cards, 1, self_index)
            MadLib.loop_func(enable, function(v)
                MadLib.simple_event(function()
                    v.rgmc_nullified = nil
                    v:set_debuff(false)
                    v:juice_up(0.3, 0.4)
                end, 0.3, 'before')
            end)

            -- disable the next X right cards
            local end_point = math.min(self_index + (card.ability.extra.cards_to_debuff + (card.ability.blueprint_extra or 0)), #G.jokers.cards)
            local disable   = MadLib.list_pick_range(G.jokers.cards, self_index+1, end_point)
            MadLib.loop_func(disable, function(v)
                MadLib.simple_event(function()
                    v.rgmc_nullified = true
                    v:set_debuff(true)
                    v:juice_up(0.7, 0.5)
                end, 0.3, 'before')
            end)
        end

        if context.after then -- handle blueprint shit
            card.ability.blueprint_extra = nil
        end
    end,
}

-- 15. Pretentious Joker
local pretentious_joker = {
    key     = 'pretentious_joker',
    atlas   = sprites,
    pos     = get_pos(1,4),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = {
            mult = 6,
            suit = 'rgmc_goblets'
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars_colours(
            number_format(card.ability.extra.mult),
            localize(card.ability.extra.suit, 'suits_singular'),
            { G.C.SUITS[card.ability.extra.suit] })
    end,
    calculate = function(self, card, context)
        if
            (context.individual
            and context.cardarea == G.play
            and context.other_card:is_suit(card.ability.extra.suit))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
        end
    end,
}

-- 16. Deceitful Joker
local deceitful_joker = {
    key     = 'deceitful_joker',
    atlas   = sprites,
    pos     = get_pos(1,5),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = {
            mult = 6,
            suit = 'rgmc_towers'
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars_colours(
            number_format(card.ability.extra.mult),
            localize(card.ability.extra.suit, 'suits_singular'),
            { G.C.SUITS[card.ability.extra.suit] })
    end,
    calculate = function(self, card, context)
        if
            (context.individual
            and context.cardarea == G.play
            and context.other_card:is_suit(card.ability.extra.suit))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
        end
    end,
}

-- 17. Pentagon
local pentagon = {
    atlas   = sprites,
    key     = 'pentagon',
    name    = name('pentagon'),
    pos     = get_pos(1,6),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = {
            chips = 21,
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.mult))
    end,
    calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.individual
        then
            local rank = context.other_card:get_id()
            if MadLib.is_pentagonal(tonumber(rank))
                or rank == 'Queen'
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end
        end
    end,
}

-- 18. Barbershop Joker
local barbershop_joker = {
    key     = 'barbershop_joker',
    atlas   = sprites,
    pos     = get_pos(1,8),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { mult = 3, scored = false }
    },
    loc_vars = function(self, info_queue, card)
        local suit = Madcap.Funcs.safe_get(G.GAME, "current_round", "rgmc_barbershop", "suit") or 'Spades'

        print(suit)
        --[[
        return MadLib.collect_vars_colours(
            localize(suit, 'suits_singular'),
            number_format(card.ability.extra.mult,
            { G.C.SUITS[suit] }))]]
    end,
    calculate = function(self, card, context)
        local target = G.GAME.current_round.rgmc_barbershop.suit
        if
            (context.individual
            and context.cardarea == G.play
            and context.other_card:is_suit(target))
            or context.forcetrigger
        then
            G.GAME.current_round.rgmc_barbershop.changed = false
            card.ability.extra.scored = true
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
        end

        if
            context.after
            and card.ability.extra.scored
            and not G.GAME.current_round.rgmc_barbershop.changed -- only switch it ONCE!
        then
            local barber = G.GAME.current_round.rgmc_barbershop

            barber.changed  = true
            barber.index    = barber.index + 1

            if barber.index > #barber.order then
                barber.index = 1
            end

            barber.suit = barber.order[barber.index]

            tell('Barbershop Changed to ' .. number_format(barber.suit))
            card.ability.extra.scored = false
            return {
                message = 'Two Bits!',
                colour = G.C.YELLOW,
                card = card
            }
        end
    end
}

-- 19. Cup of Joeker
local cup_of_joeker = {
    key =    'cup_of_joeker',
    atlas   = sprites,
    pos     = get_pos(1,7),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    calculate = function(self, card, context)
        if
            (context.end_of_round
                and context.cardarea == G.jokers
                and G.GAME.current_round.hands_played == 0)
            or context.forcetrigger
        then
            MadLib.get_random_card("Tarot")
        end
    end
}

-- 20. Supreme With Cheese
local supreme_with_cheese = {
    key     = 'supreme_with_cheese',
    atlas   = sprites,
    pos     = get_pos(1,9),
    rarity  = 1,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = false,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { x_mult = 2, rounds_remaining = 8 },
        immutable = { max_rounds = 8 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars_colours(
            number_format(card.ability.extra.rounds_remaining),
            number_format(card.ability.extra.x_mult),
            { MadLib.get_warning_colour(card.ability.extra.rounds_remaining / card.ability.immutable.max_rounds) })
    end,
    calculate = function(self, card, context)
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
        end

        if Madcap.Funcs.get_end_of_round(context) then
            return MadLib.food_joker_logic(card)
        end
    end
}

-- 21. Bluenana
local bluenana = {
    key     = 'bluenana',
    atlas   = sprites,
    pos     = get_pos(2,0),
    rarity  = 1,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = false,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = { extra = { x_chips = 2, odds = 200 } },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(
                number_format(card.ability.extra.x_chips),
                number_format(MadLib.base_prob(card)),
                number_format(card.ability.extra.odds))
	end,
    calculate = function(self, card, context)
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card,
                card.ability.extra.x_chips)
        end

        if
			context.end_of_round
			and not context.individual
			and not context.repetition
			and not context.blueprint
			and not context.retrigger_joker
		then
            return MadLib.banana_logic(card, 'bluenana')
        end
    end
}

-- 22. Redd Dacca
local redd_dacca = {
    key     = 'redd_dacca',
    atlas   = sprites,
    pos     = get_pos(2,1),
    rarity  = 1, -- Thanks, Beige Deck
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = false,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = {
            e_mult = 1.4,
            odds = 200,
            numer_factor = 0.1 -- a little trick to mak
        }
    },
	loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(card.ability.extra.e_mult),
                number_format(math.floor((MadLib.base_prob(card)) ^ (1 + (card.ability.numer_factor or 0)))),
                number_format(card.ability.extra.odds))
	end,
    calculate = function(self, card, context)
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.ExpMult, card,
                card.ability.extra.e_mult)
        end

        if
			context.end_of_round
			and not context.individual
			and not context.repetition
			and not context.blueprint
			and not context.retrigger_joker
		then
        local adv_numerator = (MadLib.base_prob(card)) ^ (1 + (card.ability.numer_factor or 0))
            if MadLib.calculate_roll({
                card    = card,
                exp     = math.floor(adv_numerator) -- just to make it less OP on beige deck
            }) then -- 1 in 200^n chance to POOF!
                return MadLib.banana_remove(card)
            else
                return { message = localize("k_safe_ex") } -- safe!
            end
        end
    end
}

-- 23. Changing Had
local changing_had = {
    key     = 'changing_had',
    atlas   = sprites,
    pos     = get_pos(2,2),
    rarity  = 1,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { retriggers = 3 },
        immutable = {
            position = 1,
            changing = true
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(MadLib.get_num_position(card.ability.immutable.position or 1),
                number_format(card.ability.extra.retriggers))
    end,
    calculate = function(self, card, context)
        if
            context.repetition
            and context.cardarea == G.play
            and (context.other_card == context.scoring_hand[card.ability.immutable.position]
            or context.forcetrigger)
        then
            card.ability.immutable.changing = true
            return MadLib.get_retrigger_data(context.other_card, card.ability.extra.retriggers)
		end

		if
            context.after
            and card.ability.immutable.changing
		then
            return {
                message = 'Changing Had!',
				card = card,
				func = function()
                    card.ability.immutable.changing = false
                    card.ability.immutable.position = math.random(1, G.hand.config.highlighted_limit) -- chose random hand in sequence
                    card:juice_up(0.3, 0.4)
				end
            }
        end
    end,
}

-- 24. Ball Breaker
local ball_breaker = {
    key     = 'ball_breaker',
    atlas   = sprites,
    pos     = get_pos(2,3),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { chips = 0, chip_mod = 6 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.chip_mod), number_format(card.ability.extra.chips))
    end,
    calculate = function(self, card, context)

		if
            context.cardarea == G.jokers
            and context.before
            and context.scoring_hand
        then
            local rank = context.other_card:get_id()

			if
                MadLib.list_matches_all(G.play.cards, function(v)
                    local vn = tonumber(v:get_id())
                    return (vn and MadLib.is_fibonacci(vn))
                end)
            then
                return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
			end
        end

        if -- demicolon
            context.joker_main
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips,card,card.ability.extra.chips)
        end
    end
}

--[[
    Scored cards from Ace to 9
    have a 1 in 4 chance
    of turning into another rank
    (4 ~ 7, 2 ~ 5, 3 ~ 8, 6 ~ 9,
]]
local thorium_conversions = {
    ['2'] = '5',
    ['3'] = '8',
    ['4'] = '7',
    ['5'] = '2',
    ['6'] = '9',
    ['7'] = '4',
    ['8'] = '3',
    ['9'] = '6'
}

-- 25. Thorium Joker
local thorium_joker = {
    key     = 'thorium_joker',
    atlas   = sprites,
    pos     = get_pos(2,4),
    rarity  = 1,
    cost    = 5,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true, -- all cards in scored hand have a 1 in 3 chance
    config =  {
        extra = { odds = 3 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(MadLib.base_prob(card)), number_format(card.ability.extra.odds))
    end,
    calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.individual
            and context.other_card
            and context.scoring_hand
        then
            if
                MadLib.calculate_roll({ card = card, seed = 'rgmc_thorium_joker' })
            then
                -- if new rank doesnt exist, it shows up nil
                local new_rank = thorium_conversions[tostring(context.other_card:get_id())]
                print("New rank is " .. new_rank)
                if new_rank then
                    MadLib.flip_cards({ context.other_card }, function(c)
                        SMODS.change_base(c, _, new_rank) -- change da rank
                        play_sound((sound or 'tarot2'), 0.76, 0.4)
                    end, nil, function(c)
                        c:juice_up()
                    end)
                end
            end
        end
    end
}

local function twinkle_sort(a,b)
    local a_twinkle = a.ability and a.ability.twinkling and 1 or 0
    local b_twinkle = b.ability and b.ability.twinkling and 1 or 0
    if a_twinkle ~= b_twinkle then return a_twinkle < b_twinkle end
    local a_edition = a.edition and 1 or 0
    local b_edition = b.edition and 1 or 0
    return a_edition < b_edition
end

-- 26. Twinkle of Contagion
local twinkle_of_contagion = {
    key     = 'twinkle_of_contagion',
    atlas   = sprites,
    pos     = get_pos(2,5),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { twinkles = 1 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.twinkles))
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.record = {} -- used in reset
            card.ability.extra.card = nil
        end

        if context.setting_blind then

            -- Get a list of non-polychromes
            local shuffled = MadLib.get_cards_from_shuffled_deck(MadLib.get_possible_deck())

            -- Prioritizes non-twinkling, then non-editioned
            table.sort(shuffled, twinkle_sort(a, b))
            shuffled = MadLib.list_pick_range(shuffled,1,card.ability.twinkles)

            if shuffled then
                MadLib.flip_cards(shuffled, function(c)
                    c:set_edition({ polychrome = true })
                    c:set_rgmc_twinkling(true)
                    c:juice_up(0.5, 0.7)
                    play_sound('rgmc_contagion', 1, 0.6)
                end)
            end

        end

        if
            context.individual
            and context.cardarea == G.play
            and context.other_card
            and (context.other_card.edition and context.other_card.ability.twinkling) -- twinkling
        then

            local shuffled = MadLib.get_cards_from_shuffled_deck(G.hand.cards)
            table.sort(shuffled, twinkle_sort(a, b))

            local fc, tc = context.other_card, shuffled[1]

            if tc then
                MadLib.simple_event(function()
                    local edition = fc.edition
                    fc:set_edition(nil,true,true)
                    tc:set_edition(edition,true,true)
                    fc:set_rgmc_twinkling(false)
                    tc:set_rgmc_twinkling(true)
                    fc:juice_up(0.5, 0.7)
                    tc:juice_up(0.5, 0.7)
                    play_sound('rgmc_contagion', 1, 0.6)
                end, 0.1, 'after')
            end
        end

        if context.forcetrigger then

            -- from card list
            local from_cards = MadLib.get_list_matches(G.hand.cards, function(v)
                return v.edition and v.edition.polychrome and v.ability.twinkling
            end)
            if #from_cards < 1 then return false end -- terminate if no polychrome twinklings

            local amt = math.min(card.ability.extra.twinkles, #from_cards)

            -- to card list
            local to_cards = MadLib.get_cards_from_shuffled_deck(G.hand.cards, function(v)
                return not v.ability.twinkling
            end)
            if #to_cards < 1 then return false end
            table.sort(to_cards, twinkle_sort(a, b))
            to_cards = MadLib.list_pick_range(to_cards,1,amt)

            -- transfer
            for i=1, #amt do
                MadLib.simple_event(function()
                    local fc, tc = from_cards[i], to_cards[i]
                    fc:set_edition(nil,true,true)
                    tc:set_edition(edition,true,true)

                    fc:set_rgmc_twinkling(false)
                    tc:set_rgmc_twinkling(true)

                    fc:juice_up(0.5, 0.7)
                    tc:juice_up(0.5, 0.7)

                    play_sound('rgmc_contagion', 1, 0.6)
                end, 0.1, 'after')
            end
        end
    end
}

-- 27. Iron Joker
local iron_joker = {
    key     = 'iron_joker',
    atlas   = sprites,
    pos     = get_pos(2,6),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
	config = {
        enhancement = 'rgmc_ferrous',
        extra = { chips = 25 }
    },
    loc_vars = function(self, info_queue, card)
        local cards = G.playing_cards
            and #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
            or 0
        return MadLib.collect_vars(
				number_format(card.ability.extra.chips),
				number_format(card.ability.extra.chips * cards))
    end,
    calculate = function(self, card, context)
        if
            context.joker_main
            or context.forcetrigger
        then
            local amt = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips * amt)
        end
    end
}

-- 28. Tungsten Joker
local tungsten_joker = {
    key     = 'tungsten_joker',
    atlas   = sprites,
    pos     = get_pos(2,7),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
	config = {
        enhancement = 'rgmc_wolfram',
        extra = { mult = 6 }
    },
    loc_vars = function(self, info_queue, card)
        local cards = G.playing_cards
            and #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
            or 0
        return MadLib.collect_vars(
				number_format(card.ability.extra.mult),
				number_format(card.ability.extra.mult * cards))
    end,
    calculate = function(self, card, context)
        if
            context.joker_main
            or context.forcetrigger
        then
            local amt = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult * amt)
        end
    end
}

-- 29. Jeweler Joker
local jeweler_joker = {
    key     = 'jeweler_joker',
    atlas   = sprites,
    pos     = get_pos(2,8),
    rarity  = 2,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
	config = {
        enhancement = 'rgmc_lustrous',
        extra = { x_mult = 0.1 }
    },
    loc_vars = function(self, info_queue, card)
        local cards = G.playing_cards
            and #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
            or 0
        return MadLib.collect_vars(
				number_format(card.ability.extra.x_mult),
				number_format(card.ability.extra.x_mult * cards))
    end,
    calculate = function(self, card, context)
        if
            context.joker_main
            or context.forcetrigger
        then
            local amt = #MadLib.get_enhanced_cards(G.playing_cards,card.ability.enhancement)
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult * amt)
        end
    end
}

-- 30. Plentiful Ametrine
local plentiful_ametrine = {
    key     = 'plentiful_ametrine',
    atlas   = sprites,
    pos     = get_pos(2,9),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            odds = 4,
            mult = 0,
            mult_mod = 4,
            suit = 'rgmc_goblets'
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(MadLib.base_prob(card)),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.mult_mod),
                number_format(card.ability.extra.mult))
    end,
    calculate = function(self, card, context)
        -- scaling
        if
            context.cardarea == G.play
            and context.individual
            and (context.other_card and context.other_card:is_suit(card.ability.extra.suit))
            and MadLib.calculate_card_odds(card, 'rgmc_plentiful_ametrine')
        then
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult_mod)
        end

        -- give the mult
		if context.joker_main or context.forcetrigger then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
		end

		-- reset at end of ante
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and G.GAME.round % Madcap.Funcs.get_blinds_per_ante() == 0
        then
            return MadLib.get_simple_reset_data(MadLib.ScoreKeys.AddMult, card, 'mult')
        end
    end
}

-- 31. Toughened Shungite
local toughened_shungite = {
    key     = 'toughened_shungite',
    atlas   = sprites,
    pos     = get_pos(3,0),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            odds = 4,
            chips = 0,
            chip_mod = 15,
            suit = 'rgmc_goblets'
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(MadLib.base_prob(card)),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chips))
    end,
    calculate = function(self, card, context)
        -- scaling
        if
            context.cardarea == G.play
            and context.individual
            and (context.other_card and context.other_card:is_suit(card.ability.extra.suit))
            and MadLib.calculate_card_odds(card, 'rgmc_toughened_shungite')
        then
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
        end

        -- give the mult
		if context.joker_main or context.forcetrigger then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chups)
		end

		-- reset at end of ante
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and G.GAME.round % Madcap.Funcs.get_blinds_per_ante() == 0
        then
            return MadLib.get_simple_reset_data(MadLib.ScoreKeys.AddMult, card, 'mult')
        end
    end
}

-- 32. Six Shooter
local six_shooter = {
    key     = 'six_shooter',
    atlas   = sprites,
    pos     = get_pos(3,1),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { odds = 6, chips = 0, chip_mod = 30 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(MadLib.base_prob(card)),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chips))
    end,
    calculate = function(self, card, context)

        if -- build the chips
            context.cardarea == G.play
            and context.individual
            and context.other_card
            and not context.forcetrigger
        then
			if
                context.other_card:get_id() == 6
                and MadLib.calculate_roll({ card = card, seed = 'rgmc_six_shooter' })
			then
                local target = context.other_card

                MadLib.simple_event(function()
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    play_sound(('tarot2'), 0.76, 0.4)
                    target:juice_up(0.3, 0.4)
                    return true
                end, 0.1, 'immediate')

                MadLib.simple_event(function()
                    target:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                    return true
                end, 0.3, 'after')

                return MadLib.get_detailed_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
			end
		end


		if -- give the chips
            (context.joker_main and to_big(card.ability.extra.chips) > to_big(0))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips * amt)
		end
    end
}

-- 33. Conspiracy Wizard
local conspiracy_wizard = {
    key     = 'conspiracy_wizard',
    atlas   = sprites,
    pos     = get_pos(3,2),
    rarity  = 2,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { mult = 5, chips = 10 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
            number_format(card.ability.extra.mult),
            number_format(card.ability.extra.chips),
            (Madcap.Data.devmode and G.GAME.MADCAP) and G.GAME.current_round.rgmc_wizard_card.rank or "SEKRIT",
            (Madcap.Data.devmode and G.GAME.MADCAP) and Madcap.Data.devmode and G.GAME.current_round.rgmc_wizard_card.suit or "SEKRIT")
    end,
    calculate = function(self, card, context)

        if
            context.cardarea == G.play
            and context.individual
            and not context.blueprint
            and not context.forcetrigger
        then
			local rank = context.other_card:get_id()
			if rank == G.GAME.current_round.rgmc_wizard_card.rank then -- u got the rank (prioritizes over suit)
                G.GAME.current_round.rgmc_wizard_card.rank_discovered = true
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
			end
			if context.other_card:is_suit(G.GAME.current_round.rgmc_wizard_card.suit) then -- u got the suit
                G.GAME.current_round.rgmc_wizard_card.suit_discovered = true
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end
		end

		if context.forcetrigger then -- do both chip and mult, but do not reveal the cards
            MadLib.simple_event(function()
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end, 0.3, 'immediate')
            MadLib.simple_event(function()
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end, 0.3, 'immediate')
		end
    end
}

-- 34. Cavalier (only appears if you have a Knight)
local cavalier = {
    key     = 'cavalier',
    atlas   = sprites,
    pos     = get_pos(3,3),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { x_chips = 2, }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.x_chips))
    end,
    calculate = function(self, card, context)

		if
			(context.cardarea == G.hand -- held cards
			and (context.other_card and context.other_card.base.value == "rgmc_knight") -- is a knight card
			and not context.end_of_round)
			or context.forcetrigger
		then
			if (not context.forcetrigger) and context.other_card.debuff then
				return MadLib.get_debuff_data(card)
			else
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.x_chips)
			end
		end
    end
}

function Madcap.Funcs.get_simple_downgrade_data(t,card,val,bypass_safety)
    local final_val = not bypass_safety and
        (card.ability.extra[t.key] - val > 0 and val or card.ability.extra[t.key])
        or val

    if not bypass_safety and (card.ability.extra[t.key] - val) <= 0 then
        final_val = card.ability.extra[t.key]
    end

    card.ability.extra[t.key] = card.ability.extra[t.key] - final_val

    return {
        message = localize({
            type    = "variable",
            key     = t.key,
            colour      = t.colour,
            vars    = { number_format(final_val) },
            card    = card
        }),
    }
end

-- 35. Blindfold Joker (Demicolon compat!)
local blindfold_joker = {
    key     = 'blindfold_joker',
    atlas   = sprites,
    pos     = get_pos(3,4),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { x_mult = 3, x_mult_penalty = 0.25, active = false }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.x_mult_penalty),
                card.ability.extra.active
                    and localize("k_active_ex")
                    or localize("rgmc_inactive"))
    end,
    calculate = function(self, card, context)

        -- start blind: activate if big blind show it's active
        if context.setting_blind then
            local is_big_blind = G.GAME.blind:get_type() == 'Big'
            card.ability.extra.active = is_big_blind

            if is_big_blind then
                local eval = function() return G.GAME.blind:get_type() ~= "Big" end
                juice_card_until(card, eval, true)
            end
        end

        -- Reduces by ? until lower than 0.5X Mult, then destructs.
		if context.skip_blind then -- uh oh...
            if (card.ability.extra.x_mult - card.ability.extra.x_mult_penalty) > 0.5 then -- going down
				return Madcap.Funcs.get_simple_downgrade_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult_penalty)
            else
                -- fucking explode
                return MadLib.banana_remove(card)
            end
        end

		if -- big blind be like
            (context.joker_main and G.GAME.blind:get_type() == "Big")
            or context.forcetrigger -- demicolon
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
		end
    end
}

-- 36. Crystal Cola
local crystal_cola = {
    key     = 'crystal_cola',
    atlas   = sprites,
    pos     = get_pos(3,5),
    rarity  = 2,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = false, -- dependent on selling
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  { extra = { tags = 1 } },
    calculate = function(self, card, context)
		if
            (context.selling_self and not context.blueprint)
            or context.forcetrigger -- sneaky sneaky!
        then
            for i=1, card.ability.extra.tags do
                MadLib.simple_event(function()
                    local tag = Tag("tag_rgmc_boomerang")
                    add_tag(tag)
                    play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
                    play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
                    return true
                end, 0.1, 'after')
            end
		end
    end
}

-- 37. Sigma Joker
local sigma_joker = {
    key     = 'sigma_joker',
    atlas   = sprites,
    pos     = get_pos(3,6),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { x_chips = 0 }
    },
    loc_vars = function(self, info_queue, card)

        -- not highlighted
        local sigma_sum

        if G.hand then
            local unselected = MadLib.get_list_matches(G.hand.cards, function(v)
                return not MadLib.get_first_list_match(G.hand.highlighted)
            end)
            sigma_sum = unselected
                and to_big(Madcap.Funcs.get_hand_sigma(unselected)) or 0
        end

        return MadLib.collect_vars(
            number_format(card.ability.extra.x_chips),
            "~"..number_format((sigma_sum or 0) * card.ability.extra.x_chips))
    end,
    calculate = function(self, card, context)

        -- held in hand stuff
		if
			context.individual
			and context.cardarea == G.hand
			and context.other_card:get_id() == 'rgmc_sum' -- is a sum card
		then
			if context.other_card.debuff then
				return MadLib.get_debuff_data(card)
			else
                local sigma = 1 + Madcap.Funcs.get_hand_sigma(G.hand)
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card,
                    card.ability.extra.x_chips)
			end
		end

		if context.forcetrigger then
            local sigma = 1 + Madcap.Funcs.get_hand_sigma(G.hand)
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card,
                card.ability.extra.x_chips)
		end
    end
}

-- 38. Venn Diagram
local venn_diagram = {
    key     = 'venn_diagram',
    atlas   = sprites,
    pos     = get_pos(3,7),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { mult = 6 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.mult))
    end,
    calculate = function(self, card, context)
        -- so basically i'm monke
        if (context.individual and context.cardarea == G.play
            and not MadLib.has_suit_in_list(context.other_card, MadLib.RankTypes.Base)
            and not Madcap.has_rank_in_list(context.other_card, MadLib.SuitTypes.Base))
            or context.forcetrigger -- demicolon compat
        then -- has to have custom rank and suit
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult,card,card.ability.extra.mult)
        end
    end

}

local function continuum_effect(list,starting_point)
    -- double trigger to the left
    tell('Continuum Effect')
    for i = starting_point, 1, -1 do
        local card = list[i]
        MadLib.event({
            trigger = 'after',
            delay = 1.8,
            blockable = false,
            func = function()
                play_sound((sound or 'tarot2'), 0.76, 0.4)
                return {
                    message = localize('...'),
					colour = G.C.FILTER,
                    repetitions = 1,
                    card = card
                }
            end
        })return
    end
end

-- 39. Continuum
local continuum = {
    key     = 'continuum',
    atlas   = sprites,
    pos     = get_pos(3,8),
    rarity  = 2,
    cost    = 9,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = false, -- dont think you can demicolon this?
    config =  {
        extra = { retrigger_cards = 1 },
        immutable = { current_position = 0 },
        active = false
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.retrigger_cards))
    end
    -- no calculation here - mostly happens using lovely shenanigans
}

-- 40. Three Trees
local three_trees = {
    key     = 'three_trees',
    atlas   = sprites,
    pos     = get_pos(3,9),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { x_mult = 3, active = false }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.x_mult))
    end,
    calculate = function(self, card, context)
        -- before scoring, see if the hand passes the VIBE test
		if
            context.cardarea == G.jokers
            and context.before and
            not context.blueprint
        then
            local suits = {nil, nil, nil} -- light, dark, modded

			for k, v in ipairs(context.scoring_hand) do -- check for all fibonacci
                if not suits[1] then -- needs light suit
                    if MadLib.has_suit_in_list(v, MadLib.SuitTypes.Light) then
                        suits[1] = v.base.suit
                    end
                end
                if not suits[2] then -- needs dark suit
                    if MadLib.has_suit_in_list(v, MadLib.SuitTypes.Dark) then
                        suits[2] = v.base.suit
                   return end
                end
                if not suits[3] then -- needs modded suit
                    if not MadLib.has_suit_in_list(v, MadLib.SuitTypes.Base) -- modded
                    and v.base.suit ~= suits[1]
                    and v.base.suit ~= suits[2] then
                        suits[3] = v.base.suit
                    end
                end
			end
			card.ability.extra.active = suits[1] and suits[2] and suits[3] -- all three must be filled
        end

        if
            (context.joker_main and card.ability.extra.active)
            or context.forcetrigger
        then -- demicolon
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
        end
    end
}

-- 41. Jimbo's Funeral (TESTED!)
local jimbos_funeral = {
    key     = 'jimbos_funeral',
    atlas   = sprites,
    pos     = get_pos(4,0),
    rarity  = 3,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { active = true }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.active and localize("k_active_ex") or localize("rgmc_inactive"))
    end,
    calculate = function(self, card, context)
        if context.setting_blind then -- active!
            card.ability.extra.active = true
        end

        -- show it's about to POP OFF!
        if
            context.before
            and G.GAME.current_round.hands_left == 1
            and card.ability.extra.active
            and not context.blueprint
        then
            local eval = function() return G.GAME.current_round.hands_left == 0 end
            juice_card_until(card, eval, true)
        end

        -- changes hands and discards before you can get a game over
        -- if you have 0 discards, don't even bother!
        if
            (context.joker_main and G.GAME.current_round.discards_left > 0)
            and ((card.ability.extra.active and G.GAME.current_round.hands_left == 0
                and not context.blueprint) or context.forcetrigger)
        then
            -- do the thing RIGHT NOW
            ease_discard(G.GAME.current_round.hands_left-G.GAME.current_round.discards_left, nil, true)
            ease_hands_played(G.GAME.current_round.discards_left)
            -- give safe message

            if not context.forcetrigger then -- if demicolon'd, don't
                card.ability.extra.active = false -- activated for the round

                -- do the stuff
                MadLib.event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        return {
                            message = localize("k_upgrade_ex"), -- Safe!
                            card = card,
                        }
                    end
                })
            end
        end
    end
}

-- 42. Shovel Joker
local shovel_joker = {
    key     = 'shovel_joker',
    atlas   = sprites,
    pos     = get_pos(4,1),
    rarity  = 3,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { x_mult = 2 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.x_mult))
    end,
    calculate = function(self, card, context)

        if
            context.cardarea == G.play
            and (context.individual
                and context.other_card
                and context.other_card.base.value == "rgmc_knight") -- is a knight card
                and Madcap.Funcs.card_suit_in_list(context.other_card,dark_suits)
            or context.forcetrigger -- demicolon
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
        end
    end
}

-- 43. Rhodochrosite
local rhodochrosite = {
    key     = 'rhodochrosite',
    atlas   = sprites,
    pos     = get_pos(4,2),
    rarity  = 3,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        active = false,
        extra = { mult = 6, chips = 30, suits = { "Diamonds", "Spades", "Clubs" } }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
            number_format(card.ability.extra.suits[1]),
            number_format(card.ability.extra.suits[2]),
            number_format(card.ability.extra.suits[3]),
            number_format(card.ability.extra.mult),
            number_format(card.ability.extra.chips))
    end,
    calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.other_card
            and not context.after
            and not context.before
            and not context.blueprint
        then
            if -- clubs or spades activates
                context.other_card:is_suit(card.ability.extra.suits[1]) -- Diamonds
            then
                local active = nil -- needs a diamond suit to activate
                for i=1,#context.scoring_hand do
                -- if club or spade suit
                    if context.scoring_hand[i] == context.other_card then
                        break -- bruh it's the same damn card
                    else
                        active = (context.scoring_hand[i]:is_suit(card.ability.extra.suits[2])
                                and card.ability.extra.suits[2])
                                or (context.scoring_hand[i]:is_suit(card.ability.extra.suits[3])
                                and card.ability.extra.suits[3])
                        if active then
                            break -- we are done here
                        end
                    end
                end
                if active == card.ability.extra.suits[2] then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
                elseif active == card.ability.extra.suits[3] then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
                end
            end
        end

        if context.forcetrigger then
            MadLib.simple_event(function()
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end, 0.3, 'immediate')
            MadLib.simple_event(function()
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end, 0.3, 'immediate')
		end
    end
}

-- 44. Waveworx
local waveworx = {
    key     = 'waveworx',
    atlas   = sprites,
    pos     = get_pos(4,3),
    rarity  = 3,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true, -- just allows you to make another straight
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(G.GAME.current_round.hands_played == 0 and localize("k_active_ex") or localize("rgmc_inactive"))
    end,
    calculate = function(self, card, context)

        if -- the card is activated
            context.setting_blind
            or context.forcetrigger
        then
            G.GAME.MADCAP.force_poker_hand = "Straight"
            local eval = function() return G.GAME.current_round.hands_played > 0 end
            juice_card_until(card, eval, true)
        end

        if -- after playing, no more straights!
            G.GAME.current_round.hands_played == 0
            and context.after
        then
            G.GAME.MADCAP.force_poker_hand = nil
        end
    end
}

-- 45. La Jokeonde
local la_jokeonde = {
    key     = 'la_jokeonde',
    atlas   = sprites,
    pos     = get_pos(4,4),
    rarity  = 3,
    cost    = 9,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { extra = 1 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.extra or 1)
    end,
    calculate = function(self, card, context)

        if
            ((context.joker_main and MadLib.meets_blind_requirements())
            or context.forcetrigger)
            and context.scoring_hand
        then

			for _, v in pairs(context.scoring_hand) do v.jokeonde = true end

            MadLib.loop_check_func_limited(G.play.cards, function(v)
                return not (v.jokeonde or v.edition)
            end, function(v)
                MadLib.simple_event(function()
                    v:set_edition(MadLib.get_weighted_edition(), true)
                    return true
                end)
            end, card.ability.extra.extra)
        end

        if context.after and not context.blueprint then
			for _, v in ipairs(context.scoring_hand) do v.jokeonde = nil end
        end
    end
}

-- 46. Miracle Pop
local miracle_pop = {
    key     = 'miracle_pop',
    atlas   = sprites,
    pos     = get_pos(4,5),
    rarity  = 3,
    cost =   8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = false,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { chips = 0, chip_mod = 5, suits = { "Hearts", "rgmc_goblets" } }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
            card.ability.extra.suits[1],
            card.ability.extra.suits[2],
            number_format(card.ability.extra.chip_mod),
            number_format(card.ability.extra.chip_mod * 2),
            number_format(card.ability.extra.chips),
            number_format(G.hand and #G.hand.cards or 0),
            number_format((G.hand and #G.hand.cards > 1)
                and math.floor(card.ability.extra.chips / #G.hand.cards) or 0))
    end,
    calculate = function(self, card, context)
        if
            (context.cardarea == G.play
                and context.other_card
                and not context.blueprint)
            or context.forcetrigger
        then
            if -- hearts and goblets
                context.other_card:is_suit(card.ability.extra.suits[1])
                or context.other_card:is_suit(card.ability.extra.suits[2])
            then
                local upgrade =
                    context.other_card:is_suit(card.ability.extra.suits[2])
                    and card.ability.extra.chip_mod * 2
                    or  card.ability.extra.chip_mod

                return MadLib.get_detailed_upgrade_data(MadLib.ScoreKeys.AddChips, card, upgrade)
            end
        end

        -- selling divides the chips among the cards
		if
            context.selling_self
        then
            local div = math.floor(card.ability.extra.chips/#G.hand.cards)
            for i = 1, #G.hand.cards do
                local target = G.hand.cards[i]
                target.ability.perma_bonus = target.ability.perma_bonus + div
                target:juice_up(0.3, 0.4)
            end
		end
    end
}

-- 47. Doom Bunny
local doom_bunny = {
    key     = 'doom_bunny',
    atlas   = sprites,
    pos     = get_pos(4,6),
    rarity  = 3,
    cost    = 10,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = false, -- choose a random wild card in hand to do this with instead
    calculate = function(self, card, context)

        if
            context.individual
            and context.cardarea == G.play
            and #G.playing_cards > 1    -- does not work if you have only 1 card
        then
            -- wild card
            if SMODS.has_enhancement(context.other_card,'m_wild') then

                -- Don't do a thing if the card is debuffed
                if context.other_card.debuff then return MadLib.get_debuff_data(card) end

                -- Not the other card, and either not a wild card or a wild card with edition/seal
				local from_card, to_card = context.other_card, MadLib.get_cards_from_shuffled_deck(
                    G.playing_cards, #G.playing_cards, function(v)
                    return context.other_card ~= v and
                        (not v.config.center ~= G.P_CENTERS.m_wild
                            or card.edition
                            or card:get_seal())
				end)[1]

                -- FROM_CARD enhancements, editions, and seals from TO_CARD
                if from_card and to_card then
                    Madcap.Funcs.flip_cards({ from_card }, function(v)
                        MadLib.copy_card_settings(v, to_card, {
                            enhancements = true, editions = true, seals = true
                        })
                    end)
                end
            end
        end

    end
}

-- 48. Rocket Keychain
local rocket_keychain = {
    key     = 'rocket_keychain',
    atlas   = sprites,
    pos     = get_pos(4,7),
    rarity  = 3,
    cost    = 10,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = false,
    config =  {
        extra = { level_ups = 1, target_hand = "High Card" }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.target_hand,
                number_format(card.ability.extra.level_ups),
                MadLib.get_most_played_hand())
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.target_hand = MadLib.get_random_poker_hand()
            MadLib.simple_event(function()
                play_sound((sound or 'tarot2'), 0.76, 0.4)
                card:juice_up(0.3, 0.4)
            end)
        end
    end
}

-- 49. Rio
-- enchanted aces are BUFFED? what does that mean?
local legend_rio = {
    key     = 'legend_rio',
    atlas   = 'jokers_legendary',
    pos        = legend(1,false),
	soul_pos   = legend(1,true),
    rarity     = 4,
    cost       = 15,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = false,
    config =  {
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(localize(Madcap.Funcs.get_rio_rank(), 'ranks') .. "s")
    end,
    calculate = function(self, card, context)
		if
			context.cardarea == G.play
			and context.other_card -- must be another card
			and context.other_card:get_id() == "Ace" -- base value must be an ace
		then
            -- just a visual gag
            return {
                message = localize('rgmc_ace_ex'),
				card = context.other_card
            }
		end
    end
}

-- 50. Lemonade Picky
local legend_picky = {
    key     = 'legend_picky',
    atlas   = 'jokers_legendary',
    pos        = legend(0,false),
	soul_pos   = legend(0,true),
    rarity     = 4,
    cost       = 15,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { x_mult = 1.75, x_mult_mult = 1.25 },
        immutable = { antes_completed = 0 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.x_mult_mult*100 - 100),
                number_format(card.ability.immutable.antes_completed))
    end,
    calculate = function(self, card, context)
        if
            not context.individual
            and context.end_of_round and G.GAME.blind.boss
            and not (context.blueprint or context.repetition)
            and not (G.GAME.blind.config and G.GAME.blind.config.bonus)
        then
            card.ability.immutable.antes_completed = card.ability.immutable.antes_completed + 1
            card.ability.extra.x_mult = card.ability.extra.x_mult * card.ability.extra.x_mult_mult -- add on 25%!
		end

        if
            context.forcetrigger
            or (context.cardarea == G.jokers and context.joker_main)
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
        end
    end
}

local jokers = {
    vari_seala,
    bball_pasta,
    squeezy_cheeze,
    joker_squared,
    spectator,
    lady_liberty,
    neighborhood_watch,
    penrose_stairs,
    quick_brown_fox,
    house_of_cards,
    glass_michel,
    chinese_takeout,
    easter_egg,
    null_and_void,
    deceitful_joker,
    pretentious_joker,
    pentagon,
    barbershop_joker,
    cup_of_joeker,
    supreme_with_cheese,
    redd_dacca,
    bluenana,
    changing_had,
    ball_breaker,
    thorium_joker,
    twinkle_of_contagion,
    iron_joker,
    tungsten_joker,
    jeweler_joker,
    plentiful_ametrine,
    toughened_shungite,
    six_shooter,
    conspiracy_wizard,
    cavalier,
    blindfold_joker,
    crystal_cola,
    sigma_joker,
    venn_diagram,
    continuum,
    three_trees,
    jimbos_funeral,
    shovel_joker,
    rhodochrosite,
    waveworx,
    la_jokeonde,
    miracle_pop,
    doom_bunny,
    rocket_keychain,
    legend_rio,
    legend_picky
}


local list = {}

for i=1, #jokers do
	jokers[i].object_type = "Joker"
    list[i] = jokers[i]
end

for i=1, #list do
    if list[i] then list[i].order = i-1 end
end

return {
    name = "Jokers",
    init = function() print("Jokers!") end,
    items = list
}
