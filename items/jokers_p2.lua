local sprites = 'jokers'

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


-- 51. Primordial Joker
local primordial_joker = {
    key     = 'primordial_joker',
    rarity  = 1,
    cost    = 5,
    pos     = get_pos(5,0),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = { extra = { mult = 4 } },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.mult,
            card.ability.extra.mult * (G.GAME and G.GAME.Mayhem or 0))
	end,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult * (G.GAME and G.GAME.Mayhem or 0))
        end
    end
}

-- 52. Liberty Bell
local liberty_bell = {
    key     = 'liberty_bell',
    rarity  = 1,
    cost    = 3,
    pos     = get_pos(5,1),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { seals = 1 },
        immutable = { max_seals = 10 }
    },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { set = "Other", key = "rgmc_bronze_seal" }
		return MadLib.collect_vars(math.floor(math.min(card.ability.extra.seals, card.ability.immutable.max_seals)))
	end,
    calculate = function(self, card, context)
        if
            (context.discard
            and G.GAME.current_round.discards_used == 0)
            or (context.forcetrigger and G.hand.cards)
        then -- first discard = apply bronze seal and 15 bonus chips
            local area = context.discard and G.hand.highlighted or G.hand.cards

            MadLib.loop_check_func_limited(area, function(v)
                return not v.seal
            end, function(v)
                MadLib.simple_event(function()
                    v:set_seal('rgmc_bronze', true)
                    v:juice_up(0.3,0.3)
                    play_sound('tarot2', 1.2, 0.4)
                    return true
                end, 0.4, 'before')

            end, math.min(card.ability.extra.seals, card.ability.immutable.max_seals))
        end
    end
}

-- 53. Joker in Binary
local joker_in_binary = {
    key     = 'joker_in_binary',
    rarity  = 1,
    cost    = 4,
    pos     = get_pos(5,2),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    generate_ui = Madcap.Funcs.generate_special_ui,
	long_title = {
        'a.k.a. \"01001010 01101111',
        '01101011 01100101 01110010\"'
	},
    config = {
        extra = { chips = 32 }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.chips)
	end,
    calculate = function(self, card, context)
        if
            (context.cardarea == G.play and context.other_card)
            or context.forcetrigger
        then
			local _id = context.other_card:get_id()
			if
                context.forcetrigger
                or _id == SMODS.Ranks[MadLib.RankIds['1']].id
                or _id == SMODS.Ranks[MadLib.RankIds['0']].id
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
			end
        end
    end
}

-- 54. Sticker Shock
local sticker_shock = {
    key     = 'sticker_shock',
    pos     = get_pos(5,3),
    rarity  = 1,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { chips = 20 }
    },
    in_pool = function()
        -- if eternals/perishables/rentals/pinned are available in shop
        return G.GAME.modifiers.enable_eternals_in_shop
            or G.GAME.modifiers.enable_perishables_in_shop
            or G.GAME.modifiers.enable_rentals_in_shop
            or G.GAME.modifiers.cry_enable_pinned_in_shop
            or #MadLib.get_stickered_cards() > 2 -- # of bad-stickered jokers
    end,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.chips * #MadLib.get_stickered_cards())
    end,
    calculate = function(self, card, context)
		if
            (context.before or context.forcetrigger)
        then
            local group = MadLib.get_stickered_cards()
            if group and #group > 0 then
                MadLib.loop_func(group, function(v)
                    MadLib.simple_event(function()
                        v:juice_up(0.2, 0.5)
                        return true
                    end, 0.1, 'immediate')
                end)

                MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
			end
		end
    end
}

-- 55. Bolstered Joker
local bolstered_joker = {
    key     = 'bolstered_joker',
    rarity  = 1,
    cost    = 4,
    pos     = get_pos(5,4),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { mult = 20, type = 'Pyramid' }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.mult, card.ability.extra.type)
	end,
	calculate = function(self, card, context)
		if
            (context.joker_main
            and next(context.poker_hands["rgmc_pyramid"]))
            or context.forcetrigger
        then
			return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
		end
	end,
}

-- 56. Fortified Joker
local fortified_joker = {
    key     = 'fortified_joker',
    rarity  = 1,
    cost    = 4,
    pos     = get_pos(5,5),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { chips = 90, type = 'Pyramid' }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.type)
	end,
	calculate = function(self, card, context)
		if
            (context.joker_main
            and next(context.poker_hands["rgmc_pyramid"]))
            or context.forcetrigger
        then
			return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
		end
	end,
}

-- 57. nope.jkr
local nope_joker = {
    key     = 'nope_joker',
    rarity  = 1,
    cost    = 4,
    pos     = get_pos(5,6),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { odds = 4, odds2 = 3 }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(
            MadLib.base_prob(card),
            card.ability.extra.odds,
            card.ability.extra.odds2)
	end,
	calculate = function(self, card, context)
		if
            ( context.before )
            or context.forcetrigger
        then
            local add = 0
            local discarding = context.pre_discard and true or false

            if MadLib.calculate_roll({
                card    = card,
                denom   = card.ability.extra.odds -- add hand/discard
            }) then -- add hand or discard
                add = 1
            end

            if MadLib.calculate_roll({
                card    = card,
                exp     = card.ability.extra.odds2 -- remove hand/discard
            }) then -- remove hand or discard
                add = add - 1
            end

            if discarding then -- hand
                ease_discard(add)
            else -- discard
                ease_hands_played(add)
            end

            if add == 0 then --
                return {
                    message = localize("k_nope_ex"),
                    colour  = discarding and G.C.RED or G.C.BLUE
                }
            elseif add == 1 then -- add
                return {
                    message = localize({
                        type = "variable",
                        key = "a_" .. (discarding and "discard" or "hand") .. "_plus",
                        colour  = discarding and G.C.RED or G.C.BLUE,
                        vars = { add }
                    }),
                }
            else -- subtract
                return {
                    message = localize({
                        type = "variable",
                        key = "a_" .. (discarding and "discard" or "hand") .. "_minus",
                        colour  = discarding and G.C.RED or G.C.BLUE,
                        vars = { add }
                    }),
                }
            end
		end
	end,
}

-- 58. Solar Eclipse
local solar_eclipse = {
    key     = 'solar_eclipse',
    rarity  = 1,
    cost    = 6,
    pos     = get_pos(5,7),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { x_chips = 1.15, type = 'Light' }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.x_chips, card.ability.extra.type)
	end,
	calculate = function(self, card, context)
		if
            (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_light'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.x_chips)
		end
	end,
}

-- 59. Lunar Eclipse
local lunar_eclipse = {
    key     = 'lunar_eclipse',
    rarity  = 1,
    cost    = 6,
    pos     = get_pos(5,8),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { x_mult = 1.30, type = 'Dark' }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.x_mult, card.ability.extra.type)
	end,
	calculate = function(self, card, context)
		if
            (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_dark'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
		end
	end,
}
-- 60. Radioactive Chinese
local radioactive_chinese = {
    key     = 'radioactive_chinese',
    pos     = get_pos(5,9),
    rarity  = 1,
    cost    = 9,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            odds = 3,
            rounds_remaining = 8,
            effects = {
                { 1.5,   0.95 },  -- Xscore
                { 1.5,   0.75 },  -- Xmult
                { 1.5,   0.85 },  -- Xchips
                { 0.25,  0.70 },  -- Xmult
                { 0.25,  0.80 },  -- Xmult
                { 1.12,  0.5 }   -- Escore
            }
        },
        immutable = { mode = 1 }
    },
    loc_vars = function(self, info_queue, card)
        local str = "null"
		if
            card.ability.immutable.mode > 0
            and card.ability.immutable.mode < 8
        then
             str = "rgmc_rad_chinese_effect"..tostring(card.ability.immutable.mode)
        end

        tell(card.ability.immutable.mode)

		info_queue[#info_queue + 1] = {
            set = "Other",
            key = str,
            vars = {
                card.ability.extra.effects[card.ability.immutable.mode][1], -- THE SUCCEED
                math.max(card.ability.extra.odds - MadLib.base_prob(card), 1), -- NOT X in Y
                card.ability.extra.odds,
                card.ability.extra.effects[card.ability.immutable.mode][2], -- THE FAIL
            }
        }

        return MadLib.collect_vars(card.ability.extra.rounds_remaining)
    end,
    calculate = function(self, card, context)

        -- Start of blind
        if
            context.setting_blind
            and not context.blueprint
        then

            local new_food = math.random(1, 6)
            card.ability.immutable.mode = new_food

            if -- if doable, show a line
                card.ability.immutable.mode > 0
                and card.ability.immutable.mode <= 6
            then
                return { message = localize("rgmc_rad_chinese_line" .. card.ability.immutable.mode) }
            end
		end

        -- At scoring time...
		if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            local passes =  MadLib.calculate_roll({ card = card, seed = 'rgmc_radioactive_chinese_' .. tostring(card.ability.immutable.mode) })
            local val = passes and 1 or 2

            tell('Value: '..number_format(card.ability.extra.effects[card.ability.immutable.mode]))
            if
                card.ability.immutable.mode == 1 -- radioactive stir fry (Xscore)
            then
                -- Xscore
                card.ability['rgmc_e_score'] = val
                return {
                    message = "...!?",
                    colour = G.C.PURPLE
                }
            elseif
                card.ability.immutable.mode == 2
                or card.ability.immutable.mode == 4
            then
                -- +chip
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.effects[card.ability.immutable.mode])
            elseif
                card.ability.immutable.mode == 3
                or card.ability.immutable.mode == 5
            then
                -- +mult
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.effects[card.ability.immutable.mode])
            else
                card.ability['rgmc_e_score'] = 1
                return {
                    message = "...!?",
                    colour = G.C.PURPLE
                }
            end
        end

        if context.after then
        end

        -- End of round
		if Madcap.Funcs.get_end_of_round(context) then
            return MadLib.food_joker_logic(card)
        end
    end
}

-- 61. Outrageous Joker
local outrageous_joker = {
    key     = 'outrageous_joker',
    rarity  = 1,
    cost    = 6,
    pos     = get_pos(6,0),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { mult = 18, type = 'Dazzling' }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.mult, card.ability.extra.type)
	end,
	calculate = function(self, card, context)
		if
            (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_enhanced'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
		end
	end,
}

-- 62. Flamboyant Joker
local flamboyant_joker = {
    key     = 'flamboyant_joker',
    rarity  = 1,
    cost    = 6,
    pos     = get_pos(6,1),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { chips = 70, type = 'Dazzling' }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.type)
	end,
	calculate = function(self, card, context)
		if
            (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_enhanced'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
		end
	end,
}

-- 63. Voracious Joker
local voracious_joker = {
    key     = 'voracious_joker',
    pos     = get_pos(6,2),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { mult = 6, suit = 'rgmc_blooms' }
    },
    loc_vars = function(self, info_queue, card)
        local ret = MadLib.collect_vars(card.ability.extra.mult, localize(card.ability.extra.suit, 'suits_singular'))
        ret.colours = { G.C.SUITS[card.ability.extra.suit] }
		return ret
    end,
    calculate = function(self, card, context)
        if
            context.individual
            and context.cardarea == G.play
            and context.other_card:is_suit(card.ability.extra.suit)
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
        end
    end,
}

-- 64. Arrogant Joker
local arrogant_joker = {
    key     = 'arrogant_joker',
    pos     = get_pos(6,3),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { mult = 6, suit = 'rgmc_daggers' }
    },
    loc_vars = function(self, info_queue, card)
        local ret = MadLib.collect_vars(card.ability.extra.mult, localize(card.ability.extra.suit, 'suits_singular'))
        ret.colours = { G.C.SUITS[card.ability.extra.suit] }
		return ret
    end,
    calculate = function(self, card, context)
        if
            context.individual
            and context.cardarea == G.play
            and context.other_card:is_suit(card.ability.extra.suit)
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
        end
    end,
}

local function set_edition_flipped(target)
    local success = (not target.edition) or target.edition.rgmc_flipped
    MadLib.simple_event(function()
        if success then
            local flip = not (target.edition and target.edition.rgmc_flipped)
            target:set_edition({ rgmc_flipped = flip }, true)
            target:juice_up(0.5, 0.7)
            play_sound('tarot2', 0.76, 0.4)
        end
        return true
    end, 1.0, 'after')
    return success
end

-- 65. Captain Viridian
local captain_viridian = {
    key     = 'captain_viridian',
    pos     = get_pos(6,4),
    rarity  = 2,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { chips = 36, odds = 6 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.chips, MadLib.base_prob(card), card.ability.extra.odds)
    end,
    calculate = function(self, card, context)
        -- scaling
        if 
            context.forcetrigger
            or (context.cardarea == G.play 
                and context.other_card
                and MadLib.calculate_roll({ card = card, seed = 'rgmc_captain_viridian' }))
        then
            local _success = set_edition_flipped(context.other_card)
            if _success then return MadLib.simple_card_message(card, localize("rgmc_flipped_ex")) end
        end
    end
}

local balutro_list = {
    'Ace',
    '2',
    '5',
    MadLib.RankIds['1'],
    MadLib.RankIds['11'],
    MadLib.RankIds['12'],
    MadLib.RankIds['15'],
    MadLib.RankIds['21'],
    MadLib.RankIds['25']
}

-- 66. Balutro
local balutro = {
	key     = 'balutro',
    pos     = get_pos(6,5),
    rarity  = 2,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {  active = true, retriggers = 1 },
        immutable = { max_retriggers = 12 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.mult)
    end,
    calculate = function(self, card, context)
        if
            (context.forcetrigger
            and not card.ability.extra.active)
            or (context.before
            and context.scoring_hand
            and MadLib.list_matches_all(context.scoring_hand, function(v)
                return MadLib.has_rank_in_list(v, balutro_list)
            end))
        then
            card.ability.extra.active = true
            return {
                message = localize("k_active_ex"),
                colour = G.C.GREEN
            }
        end

        if
            card.ability.extra.active
            and context.repetition
            and context.other_card
        then
            return MadLib.get_retrigger_data(context.other_card, lenient_bignum(math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers)))
        end
    end
}

-- 67. Vibrant Tourmaline
local vibrant_tourmaline = {
    key     = 'vibrant_tourmaline',
    pos     = get_pos(6,6),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { odds = 3, money = 0, money_mod = 1, suit = 'rgmc_blooms' }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.suit, MadLib.base_prob(card), card.ability.extra.odds, card.ability.extra.money_mod, card.ability.extra.money)
    end,
	calc_dollar_bonus = function(self, card)
		if to_big(card.ability.extra.money) > to_big(0) then
			return lenient_bignum(card.ability.extra.money)
		end
	end,
    calculate = function(self, card, context)

        -- scaling
        if
            context.cardarea == G.play
            and context.individual
            and not context.blueprint
            and context.other_card:is_suit(card.ability.extra.suit)
            and MadLib.calculate_roll({ card = card, seed = 'rgmc_vibrant_tourmaline' })
        then
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMoney, card, card.ability.extra.money_mod)
        end

        if context.forcetrigger then
            return MadLib.get_add_money_data(card)
        end

		-- reset at end of ante
        if
            not context.individual
            and context.end_of_round and G.GAME.blind.boss
            and not (context.blueprint or context.repetition)
        then
            return MadLib.get_simple_reset_data(MadLib.ScoreKeys.AddMoney, card, 'money')
        end

    end
}

-- 68. Obsidian Blade
local obsidian_blade = {
    key     = 'obsidian_blade',
    pos     = get_pos(6,7),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = { odds = 4, x_mult = 1, xmult_mod = 0.2, suit = 'rgmc_daggers' }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.suit, MadLib.base_prob(card), card.ability.extra.odds, card.ability.extra.xmult_mod, card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)

        if
            context.cardarea == G.play
            and context.individual
            and not context.blueprint
            and context.other_card:is_suit(card.ability.extra.suit)
            and MadLib.calculate_roll({ card = card, seed = 'rgmc_obsidian_dagger' })
        then
           return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.xmult_mod)
        end

        if
            (context.cardarea == G.jokers and context.joker_main and card.ability.extra.x_mult ~= 1 and card.ability.extra.x_mult > 0)
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
        end

		-- reset at end of ante
        if
            not context.individual
            and context.end_of_round and G.GAME.blind.boss
            and not (context.blueprint or context.repetition)
        then
            return MadLib.get_simple_reset_data(MadLib.ScoreKeys.MultiMult, card, 'x_mult', 1)
        end

    end
}

-- 69. Made of Honor
local made_of_honor = {
    key     = 'made_of_honor',
    rarity  = 2,
    cost    = 6,
    pos     = get_pos(6,8),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = { bismuth_adds = 1 },
        immutable = { bismuth_adds = 40 }
    },
	loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(math.floor(math.min(card.ability.extra.bismuth_adds,card.ability.immutable.bismuth_adds)))
	end,
	calculate = function(self, card, context)
		if
            (context.setting_blind and not self.getting_sliced)
            or context.forcetrigger
        then
            for i=1, math.floor(math.min(card.ability.extra.bismuth_adds, card.ability.immutable.bismuth_adds)) do
                local front = pseudorandom_element(G.P_CARDS, pseudoseed('rgmc_made_of_honor')) -- i think it's making a random'
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1

                -- this better not make invalid suits appear
                local card = Card(G.discard.T.x + G.discard.T.w/2, G.discard.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_rgmc_bismuth, {playing_card = G.playing_card})

                MadLib.simple_event(function()
                    card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                    G.play:emplace(card)
                    table.insert(G.playing_cards, card)
                    return true
                end)

                card_eval_status_text(context_blueprint_card or self, 'extra', nil, nil, nil, {
                    message = localize('k_plus_bismuth'),
                    colour = G.C.SECONDARY_SET.Enhanced
                })

                MadLib.simple_event(function()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end)

                draw_card(G.play, G.deck, 90, 'up', nil)
                playing_card_joker_effects({ card })
                return nil, true
            end
            return true
        end
	end,
}

-- 70. Jestrogen
local jestrogen = {
    key     = 'jestrogen',
    pos     = get_pos(6,9),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true, -- picks a random [rank_old] out of deck to turn into a rank_new
    config = {
        extra = {
            odds     = 5,
            rank_old = "King",
            rank_new = "Queen",
            chip_mod = 20
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(MadLib.base_prob(card), card.ability.extra.odds,  card.ability.extra.rank_old, card.ability.extra.chip_mod, card.ability.extra.rank_new)
    end,
    calculate = function(self, card, context)

        if
            context.cardarea == G.play
            and context.other_card
            and context.scoring_hand
        then
            if MadLib.calculate_roll({ card = card, seed = 'rgmc_jestrogen' }) then
                if MadLib.get_card_value(context.other_card) == card.ability.extra.rank_old then
                    -- do the new thing
                    local target = context.other_card
                    MadLib.simple_event(function()
                        play_sound('rgmc_flourish', 1, 0.4)
                        target:set_rgmc_immutable(true)
                        target:juice_up()
                        target.ability.perma_bonus = (target.ability.perma_bonus or 0) + card.ability.extra.chip_mod
                        SMODS.change_base(target, _, card.ability.extra.rank_new)
                    return true
                    end, 0.2, 'immediate')
                end
            end
        end

        if context.forcetrigger then
            local targets = MadLib.get_card_from_shuffled_deck(G.hand.cards, 1, function(c)
                return MadLib.get_card_value(c) == card.ability.extra.rank_old
            end)

            MadLib.loop_func(targets, function(v)
                MadLib.simple_event(function()
                    play_sound('rgmc_flourish', 0.76, 0.4)
                    target:juice_up()
                    target.ability.perma_bonus = (target.ability.perma_bonus or 0) + card.ability.extra.chip_mod
                    SMODS.change_base(target, _, card.ability.extra.rank_new)
                return true
                end, 0.2, 'immediate')
            end)
        end
    end
}

-- 71. Pogladontasaurus
local pogladontasaurus = {
    key     = 'pogladontasaurus',
    rarity  = 2,
    cost    = 6,
    pos     = get_pos(7,0),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = false,
    config = {
        extra = { retriggers = 2, rank = "2", },
        immutable = { max_retriggers = 20, active = false }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.rank, math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers))
	end,
    calculate = function(self, card, context)

        if
            context.individual
            and context.cardarea == G.hand
            and context.other_card
            and not context.end_of_round
        then
            if MadLib.get_card_value(context.other_card) == card.ability.extra.rank then
                card.ability.immutable.active = true
                return { 
                    message = localize('k_again_ex'), 
                    repetitions = math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers), 
                    card = card
                }
            end
        end

        -- TODO: see if you can force trigger cards?

        if -- choose a new rank
            (context.after and card.ability.immutable.active)
            or (context.end_of_round and context.cardarea == G.jokers)
            or context.forcetrigger
        then
            local pick = MadLib.shuffle_sort_list(G.playing_cards, 1, function(v)  return true end)
            card.ability.immutable.active = false
            if pick then card.ability.extra.rank = pick[1]:get_id() end
            return { -- new rank
                message = "!",
                card    = card,
                func    = function()
                    play_sound('rgmc_pogladontasaurus', 1, 0.5)
                    return true
                end
            }
        end
    end
}


-- 72. Sanguine
local sanguine = {
    key     = 'sanguine',
    pos     = get_pos(7,1),
    rarity  = 2,
    cost    = 9,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config = {
        extra = {
            suits = {'rgmc_goblets', 'rgmc_daggers' },
            x_mult = 1.25
        }
    },
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)
		if
            (context.joker_main and context.scoring_hand)
            or context.forcetrigger
        then
            local pass = context.forcetrigger

            if not pass and context.scoring_hand then
                pass = MadLib.list_matches_one(context.scoring_hand, function(v)
                    return v:is_suit(card.ability.extra.suits[1])
                end) and MadLib.list_matches_one(context.scoring_hand, function(v)
                    return v:is_suit(card.ability.extra.suits[2])
                end)
            end

            if pass then -- forcetriggered OR passes the thing
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
            end
        end
    end
}

-- 73. Stonebound
local stonebound = {
    key     = 'stonebound',
    pos     = get_pos(7,2),
    rarity  = 2,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config = {
        extra = {
            suits = {'rgmc_towers', 'rgmc_blooms' },
            chips = 75
        }
    },
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.chips)
    end,
    calculate = function(self, card, context)
		if
            (context.joker_main and context.scoring_hand)
            or context.forcetrigger
        then
            local pass = context.forcetrigger

            if not pass and context.scoring_hand then
                pass = MadLib.list_matches_one(context.scoring_hand, function(v)
                    return v:is_suit(card.ability.extra.suits[1])
                end) and MadLib.list_matches_one(context.scoring_hand, function(v)
                    return v:is_suit(card.ability.extra.suits[2])
                end)
            end

            if pass then -- forcetriggered OR passes the thing
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end
        end
    end
}

Madcap.Metals = {
    held = {
        'm_steel',
        'm_gold'
    },
    score = {
        'm_rgmc_ferrous',
        'm_rgmc_wolfram'
    }
}

-- 74. Metallurgist
local metallurgist = {
    key     = 'metallurgist',
    pos     = get_pos(7,3),
    rarity  = 2,
    cost    = 6,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = false,
    config =  {
        extra = { retriggers = 1 },
        immutable = { max_retriggers = 40 }
    },
    loc_vars = function(self, info_queue, card)
        local metals = {}
        MadLib.loop_table(Madcap.Metals, function(k,v)
            MadLib.loop_func(Madcap.Metals[k], function(v)
                table.insert(metals, v)
            end)
        end)
        print(metals)
        for i=1, #metals do
            local m = metals[i]
            if G.P_CENTERS[m] then
                info_queue[#info_queue + 1] = G.P_CENTERS[m]
            end
        end
        return Madcap.BlankVar
    end,
    calculate = function(self, card, context)

        if context.repetition then
            local pass = nil

            if context.cardarea == G.hand then
                if context.playing_card_end_of_round then -- end of round stuff
                    pass = MadLib.has_enhancement_in_list(context.other_card, Madcap.Metals.held)
                else -- held in hand
                    pass = MadLib.has_enhancement_in_list(context.other_card, Madcap.Metals.held)
                end
            elseif context.cardarea == G.play then -- played
                pass = MadLib.has_enhancement_in_list(context.other_card, Madcap.Metals.score)
            end

            if pass then -- passes the test
                MadLib.simple_event(function()
                    play_sound('rgmc_wrench', 1, 0.4)
                    return true
                end, 0.2, 'after', false)
                return MadLib.get_retrigger_data(context.other_card, lenient_bignum(math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers)))
            end
        end

    end
}

-- 75. Cosmamancer
local cosmamancer = {
    key     = 'cosmamancer',
    pos     = get_pos(7,4),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config = { },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if
            (context.setting_blind
            or context.forcetrigger)
            and not (context.blueprint_card or self).getting_sliced
        then
            if
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
            then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                MadLib.simple_event(function()
                    local n_card = create_card("CosmaTarot", G.consumeables)
                    n_card:add_to_deck()
                    G.consumeables:emplace(n_card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end, 0.08, 'before')

                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_plus_cosma"), colour = G.C.PURPLE})
            end
        end
    end
}

-- 76. Arkose Michel
local arkose_michel = {
    key     = 'arkose_michel',
    pos     = get_pos(7,5),
    rarity  = 2,
    cost    = 7,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = false,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config = {
        extra = { odds = 8, mult = 10 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.mult, MadLib.base_prob(card), card.ability.extra.odds)
    end,
    calculate = function(self, card, context)

        if
            (context.cardarea == G.play and context.other_card and SMODS.has_enhancement(context.other_card, 'm_stone'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
		end
        
        if Madcap.Funcs.banana_context() then
            return MadLib.banana_logic(card, 'arkose_michel')
        end
    end
}

-- 77. Catch the Clown
local catch_the_clown = {
    key     = 'catch_the_clown',
    rarity  = 2,
    cost    = 7,
    pos     = get_pos(7,6),
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config = {
        extra = {
            chips       = 0,
            chip_mod    = 60,
            caught = false,
            failed = false,
        },
        immutable = {
            rand_id = nil,
            max_misses  = 3,
            misses      = 0,
        }
    },
	loc_vars = function(self, info_queue, card)
        local _result = (card.ability.extra.caught and 'k_mission_in_progress')
            or (card.ability.extra.failed and 'k_mission_failed')
            or 'k_mission_in_progress'
        return { 
            vars = {
                card.ability.extra.chip_mod,
                number_format(card.ability.immutable.max_misses - card.ability.immutable.misses),
                number_format(card.ability.extra.chips),
                localize(_result)
            } 
        }
	end,
    calculate = function(self, card, context)

        if 
            context.first_hand_drawn 
        then -- add clown sticker to card in first half of deck
            local _cards    = MadLib.get_possible_deck(G.deck.cards)
            local _index   =  math.floor(math.random() * #_cards) + 1
            --tell("Card is ".. tostring(_index))
            SMODS.Stickers["rgmc_clown"]:apply(_cards[_index], true)
            card.ability.extra.caught = false
            MadLib.pair_cards(card, _cards[_index],'rgmc_clown',5)
            MadLib.event({
                trigger = 'after', 
                func = function() 

                    play_sound('rgmc_clown_jingle', 1, 0.4)
                    return true 
                end
            })
        end
        
        if context.after then
            local _index = nil
            print(tostring(#G.deck.cards) .. ' cards...')
            for i=1,#G.deck.cards do
                if MadLib.compare_ids(card, G.deck.cards[i], 'rgmc_clown') then
                    _index = i
                    break
                end
            end
            tell('Index in deck is ' .. tostring(_index) .. '...')
        end

        -- Check if clown is unscoring
        if 
            not card.ability.extra.caught
            and not context.blueprint
            and context.before
        then
            local unscoring_cards = MadLib.get_list_matches(G.play.cards, function(v)
                return not MadLib.list_matches_one(context.scoring_hand, function(v2)
                    return v2 == v
                end)
            end)
            if MadLib.list_matches_one(unscoring_cards, function(v)
                return MadLib.compare_ids(card, v, 'rgmc_clown')
            end) then
                card.ability.extra.caught = false
                card.ability.extra.failed = true
                return {
                    message = "Mission Failed..."
                }
            end
        end

        if 
            context.remove_playing_cards 
            and not context.blueprint
            and not (card.ability.extra.failed or card.ability.extra.caught)
        then
            local failed = MadLib.list_matches_one(context.removed, function(v)
                return MadLib.compare_ids(card, v, 'rgmc_clown')
            end)
            if failed then
                card.ability.extra.failed = true
                return {
                    message = "Mission Failed..."
                }
            end
        end

        if -- gain chippys
            context.cardarea == G.play
            and not (card.ability.extra.failed or card.ability.extra.caught)
            and context.individual
            and context.other_card
        then
            local target = context.other_card
            if context.other_card.ids then
                print(context.other_card.ids)
            end
            if MadLib.compare_ids(card, target, 'rgmc_clown') then
                tell('Win!')
                card.ability.extra.caught = true
                card.ability.extra.failed = false
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                MadLib.pair_cards(card, target, 'rgmc_clown', nil, true)
                MadLib.event({
                    trigger = 'immediate', 
                    func = function() 
                        SMODS.Stickers["rgmc_clown"]:apply(target, false)
                        play_sound('rgmc_success', 1, 0.4)
                        return true 
                    end
                })
                MadLib.event({
                    trigger = 'after', 
                    func = function() 
                        return true 
                    end
                })
                return {
                    message     = localize('k_upgrade_ex'),
                    colour      = G.C.CHIPS,
                    card        = card
                }
            end
        end

		if -- generic joker type stuff
            (context.joker_main or context.forcetrigger)
            and card.ability.extra.chips > 0
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
        end

        if
            context.end_of_round
            and context.cardarea == G.jokers
        then
            if 
                (not card.ability.extra.caught and card.ids and card.ids['rgmc_clown'] ~= nil) 
                or card.ability.extra.failed 
            then
                MadLib.event({
                    trigger = 'immediate', 
                    func = function() 
                        play_sound('rgmc_clown_fail', 1, 0.4)
                        return true 
                    end
                })
                card.ability.immutable.misses = card.ability.immutable.misses + 1
                -- Get rid of the ID and the sticker.
                for i=1, #G.playing_cards do
                    local _card = G.playing_cards[i]
                    if MadLib.compare_ids(card, _card, 'rgmc_clown') then
                        tell('Removed Clown Seal')
                        SMODS.Stickers["rgmc_clown"]:apply(_card, false)
                        MadLib.pair_cards(card, _card, 'rgmc_clown', nil, true)
                        break
                    end
                end
                -- Remove the card altogether, you failed.
                if card.ability.immutable.misses == card.ability.immutable.max_misses then
                    return MadLib.banana_remove(card, "rgmc_spam_deathex")
                else
                    return {
                        message = localize(k_reset), -- replace with actual thing!
                        card = card,
                        colour = G.C.RED
                    }
                end
            else -- clown caught
                return {
                    message = localize(k_reset),
                    card = card,
                    colour = G.C.GREEN
                }
            end
        end
    end
}

-- 78. The Formation
local formation = {
    key     = 'formation',
    pos     = get_pos(7,7),
    rarity  = 3,
    cost    = 9,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config =  {
        extra = { x_mult = 2.5, type = 'Pyramid' }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.x_mult, card.ability.extra.type)
	end,
	calculate = function(self, card, context)
		if
            (context.joker_main
            and next(context.poker_hands["rgmc_pyramid"]))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
		end
	end,
}

-- 79. All-Star Joker
local all_star_joker = {
    key     = 'all_star_joker',
    pos     = get_pos(7,8),
    rarity  = 3,
    cost    = 9,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config = {
        extra = {
            money     = 0,
            money_mod = 3
        },
        immutable = { total_sum = 24 }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.immutable.total_sum, card.ability.extra.money_mod, card.ability.extra.money)
	end,
	calc_dollar_bonus = function(self, card)
		if to_big(card.ability.extra.money) > to_big(0) then
            local cash = card.ability.extra.money
            card.ability.extra.money = 0
			return lenient_bignum(cash)
		end
	end,
    calculate = function(self, card, context)

		if -- check if sum equals 24
            (context.before
            and MadLib.get_hand_sum(context.scoring_hand) == card.ability.immutable.total_sum)
        then
            MadLib.loop_func(G.jokers.cards, function(v)
                MadLib.simple_event(function()
                    play_sound('tarot2', 1, 0.4)
                    v:juice_up(0.1, 0.3)
                    return true
                end, 1.0, 'after')
            end)
            MadLib.simple_event(function()
                play_sound('rgmc_all_star', 1, 0.4)
                card:juice_up(0.2, 0.5)
                --card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Hey Now!", colour = G.C.MONEY})
                return true
            end, 3.5, 'after')
            return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMoney, card, card.ability.extra.money_mod * #G.jokers.cards)
        end

        if -- forcetrigger just makes more monies
            context.forcetrigger
        then
            return MadLib.get_add_money_data(card)
        end

    end
}

-- 80. Microfiche
local microfiche = {
    key     = 'microfiche',
    pos     = get_pos(7,9),
    rarity  = 3,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = false,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config =  {
        extra = { x_mult = 1.0, xmult_mod  = 0.05 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.xmult_mod, card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)

        if
            context.cardarea == G.play
            and context.individual
            and context.other_card
        then
			local rank      = MadLib.get_value_from_id(context.other_card:get_id())
            print(context.other_card:get_id())
            print(rank)
            print(rank and rank.nominal)
            local nominal   = rank and rank.nominal or 3
			local irregular = MadLib.has_rank_in_list(MadLib.RankTypes.Irregular)

			if not irregular and nominal < 2 then -- gains the x_mult
                return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.MultiMult, context.other_card, card.ability.extra.xmult_mod)
			end
        end

        if -- give the xmult
            (context.joker_main or context.forcetrigger)
            and card.ability.extra.x_mult > 1
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
        end
    end
}

function MadLib.spectrum_played(context)
    if type(context) ~= 'table' or not context.poker_hands then return false end
    local spectrum = tostring(MadLib.SpectrumId) .. 'Spectrum'
    tell('Finding ' .. tostring(spectrum) .. '...')
    --print(context.poker_hands)
    return context.poker_hands[spectrum]
    --return next(context.poker_hands[spectrum]) and true or false
end

-- 81. The Penumbral
local penumbral = {
    key     = 'penumbral',
    pos     = get_pos(8,0),
    rarity  = 3,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config =  {
        extra = { x_mult = 2.5 }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.x_mult)
	end,
    calculate = function(self, card, context)
		if
            (context.joker_main
            and MadLib.spectrum_played(context)
            and MadLib.context_has_subhand(context,'ml_sh_dark'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
		end
    end
}

-- 82. The Photovoltaic
local photovoltaic = {
    key     = 'photovoltaic',
    pos     = get_pos(8,1),
    rarity  = 3,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config =  {
        extra = { x_mult = 2.5 }
    },
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)
		if
            (context.joker_main
            and MadLib.spectrum_played(context)
            and MadLib.context_has_subhand(context,'ml_sh_light'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
		end
    end
}

-- 83. The Palette
local palette = {
    key     = 'palette',
    pos     = get_pos(8,2),
    rarity  = 3,
    cost    = 8,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = true,
    config =  {
        extra = { x_chips = 2 }
    },
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.x_chips)
    end,
    calculate = function(self, card, context)
		if
            (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_enhanced'))
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.x_chips)
        end
    end
}

-- 84. Streemerz
-- does most of its work via overrides
local streemerz = {
    key     = 'streemerz',
    pos     = get_pos(8,3),
    rarity  = 3,
    cost    = 15,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
	demicoloncompat     = false,
    config = {
        extra = { odds = 6 }
    },
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(MadLib.base_prob(card), card.ability.extra.odds)
    end,
    calculate = function(self, card, context)
        if context.discard then
        			for _, v in ipairs(G.hand.highlighted) do
                if
                    (v.edition and v.edition['rgmc_flipped'])
                    and MadLib.calculate_card_odds(card,'rgmc_streemerz')
                then
                    set_edition_flipped(v) -- flip the card back
                end
            end
        end
    end
}

-- 85. Squash Keychain
local squash_keychain = {
    key     = 'squash_keychain',
    pos     = get_pos(8,4),
    rarity  = 3,
    cost    = 10,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true, -- create a negative of a the specified tarot (and delete a base if it exists), then randomize
    config = {
        extra = { tarot_id = "c_fool" }
    },
    loc_vars = function(self, info_queue, card)
        local tarot_id = MadLib.localize_name_text('Tarot', card.ability.extra.tarot_id)
		return MadLib.collect_vars(tarot_id)
    end,
    calculate = function(self, card, context)

		if
            (context.using_consumeable
            and context.consumeable
            and context.consumeable:get_config().key == (card.ability.extra.tarot_id)
            and not (context.consumeable).edition)
            or context.forcetrigger
        then

            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

            MadLib.simple_event(function()
                local dupe = SMODS.add_card({ key = card.ability.extra.tarot_id })
                dupe:set_edition({negative = true}, true)
                dupe:set_cost()
                G.GAME.consumeable_buffer = 0
                return true
            end, 2.0, 'after')

            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})

            -- destroys a random base of this card, if exists
            if context.forcetrigger then
                local card_to_destroy = MadLib.get_first_list_match(G.consumeables.cards, function(v)
                    return v:get_config().key == (card.ability.extra.tarot_id)
                end)
                if card_to_destroy then MadLib.handle_consumable_destroy(card_to_destroy) end
            end


            MadLib.simple_event(function()
                local new_pick = pseudorandom_element(G.P_CENTER_POOLS.Tarot, pseudoseed('rgmc_squash_keychain')).key
                card.ability.extra.tarot_id = new_pick -- pick new card?
                return true
            end, 2.0, 'after')
        end

    end
}

-- 86. Jonster Cola
local jonster_cola = {
    key     = 'jonster_cola',
    pos     = get_pos(8,5),
    rarity  = 'rgmc_unusual',
    cost    = 15,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = false, -- dependent on selling
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    calculate = function(self, card, context)
		if
            ((context.selling_self and not context.blueprint)
            or context.forcetrigger) -- will kill the jonster cola!
            and type(Madcap.Funcs.safe_get(G.GAME, "MADCAP", "best_hand") or nil) == 'table'
        then
            local best_hand = G.GAME.MADCAP.best_hand
            local list = MadLib.get_combined_list(best_hand.play, best_hand.hand)
            local playing_round = (G.hand and #G.hand.cards > 0)
            MadLib.simple_event(function()

                MadLib.simple_event(function()
                    if playing_round then
                        -- unhighlight everything
                        if #G.hand.highlighted > 0 then
                            MadLib.simple_event(function()
                                G.hand:unhighlight_all()
                                return true
                            end, 1.0, 'before')
                        end
                            -- put hands into the discard deck
                        MadLib.loop_func(G.hand.cards, function(v,i)
                            MadLib.simple_event(function()
                                draw_card(G.hand,G.discard, i*100/#G.hand.cards,'down', nil, nil, 0.15)
                                return true
                            end, 0.15, 'before')
                        end)
                    end
                    return true
                end, 0.0, 'before')
                            
                -- shuffle the whole deck
                MadLib.simple_event(function()
                    pseudoshuffle(G.deck.cards, pseudoseed('rgmc_jonster_cola'))
                    return true
                end, 0.3, 'after')
                    
                -- do the recreating
                MadLib.simple_event(function()
                    local all_cards = MadLib.dupe_from_card_info(list, function(n)
                        if playing_round then
                            G.hand:emplace(n)
                        else
                            G.deck:emplace(n)
                        end
                    end)
                    play_sound('rgmc_jonster_activate', 1, 0.5)
                    return true
                end,0.0,'after')
                        
                -- effects
                MadLib.simple_event(function()
                    playing_card_joker_effects(all_cards)
                    return true
                end, 0.0, 'after')

                return true
            end, 0.0, 'immediate')
            if context.forcetrigger then -- the jonster cola has been killed (make it explode later)
                return MadLib.banana_remove(card)
            end
        end
    end
}

local function drawing_card_random(card, context)
    return (context.drawing_cards and context.amount and context.amount > 0)
        and (SMODS.drawn_cards and #SMODS.drawn_cards > 0)
        and MadLib.calculate_roll({
                card    = card,
                denom   = card.ability.extra.odds -- add hand/discard
        })
end

function MadLib.get_card_total_value(v)
    local suit          = v.base.suit
    local rank          = v.base.value
    local enhance       = v.config.center.key
    local edition       = v.edition and v.edition.key
    local seal          = v.seal -- add later
    local points        = 0

    if edition then 
        points = points + (MadLib.PointValues.Editions[edition] or 0)
    end
    if enhance then 
        points = points + (MadLib.PointValues.Enhancements[enhance] or 0)
    end

    return points
end

-- 87. X-Ray Vision
local xray_vision = {
    key     = 'xray_vision',
    pos     = get_pos(8,6),
    rarity  = 'rgmc_unusual',
    cost    = 12,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
        extra = { odds = 3, drawn_cards = 1 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
            number_format(MadLib.base_prob(card)),
            number_format(card.ability.extra.odds),
            number_format(card.ability.extra.drawn_cards or 1))
    end,
    calculate = function(self, card, context)
        if
            drawing_card_random(card, context)
            or context.forcetrigger
        then
            -- noise
            MadLib.simple_event(function()
                play_sound('rgmc_blip', 1, 0.5)
                return true
            end, 0.5, 'after')

            local cards_to_draw = math.min((card.ability.extra.drawn_cards or 1), G.deck.card_limit-1, G.hand.card_limit-1)

            local best = MadLib.shuffle_sort_list(G.deck.cards, cards_to_draw, function(v)
                return true
            end, function(a,b)
                return MadLib.get_card_total_value(a) > MadLib.get_card_total_value(b)
            end)
            
            local worst = MadLib.shuffle_sort_list(G.hand.cards, cards_to_draw, function(v)
                return true
            end, function(a,b)
                return MadLib.get_card_total_value(a) < MadLib.get_card_total_value(b)
            end)

            -- yes
            -- yes
            MadLib.simple_event(function()
                -- draw best card
                if best then  MadLib.loop_func(best, function(v,i) draw_card(G.deck, G.hand, i*100/#best, 'up', nil, v) end) end
                return true
            end, 1.0, 'after')
            MadLib.simple_event(function()
                if worst then MadLib.loop_func(worst, function(v,i) draw_card(G.hand, G.deck, i*100/#worst, 'down', nil, v) end) end
                return true
            end, 1.0, 'after')
        end
    end
}

-- 88. Weighted Die
local weighted_die = {
    key     = 'weighted_die',
    pos     = get_pos(8,7),
    rarity  = 'rgmc_unusual',
    cost    = 9,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = false,
    config = {
        extra = { odds = 6 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(
            number_format(MadLib.base_prob(card)),
            number_format(card.ability.extra.odds))
    end,
    calculate = function(self, card, context)

        if 
            (context.pre_discard or context.final_scoring_step)
            and MadLib.calculate_roll({
                card    = card,
                denom   = card.ability.extra.odds -- add hand/discard
            })
        then
            -- reverse the deck
            G.deck:reverse()
            -- noise
            MadLib.simple_event(function()
                card:juice_up(0.8, 0.4)
                play_sound('rgmc_blip', 1, 0.5)
                return true
            end, 0.5, 'before')
        end

        if context.finished_drawing then
            play_sound('rgmc_pop', 1, 0.5)
            card:juice_up(0.4, 0.2)
            G.deck:reverse()
        end

    end
}

-- 89. Roshambo!
local roshambo = {
    key     = 'roshambo',
    pos     = get_pos(8,8),
    rarity  = 'rgmc_unusual',
    cost    = 16,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
        extra = {
            mult    = 15,
            money   = 20,
            chips   = 50,
            x_mult  = 1.5
        },
        immutable = { offset = 1 }
    },
    loc_vars = function(self, info_queue, card)
        local full_vars = {
            MadLib.localize_name_text('Enhanced', 'm_stone'),
            MadLib.localize_name_text('Enhanced', 'm_lucky'),
            MadLib.localize_name_text('Enhanced', 'm_steel')
        }
        for i=1,3 do
            full_vars[#full_vars+1] = MadLib.localize_name_text('Enhanced', Madcap.Lists.Roshambo[(card.ability.immutable.offset%3+1)])
        end
        return { vars = full_vars }
    end,
    calculate = function(self, card, context)

        
    end
}

-- 90. Lucky Troll Doll
local lucky_troll_doll = {
    key     = 'lucky_troll_doll',
    pos     = get_pos(8,9),
    rarity  = 'rgmc_unusual',
    cost    = 13,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config =  {
        extra = {
            cards_to_buff = 1
        },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.cards_to_debuff }
        }
    end,
    calculate = function(self, card, context)
        if
            context.before
            and context.blueprint
        then
            card.ability.blueprint_extra = cards_to_buff
        end

		if
            context.cardarea == G.jokers
            and (context.before or context.forcetrigger)
        then
            local self_index = MadLib.get_item_index(card, G.jokers.cards)

            local end_point = math.min(self_index + (card.ability.extra.cards_to_buff + (card.ability.blueprint_extra or 0)), #G.jokers.cards)

            local jokers_to_buff = MadLib.list_pick_range(G.jokers.cards,
                math.min(self_index + 1, #G.jokers.cards), end_point)

            -- not in jokers to buff list
            local jokers_to_revert = MadLib.get_list_matches(G.jokers.cards, function(v)
                return not MadLib.list_matches_one(G.jokers.cards, function(v2)
                    return v == v2
                end) and v.rgmc_troll_doll == card
            end)

            print(#jokers_to_revert)

            MadLib.loop_func(jokers_to_revert, function(v)
                v.rgmc_troll_doll = nil
                v.ability.cry_prob = v.ability.cry_prob - v.ability.prob_add
                v.ability_prob_add = nil
                print(v.ability.cry_prob)
                MadLib.simple_event(function()
                    v:juice_up(1.3, 0.4)
                    return true
                end, 0.4, 'before')
            end)
        end

        MadLib.loop_func(jokers_to_buff, function(v)
            local odds  = v:get_odds()
            if odds and not v.rgmc_troll_doll then
                MadLib.simple_event(function()
                    v.rgmc_troll_doll = card
                    v.ability.prob_add = type(v.ability.extra) == 'table'
                        and v.ability.extra.odds / 2
                        or v.ability.extra / 2
                    v.ability.cry_prob = v.ability.cry_prob + v.ability.prob_add
                    v:juice_up(0.7, 0.5)
                    return true
                end, 1.2, 'before')
            end
        end)

        if context.after then -- handle blueprint shit
            card.ability.blueprint_extra = nil
        end
    end,
}

Madcap.GoldenHouseFuncs = {
    ['c_black_hole'] = function(t)
        local chips, mult = 0, 0

        -- Loop through all visible
        MadLib.loop_func(G.GAME.hands, function(v)
            if v.visible then
                chips   = chips + v.chips/2
                mult    = mult + v.mult/2
            end
        end)

        return chips, mult
    end,
    ['c_cry_planetlua'] = function(t)
        local chips, mult = 0, 0

        if MadLib.calculate_card_odds(t,'rgmc_golden_house') then
            -- Loop through all visible
            MadLib.loop_func(G.GAME.hands, function(v)
                if v.visible then
                    chips   = chips + v.chips/2
                    mult    = mult + v.mult/2
                end
            end)
        end

        return chips, mult
    end,
    ['c_cry_nstar'] = function(t)
        local chips, mult = 0, 0

        local random_hand = MadLib.get_random_poker_hand()
        local neutrons    = (G.GAME.neutronstarsusedinthisrun or 0) + 2
        chips   = (random_hand.chips / 2) * neutrons
        mult    = (random_hand.mult / 2) * neutrons
        return chips, mult
    end,
}

-- Returns the chips and mult for the planet hand (or hands)
function Madcap.Funcs.get_goldenhouse_chipmult(target)
    if not target then return 0, 0 end
    local chips, mult, changed = 0,0,false

    --print(target)

    if -- regular planets
        target.ability.hand_type
        and G.GAME.hands[target.ability.hand_type]
        and not target.ability.jest_spec_moon -- not aij thing
    then
        chips   = G.GAME.hands[target.ability.hand_type].chips/2
        mult    = G.GAME.hands[target.ability.hand_type].mult/2
        changed = true
    elseif
        target.ability.hand_types -- More than one hand type
    then
        -- Loop through each selected
        for _, v in pairs(target.ability.hand_types) do
            if G.GAME.hands[v] then
                chips   = chips + G.GAME.hands[v].chips/2
                mult    = mult + G.GAME.hands[v].mult/2
            end
        end
        changed = true
    elseif
        Madcap.GoldenHouseFuncs[target.ability.key] -- has a function
    then
        chips, mult = Madcap.GoldenHouseFuncs[target.ability.key](target)
        changed = true
    end

    -- Subtypes give xChip/xMult
    if target.ability.sub_type then
        local adj_xchip = ((G.GAME.subhands[k].chips - 1) * 2) + 1
        local adj_xmult = ((G.GAME.subhands[k].mult - 1) * 2) + 1
        chips  = chips * adj_xchip
        mult   = mult * adj_xmult
    end

    return math.max(chips,0), math.max(mult,0), changed
end

local ggcm_ref = Madcap.Funcs.get_goldenhouse_chipmult

if G.AIJ then -- All in Jest

    -- Compat for the fancy planet cards
    function Madcap.Funcs.get_goldenhouse_chipmult(target)
        local chips, mult, changed = ggcm_ref(target)

        if changed then return chips, mult, true end

        if
            target.ability.hand_type
            and G.GAME.hands[target.ability.hand_type]
            and target.ability.jest_spec_moon
        then
            if
                -- All in Jest - chips moon
                MadLib.list_matches_one(Madcap.Lists.Moons.Chips, function(v)
                    return 'c_aij_' .. v == target.ability.key
                end)
            then
                chips   = chips + G.GAME.hands[v].chips
                changed = true
            elseif
                -- All in Jest - mult moon
                MadLib.list_matches_one(Madcap.Lists.Moons.Mult, function(v)
                    return 'c_aij_' .. v == target.ability.key
                end)
            then
                mult    = mult + G.GAME.hands[v].mult
                changed = true
            end
        end

        return chips, mult, changed
    end

end

-- 91. Cat Planet
local cat_planet = {
    key     = 'cat_planet',
    pos     = get_pos(9,0),
    rarity  = 'rgmc_unusual',
    cost    = 13,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)

        -- When using planets (and some Spectrals), gain Mayhem.
		if
            (context.using_consumeable
            and context.consumeable
            and (context.consumeable.ability.set == 'Planet'
                or context.consumeable.ability.set == 'Spectral'))
            or context.forcetrigger
        then

            -- get the target to grab
            local target = nil
            if context.forcetrigger then
                local planets = MadLib.get_list_matches(G.consumeables.cards, function(v)
                return (v.ability.set == "Planet" or v.ability.set == "Spectral")
                    and not (v.getting_sliced or v.ability.eternal)
                end)
                target = pseudorandom_element(planets, pseudoseed("rgmc_cat_planet"))
            else
                target = context.consumeable
            end

            -- Acquire the chips/mult, convert to mayhem.
            local chips, mult, changed = Madcap.Funcs.get_goldenhouse_chipmult(target)

            --tell('CHIPS, MULT, CHANGED:')
            --print(chips)
            --print(mult)
            --print(changed)

            if changed then
                local mayhem = (chips/20 + mult/4)
                MadLib.simple_event(function()
                    Madcap.Funcs.ease_mayhem(mayhem)
                    play_sound('rgmc_meow3', 1, 0.5)
                    card_eval_status_text(context_blueprint_card or self, 'extra', nil, nil, nil, {
                        message = "+" .. number_format(mayhem),
                        colour = G.C.RGMC_MAYHEM
                    })
                    return true
                end, 0.4, 'immediate')
            end

            --[[
            if changed and (chips + mult) > 0 then
            end
            ]]

        end
    end
}

-- 92. Golden House From Pea-Guy: Pagoon
local golden_house = {
    key     = 'golden_house',
    rarity  = 'rgmc_unusual',
    cost    = 16,
    pos     = get_pos(9,1),
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
        extra = { chips = 0, mult = 0 }
    },
    generate_ui = Madcap.Funcs.generate_special_ui,
	long_title = {
        "From Pac-Guy: Pagoon"
	},
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.chips,card.ability.extra.mult)
	end,
    calculate = function(self, card, context)

        if context.setting_blind or context.forcetrigger then

            local planets = MadLib.get_list_matches(G.consumeables.cards, function(v)
                return (v.ability.set == "Planet")
                    and not (v.getting_sliced or v.ability.eternal)
            end)

            local target = pseudorandom_element(planets, pseudoseed("rgmc_golden_house"))
            if target then
                MadLib.simple_event(function()
                    play_sound('rgmc_destroy_planet', 1, 0.5)
                    target:start_dissolve({G.C.RED}, nil, 1.6)
                    delay(0.5)
                    return true
                end, 2, 'after')
                
                local chips, mult, changed = Madcap.Funcs.get_goldenhouse_chipmult(target)

                -- there is chip
                if to_big(chips) > to_big(0) then
                    MadLib.simple_event(function()
                        card.ability.extra.chips = card.ability.extra.chips + chips
                        card_eval_status_text(context_blueprint_card or card, 'extra', nil, nil, nil, {
                            message = "+" .. number_format(to_big(chips)),
                            colour = G.C.CHIPS,
                            card = card
                        })
                        return true
                    end, 0.4, 'after')
                end

                -- there is mult
                if to_big(mult) > to_big(0) then
                    MadLib.simple_event(function()
                        card.ability.extra.mult = card.ability.extra.mult + mult
                        card_eval_status_text(context_blueprint_card or card, 'extra', nil, nil, nil, {
                            message = "+" .. number_format(to_big(mult)),
                            colour = G.C.MULT,
                            card = card
                        })
                        return true
                    end, 0.4, 'after')
                end

				return nil, true
            end
        end

        if
            (context.cardarea == G.jokers and context.joker_main)
            or context.forcetrigger
        then
            if card.ability.extra.mult ~= 0 or card.ability.extra.chips ~= 0 then
                return {
                    chip_mod = lenient_bignum(card.ability.extra.chips),
                    mult_mod = lenient_bignum(card.ability.extra.mult),
                }
            end
        end
    end

}

-- 93. SPAM!
local spam = {
    key     = 'spam',
    atlas   = 'rgmc_spam',
    rarity  = 'rgmc_gimmick',
    cost    = 4,
    pos     = {x = 0, y = 0},
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
        extra = {
            mult            = 13,
            chips           = 37,
            odds            = 3,
            numer_factor    = 0.1
        },
        immutable = { mode = 1 }
    },
	loc_vars = function(self, info_queue, card)
        local adv_numerator = MadLib.base_prob(card) ^ (1 + (card.ability.numer_factor or 0))
        return MadLib.collect_vars(
            number_format(card.ability.extra.mult),
            localize('rgmc_spam'),
            number_format(card.ability.extra.chips),
            localize('rgmc_maps'),
            number_format(math.ceil(adv_numerator)),
            number_format(card.ability.extra.odds)
        )
	end,
    calculate = function(self, card, context)

		if context.joker_main or context.forcetrigger then
			return {
				message = localize("rgmc_spam_ex"),
				chip_mod = lenient_bignum(card.ability.extra.chips),
				mult_mod = lenient_bignum(card.ability.extra.mult),
				func = function()
                    local sound_effect = math.random(1, 4)
                    play_sound('rgmc_spam'..tostring(sound_effect), 1, 1)
                    return true
				end
			}
		end

        if Madcap.Funcs.banana_context() then
            return MadLib.banana_logic(card, 'spam')
        end
    end
}

-- 94. Lobster Thermidor A Crevette (With A Mornay Sauce Garnished With Truffle Pâté, Brandy and a Fried Egg On Top)
local lobster_thermidor = {
    key     = 'lobster_thermidor',
    rarity  = 'rgmc_gimmick',
    cost    = 48,
    pos     = get_pos(9,3),
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    generate_ui = Madcap.Funcs.generate_special_ui,
    long_title = {
        "With A Mornay Sauce",
        "Garnished With Truffle Pâté," ,
        "Brandy, And A Fried Egg On Top"
    },
    config = {
        extra = { emult   = 0.02, extra   = 1.01 },
        immutable = { mode = 1 }
    },
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.emult, (1+card.ability.extra.emult) * card.ability.extra.extra)
	end,
    calculate = function(self, card, context)
        if
            (context.cardarea == G.jokers
            and context.joker_main)
            or context.forcetrigger
        then
            play_sound('rgmc_spam_enter', 1, 1)
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.ExpMult, card,
                card.ability.extra.e_mult)
		end
    end
}

-- Used for Chicken Jokey and Jegg Jarton.
function Madcap.Funcs.do_gimmick_generator(card,context,success_func)

    local pass = nil

    if context.forcetrigger then
        pass = true
    else
        card.ability.extra.rounds = (card.ability.extra.rounds or 0) + 1
        pass = not (card.ability.extra.rounds < card.ability.extra.max_rounds)

        -- only jiggle if it is one until the end
        if card.ability.extra.rounds + 1 == card.ability.extra.max_rounds then
            local eval = function(card)
                return card.ability.extra.rounds ~= card.ability.extra.max_rounds-1
            end
            juice_card_until(card, eval, true)
        end
    end

    if not pass then
        local full_msg = card.ability.extra.rounds .. '/' .. card.ability.extra.max_rounds
        return {
            card_eval_status_text(card, "extra", nil, nil, nil, {
                message = full_msg,
                colour = G.C.FILTER,
            }),
        }
    else -- force triggered or max rounds
        local ret = nil
        MadLib.simple_event(function()
            success_func(card)
            return true
        end, 1.0, 'after')
        return ret
    end
end

-- 95. Chicken Jokey
local chicken_jokey = {
    key     = 'chicken_jokey',
    pos     = get_pos(9,4),
    rarity  = 'rgmc_gimmick',
    cost    = 2,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
        extra = { rounds = 0, max_rounds = 4 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.max_rounds or 4, card.ability.extra.rounds or -1)
    end,
    calculate = function(self, card, context)
        if
            context.setting_blind
            or context.forcetrigger
        then
            return Madcap.Funcs.do_gimmick_generator(card, context, function(v)
                local jokey = MadLib.create_joker('popcorn', nil, 'rgmc_chicken_jockey')
                card.ability.extra.rounds = 0

                return {
                    message = localize("k_cjokey_ex"),
                    colour = G.C.RGMC_GIMMICK,
                }
            end)
        end
    end
}

-- 96. Egglike Joker
local egglike_joker = {
    key     = 'egglike_joker',
    pos     = get_pos(9,5),
    rarity  = 'rgmc_gimmick',
    cost    = 1,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
        extra = { rounds = 0, max_rounds = 4 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.max_rounds or 4, card.ability.extra.rounds or -1)
    end,
    calculate = function(self, card, context)
        if
            context.setting_blind
            or context.forcetrigger
        then
            return Madcap.Funcs.do_gimmick_generator(card, context, function(v)
                local jokey = MadLib.create_joker('egg', nil, 'rgmc_egglike')
                card.ability.extra.rounds = 0

                return {
                    message = "!!",
                    colour = G.C.RGMC_GIMMICK,
                }
            end)
        end
    end
}

-- 97.  Talking Bacteria Jim
local talking_bacteria_jim = {
    key     = 'talking_bacteria_jim',
    pos     = get_pos(9,6),
    rarity  = 'rgmc_gimmick',
    cost    = 2,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config = {
        extra = { odds = 2 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(MadLib.base_prob(card), card.ability.extra.odds)
    end,
    remove_from_deck = function(self, card, from_debuff)
        -- Remove all the mitosis stuff.
        MadLib.loop_func(G.playing_cards, function(v)
            if v.mitosis then v:start_dissolve() end
        end)
    end,
    calculate = function(self, card, context)
        if
            context.first_hand_drawn or context.forcetrigger
        then
            if -- Copy card
                MadLib.calculate_roll({
                    card    = card,
                    denom   = card.ability.extra.odds
                })
            then
                MadLib.simple_event(function()
                    local hand_cards = MadLib.shuffle_sort_list(G.hand.cards, 1, function(v) 
                        return not v.mitosis 
                    end, function(a,b)
                        return a:get_points() > b:get_points()
                    end)
                    if hand_cards then 
                        MadLib.simple_event(function()
                            local new_card = copy_card(hand_cards[1], nil, nil, self.playing_card)
                            new_card:add_to_deck()
                            table.insert(G.playing_cards, new_card)
                            G.hand:emplace(new_card)
                            new_card.area = G.hand
                            new_card.mitosis = true
			                play_sound('rgmc_pop', 1, 1)
                            return true
                        end, 1.0, 'after')
                    end
                    return true
                end, 2.0, 'after')
            end
        end

        if -- Do the laugh
            context.pre_discard and MadLib.calculate_roll({
                card    = card,
                denom   = card.ability.extra.odds * 3
            })
        then
            MadLib.simple_event(function()
			    play_sound('rgmc_bacteria_laugh', 1, 1)
                return true
            end, 2.0, 'immediate')
            delay(0.3)
            MadLib.loop_func(G.playing_cards, function(v)
                if v.mitosis then
                    MadLib.simple_event(function()
                        v:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end, 1.0, 'after')
                end
            end)
        end

    end
}

-- 98. Smokin' Foreman
local legend_foreman = {
    key         = 'legend_foreman',
    atlas       = 'jokers_legendary',
    pos         = legend(3,false),
	soul_pos    = legend(3,true),
    rarity      = 4,
    cost        = 15,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = false,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config =  {
        extra = {
            x_mult      = 1.0,
            xmult_mod   = 0.05,
            suit        = 'rgmc_goblets'
        }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(card.ability.extra.xmult_mod, card.ability.extra.x_mult)
    end,
    calculate = function(self, card, context)
        if
            G.GAME.current_round.hands_played == 0  -- first round only!
            and context.cardarea == G.play
            and context.other_card
            and not context.other_card:is_suit(card.ability.extra.suit)
        then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.xmult_mod
            MadLib.flip_card(context.other_card,function(v)
                SMODS.change_base(v, card.ability.extra.suit, _)
            end)
            local _card = context.other_card
            MadLib.simple_event(function()
                _card:juice_up(0.5, 0.5)
                return true
            end, 1.0, 'after')
        end

        if
            context.cardarea == G.jokers and context.joker_main
            or context.forcetrigger
        then
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
        end
    end
}

-- 99. Bobby Khan
local legend_bobby = {
    key         = 'legend_bobby',
    atlas       = 'jokers_legendary',
    pos         = legend(4,false),
	soul_pos    = legend(4,true),
    rarity      = 4,
    cost        = 17,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = false,
    blueprint_compat  = false,
    demicoloncompat   = true,
    config =  {
        extra = {
        }
    },
    add_to_deck = function(self, card, from_debuff)
        -- Make the Bobby Khan noise (it's a reference to the source material.)
        play_sound('rgmc_ominous', 0.8, 0.8)
    end,
    calculate = function(self, card, context)

        if
            context.before
            and context.scoring_hand
        then
            local scored_light_cards = MadLib.get_list_matches(context.scoring_hand, function (v)
                for _,k in pairs(MadLib.SuitTypes.Light) do
                    if v:is_suit(k) then return true end
                end
                return false
            end)
            MadLib.loop_func(scored_light_cards, function (v)
                v.bobby_khan = true
            end)
        end

        if
            (context.cardarea == G.play
            and (context.other_card and context.other_card.bobby_khan))
            or context.forcetrigger
        then

            local target = not context.forcetrigger
                and context.other_card
                or pseudoshuffle(MadLib.get_list_matches(G.hand.cards, function(v)
                    return MadLib.has_suit_in_list(v, MadLib.SuitTypes.Light)
                end), pseudoseed('rgmc_bobby_khan'))[1]

            local dark_cards = MadLib.get_list_matches(G.hand.cards, function(v)
                for _,k in pairs(MadLib.SuitTypes.Dark) do
                    if v:is_suit(k) then return true end
                end
            end)

            local value = not MadLib.has_rank_in_list(MadLib.RankTypes.Irregular)
                and target.base.nominal
                or 10 -- fallback

            value = math.floor(MadLib.clamp(value,0,50) / #dark_cards)

            MadLib.simple_event(function()
                target:start_dissolve({G.C.RED}, nil, 1.6)
                return true
            end, 1.0, 'after')

            MadLib.loop_func(dark_cards, function (v)
                MadLib.simple_event(function()
                    delay(0.1)
                    v.ability.perma_bonus = (v.ability.perma_bonus or 0) + value
                    v:juice_up(0.5, 0.5)
                    play_sound("timpani")
                    return true
                end, 1.0, 'after')
            end)
        end
    end
}

-- Used for x/e vars
local percentages = {
    'x_mult', 'x_chips', 'e_mult', 'e_chips', 'x_score', 'e_score'
}

-- Mostly used
function Madcap.Funcs.get_food_joker_stats(joker)
    local key = joker.config.center.key

    local index = MadLib.get_position_in_list_prefix(key, MadLib.JokerLists.Food, 'j')
    if index == -1 then return nil end -- not a food joker

    local stats = {}

    local target = type(joker.ability.extra) == 'table'
        and joker.ability.extra
        or joker.ability

    for k,v in pairs(target) do
        stats[k] = v
    end

    for _,v in pairs(percentages) do
        if stats[v] then
            print('deduction')
            stats[v] = stats[v] - 1
        end
    end

    -- check for specific joker things
    -- chinese takeout and radioactive chinese only do stat of chosen "food"

    return stats -- must have at least one thing
end

Madcap.FoodJokerDescale = {
    ['popcorn'] = { mult = 40 },
    ['ramen']   = { x_mult = 2 }
}

-- 100. Retro Lollipop
local legend_lollipop = {
    key         = 'legend_lollipop',
    atlas       = 'jokers_legendary',
    pos         = legend(2,false),
	soul_pos    = legend(2,true),
    rarity      = 4,
    cost        = 19,
    unlocked          = true,
    discovered        = true,
    eternal_compat    = true,
    perishable_compat = true,
    blueprint_compat  = true,
    demicoloncompat   = true,
    config =  {
        extra = {
            mult    = 0,
            x_mult  = 0, -- x
            e_mult  = 0, -- x
            chips   = 0,
            x_chips = 0,
            e_chips = 0,
            money   = 0,
        },
        immutable = {
            div = 0.5
        }
    },
    loc_vars = function(self, info_queue, card)
        -- Not the best way to handle dynamic values
        -- but this'll do for now!
        for k, v in pairs(card.ability.extra) do
            if v > 0 then
                info_queue[#info_queue + 1] = {
                    set = "Other",
                    key = "rgmc_accum_"..k,
                    vars = { v }
                }
            end
        end

    end,
    calculate = function(self, card, context)

        -- Triggers whenever a compatible Food Joker loses value
        if context.food_loss then
            local t = context.food_loss.type
            local a = math.floor(context.food_loss.amount * card.ability.immutable.div)
            --print(t)
                card.ability.extra[t.set] = card.ability.extra[t.set] + a
            return {
                message = localize({
                    type    = "variable",
                    key     = t.key,
                    vars    = { number_format(lenient_bignum(to_big(a))) },
                    card    = card
                }),
                colour = t.colour
            }
        end

        -- Triggers whenever a compatible Food Joker is destroyed.
        if
            context.remove_joker
        then
            local stats = Madcap.Funcs.get_food_joker_stats(context.remove_joker)
            if stats then
                for k,v in pairs(stats) do
                    if
                        card.ability.extra[k]
                        and MadLib.ScoreKeySets[k]
                    then
                        --MadLib.ScoreKeys[MadLib.ScoreKeySets[k]]
                        card.ability.extra[k] = card.ability.extra[k] + math.floor(v * card.ability.immutable.div)
                    end
                end
                return {
                    message = localize("k_upgrade_ex"), -- Upgrade!
                    card = card,
                    colour = G.C.PURPLE
                }
            end
        end

        -- The main stuff.
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            local ret = { card = card }
            for k, v in pairs(card.ability.extra) do
                if v > 1 then -- xmult/emult/etc. handled differently
                    ret[MadLib.ScoreKeys[MadLib.ScoreKeySets[k]].add] = not k[2] == "_"
                        and v or v+1
                end
            end
            return ret
        end
    end
}

local jokers = {
    primordial_joker,
    liberty_bell,
    joker_in_binary,
    sticker_shock,
    bolstered_joker,

    fortified_joker,
    nope_joker,
    solar_eclipse,
    lunar_eclipse,
    radioactive_chinese,

    outrageous_joker,
    flamboyant_joker,
    voracious_joker,
    arrogant_joker,
    captain_viridian,

    -- uncommon
    balutro,
    vibrant_tourmaline,
    obsidian_blade,
    made_of_honor,
    jestrogen,

    pogladontasaurus,
    sanguine,
    stonebound,
    metallurgist,
    cosmamancer,

    arkose_michel,
    catch_the_clown,
    formation,
    all_star_joker,
    microfiche,

    penumbral,
    photovoltaic,
    palette,
    streemerz,
    squash_keychain,

    -- unusuals
    jonster_cola,
    xray_vision,
    weighted_die,
    roshambo,
    lucky_troll_doll,

    cat_planet,
    golden_house,

    -- gimmick wave 1
    spam,
    lobster_thermidor,
    chicken_jokey,
    egglike_joker,
    talking_bacteria_jim,

    -- legendaries
    legend_foreman,
    legend_bobby,
    legend_lollipop,
}


local list = {}

for i=1, #jokers do
	jokers[i].object_type  = "Joker" -- all are
	jokers[i].name         = name(jokers[i].key) -- ez way of joker
	jokers[i].atlas        = jokers[i].atlas or sprites
    list[i] = jokers[i]
end

for i=1, #list do
    if list[i] then list[i].order = 50+i-1 end
end

return {
    name = "Jokers Part 2",
    init = function() print("Jokers!") end,
    items = list
}
