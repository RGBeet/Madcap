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


--[[
    rigel iv
    aquaworld
    prometheus ix
    tartarus ii
    asteroid belt
    varakkis
    jurassika
    globulos
    xykulix

]]

-- banana remove effect





-- simple end of round logic
local function get_end_of_round(context)
    return context and context.end_of_round
        and not context.blueprint
        and not context.individual
        and not context.repetition
        and not context.retrigger_joker
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
    key = 'vari_seala',
    atlas = sprites,
    pos = get_pos(0,0),
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            odds = 4,
            seals = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.seals)
            }
        }
    end,
    calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.cardarea == G.hand
            and context.other_card
            and context.other_card.seal
        then

            if RGMC.funcs.calculate_card_odds(card,'vari_seala') then
                local temp_hand, finished, this_seal = {}, false, context.other_card.seal

                -- make a temp hand
                for i = 1, #G.hand.cards do
                    if not (G.hand.cards[i].seal or context.other_card) then
                        temp_hand[#temp_hand + 1] = G.hand.cards[i]
                    end
                end
                pseudoshuffle(temp_hand, pseudoseed('rgmc_vari_seala'))

                -- do it #seals time
                for i = 1, math.min(card.ability.extra.seals,#temp_hand) do -- do it X times
                    RGMC.funcs.simple_event(function()
                        temp_hand[i]:set_seal(this_seal, true, true)
                        play_sound((sound or 'tarot2'), 0.76, 0.4)
                        temp_hand[i]:juice_up(0.5, 0.7)
                        return true
                    end)
                end
            end
        end
    end
}

-- 2. B-Ball Pasta (WORKS?)
local bball_pasta = {
	object_type = "Joker",
    key = 'bball_pasta',
    atlas = sprites,
    pos = get_pos(0,1),
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  { extra = { odds = 4, chips = 6, mult = 3, chip_mod = 6, mult_mod = 3 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.mult_mod),
                number_format(card.ability.extra.chips),
                number_format(card.ability.extra.mult)
            }
        }
    end,
    calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				message = localize("rgmc_what"),
				chip_mod = lenient_bignum(card.ability.extra.chips),
				mult_mod = lenient_bignum(card.ability.extra.mult),
			}
		end

        if get_end_of_round(context) and RGMC.funcs.calculate_card_odds(card,'bball_pasta') then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize("k_upgrade_ex"),
                }
        end
    end
}

-- 3. Squeezy Cheeze (WORKS)
local squeezy_cheeze = {
	key = 'squeezy_cheeze',
    atlas = sprites,
    pos = get_pos(0,2),
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
        extra = {
            x_chips = 1,
            xchip_mod = 0.2,
            xmult_mod = 1,
            xmult_store = 0,
            rounds_remaining = 8
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.xchip_mod),
                number_format(card.ability.extra.xmult_mod),
                number_format(card.ability.extra.rounds_remaining)
            }
        }
    end,
    calculate = function(self, card, context)
        if get_end_of_round(context) then
            return RGMC.funcs.food_joker_logic(card)
        end
    end
}

-- 4. Joker Squared
local joker_squared = {
	object_type = "Joker",
    key = 'joker_squared',
    atlas = sprites,
    pos = get_pos(0,3),
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
        extra = {
            mult = 6,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult),
            }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and not context.blueprint then
            local rank = context.other_card:get_id()
            if rank == 4 or rank == 9 then -- 1, 4, 9, 16, 25, 64
                return {
                    message = localize({
                        type = "variable",
                        key = "a_mult",
                        vars = { number_format(card.ability.extra.mult) },
                    }),
                    mult_mod = lenient_bignum(card.ability.extra.mult),
                    colour = G.C.MULT,
                }
            end
        end
        if context.forcetrigger then
            return {
                message = localize({
                    type = "variable",
                    key = "a_mult",
                    vars = { number_format(card.ability.extra.mult) },
                }),
                mult_mod = lenient_bignum(card.ability.extra.mult),
                colour = G.C.MULT,
            }
        end
    end
}

-- 5. Spectator
local spectator = {
	object_type = "Joker",
    key = 'spectator',
    atlas = sprites,
    pos = get_pos(0,4),
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
        extra = {
            mult_mod = 4,
            mult = 0
        }
    },
    loc_vars = function(self, info_queue, card)
		return {
            vars = {
                number_format(card.ability.extra.mult_mod)
            }
        }
    end,
    calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before and not context.blueprint then
            cards = 0
			for k, v in ipairs(context.scoring_hand) do v.rgmc_garbage_incompat = true end
			for k, v in ipairs(context.full_hand) do
				if not v.rgmc_garbage_incompat then
					cards = cards + 1
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end,
					}))
					card_eval_status_text(card, "extra", nil, nil, nil, {
						message = tostring(cards),
						colour = G.C.DARK_EDITION,
					})
				end
			end
			for k, v in ipairs(context.scoring_hand) do v.rgmc_garbage_incompat = nil end
			if cards > 0 then
				card.ability.extra.mult = cards * card.ability.extra.mult_mod
				return nil, true
			end
        end
        if context.joker_main and context.poker_hands ~= nil and card.ability.extra.mult > 0 then
            return {
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { card.ability.extra.mult }
                },
                mult_mod = card.ability.extra.mult
            }
        end
    end
}

-- 6. Lady Liberty
local lady_liberty = {
	object_type = "Joker",
    key = 'lady_liberty',
    atlas = sprites,
    pos = get_pos(0,5),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
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
		return vars = { number_format(self.config.extra.seals or 1) }
    end,
    calculate = function(self, card, context)
        if
            context.after
            and G.GAME.current_round.hands_played == 0
        then
            local seals_done = 0
            for i=1, #context.scoring_hand do
                local sh = context.scoring_hand[i]
                if not sh.seal then
                    seals_done = seals_done + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 1,
                        func = function()
                            sh:set_seal('rgmc_patina', true)
                            sh:juice_up(0.3,0.3)
                            play_sound('tarot2', 1.2, 0.4)
                        return true
                        end
                    }))
                end
                if seals_done == card.ability.extra.seals then break end
            end
        end
    end
}

-- 7. Neighborhood Watch
local neighborhood_watch = {
	object_type = "Joker",
    key = 'neighborhood_watch',
    atlas = sprites,
    pos = get_pos(0,6),
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
		extra = {
			money_mod = 2,
			money = 0,
		},
    },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				number_format(card.ability.extra.money_mod),
				localize(RGMC.funcs.safe_get(G.GAME, "current_round", "rgmc_edwin_card", "rank") or "5", "ranks"), -- fix this later
				localize(
					G.GAME.current_round.rgmc_edwin_card and G.GAME.current_round.rgmc_edwin_card.suit or "Diamonds",
					"suits_plural"
				),
				colours = {
					G.C.SUITS[G.GAME.current_round.rgmc_edwin_card and G.GAME.current_round.rgmc_edwin_card.suit or "Diamonds"],
				},
			},
		}
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
			and not context.before
			and not context.after
			and context.other_card:get_id() == G.GAME.current_round.rgmc_edwin_card.id
			and context.other_card:is_suit(G.GAME.current_round.rgmc_edwin_card.suit)
		then -- has both suit and rank
			if context.other_card.debuff then -- don't count debuffed cards haha
				return {
					message = localize("k_debuffed"),
					colour = G.C.RED,
					card = card,
				}
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
	object_type = "Joker",
    key = 'penrose_stairs',
    atlas = sprites,
    pos = get_pos(0,7),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = {
        extra = {
            times = 1
        },
        immutable = {
            odds = 6
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.immutable.odds),
                number_format(card.ability.extra.times)
            }
        }
    end,
    calculate = function(self, card, context)
        if context.after and context.scoring_hand and RGMC.funcs.calculate_card_odds(card,'penrose_stairs')then
            RGMC.funcs.flip_cards(context.scoring_hand, function(card)
                assert(SMODS.modify_rank(v, card.ability.extra.times))
            end)
        end
    end
}

-- 9. Quick Brown Fox
local quick_brown_fox = {
	object_type = "Joker",
    key = 'quick_brown_fox',
    atlas = sprites,
    pos = get_pos(0,8),
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config = {
        extra = {
            chips = 6
        }
    },
    loc_vars = function(self, info_queue, card)
        local amt = 0
        if
            G.GAME
            and G.GAME.MADCAP
            and G.GAME.MADCAP.ante
        then
            amt = G.GAME.MADCAP.ante.unique_ranks
        end

        return {
            vars = {
                number_format(card.ability.extra.chips),
                number_format(card.ability.extra.chips * amt)
            }
        }
    end,
    calculate = function(self, card, context)
        --[[
            the hand scoring function from lib/main
            handles counting unique ranks
        ]]
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { number_format(card.ability.extra.chips) },
				}),
				chip_mod = lenient_bignum(card.ability.extra.chips),
			}
        end
    end
}

-- 10. House of Cards
local house_of_cards = {
	object_type = "Joker",
    key = 'house_of_cards',
    atlas = sprites,
    pos = get_pos(0,9),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = {
        immutable = {
            odds = 6 -- believe me, it is bettter this way
        },
        extra = {
            chip_mod = 6,
            chips = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.chip_mod),
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.immutable.odds),
                number_format(card.ability.extra.chips),
            }
        }
    end,
    calculate = function(self, card, context)

        if -- upgrade!
            context.cardarea == G.jokers
            and context.before
        then
            card.ability.extra.chips = lenient_bignum(to_big(card.ability.extra.chips) + card.ability.extra.chip_mod)
            return {
                message = localize("k_upgrade_ex"),
                card = card,
            }
        end

        if  -- the cards :)
            context.joker_main -- playing the hand
			and (to_big(card.ability.extra.chips) > to_big(0))
        then
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { number_format(card.ability.extra.chips) },
				}),
				chip_mod = lenient_bignum(card.ability.extra.chips),
			}
        end

        if  -- 1 in ? chance to fucking knock the house down
            context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
        then
            if RGMC.funcs.calculate_card_odds(card,'house_of_cards') then
                return {
                    message = localize("k_reset"), -- Reset!
                    card = card,
                }
            end
        end
    end
}

-- 11. Glass Michel
local glass_michel = {
	object_type = "Joker",
    key = 'glass_michel',
    atlas = sprites,
    pos = get_pos(1,0),
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = {
        extra = {
            odds = 6,
        }
    },
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds),
            }
        }
    end,
    calculate = function(self, card, context) -- also keeps glass cards safe

        if
            context.repetition
            and context.cardarea == G.play
            and (SMODS.has_enhancement(context.other_card, 'm_glass')
                or context.forcetrigger)
        then
            context.other_card.ability.glass_michel = true
            return {
                message = localize('k_again_ex'),
				repetitions = 1,
				card = context.other_card
            }
		end

        -- End of round stuff
		if
			context.end_of_round2
			and not context.individual
			and not context.repetition
			and not context.blueprint
			and not context.retrigger_joker
		then
            -- reset the cards
            for _, v in pairs(G.playing_cards) do
                if v.ability.glass_michel then v.ability.glass_michel = nil end
            end

            -- roll to see if banana goes bye!

            if RGMC.funcs.calculate_card_odds(card,'glass_michel') then -- 1 in 6 chance to POOF!
                return RGMC.funcs.banana_remove(card) -- remove it like a banana? maybe have it shatter
            else
                return { message = localize("k_safe_ex") } -- safe!
            end
        end
    end
}

-- 12. Chinese Takeout
local chinese_takeout = {
	object_type = "Joker",
    key = 'chinese_takeout',
    atlas = sprites,
    pos = get_pos(1,1),
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = true,
	demicoloncompat = true,
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

        return {
            vars = {
                number_format(card.ability.extra.rounds_remaining),
                number_format(card.ability.extra.effects[card.ability.immutable.mode])
            }
        }
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
                return {
                    message = localize("rgmc_chinese_line" .. card.ability.immutable.mode)
                }
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
                -- +chip
                return {
                    message = localize({
                        type = "variable",
                        key = "a_chips",
                        vars = { number_format(card.ability.extra.effects[card.ability.immutable.mode]) },
                    }),
                    chip_mod = lenient_bignum(card.ability.extra.effects[card.ability.immutable.mode]),
                    colour = G.C.CHIPS,
                }
            elseif
                card.ability.immutable.mode == 2
                or card.ability.immutable.mode == 4
            then
                -- +mult
                return {
                    message = localize({
                        type = "variable",
                        key = "a_mult",
                        vars = { number_format(card.ability.extra.effects[card.ability.immutable.mode]) },
                    }),
                    mult_mod = lenient_bignum(card.ability.extra.effects[card.ability.immutable.mode]),
                    colour = G.C.MULT,
                }
            elseif
                card.ability.immutable.mode == 6
                or card.ability.immutable.mode == 7
            then
                -- Xmult
                return {
                    message = localize({
                        type = "variable",
                        key = "a_xmult",
                        vars = { number_format(card.ability.extra.effects[card.ability.immutable.mode]) },
                    }),
                    Xmult_mod = lenient_bignum(card.ability.extra.effects[card.ability.immutable.mode]),
                    colour = G.C.MULT,
                }
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
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
				func = function()
					G.GAME.chips = (to_big(G.GAME.chips))*(to_big(card.ability.extra.effects[card.ability.immutable.mode]))
					G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
					play_sound('holo1')
                    card.ability.rgmc_tsao_chicken = nil -- not needed now
					return true
				end,
			}))
            return {
				message = "X" .. tostring(card.ability.extra.effects[card.ability.immutable.mode]),
				colour = G.C.PURPLE
			}
        end

        -- End of round
		if
            get_end_of_round(context)
        then
            return RGMC.funcs.food_joker_logic(card)
        end
    end
}

-- 13. Easter Egg
local easter_egg= {
	object_type = "Joker",
    key = 'easter_egg',
    atlas = sprites,
    pos = get_pos(1,2),
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
	demicoloncompat = true,
    config =  {
        extra = {
            value = 2,
            value_mod = 4,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.value,
                card.ability.extra.value_mod
            }
        }
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

        -- Sell it!

		if
            (context.selling_self
                and not context.blueprint)
                or context.forcetrigger
        then -- poop

            if context.forcetrigger then card.ability.extra.value = 0 end -- force trigger resets it

            -- make a temporary list, shuffle it.
            local shuffle_hand = {}
            for k, v in pairs(G.deck.cards) do
                table.insert(shuffle_hand, v)
            end
            pseudoshuffle(shuffle_hand,pseudoseed('rgmc_easter_egg'))
            tell(#shuffle_hand)

            local override, targets = 0, 0
            while override < 2 and targets < card.ability.extra.value do
                tell("Let's try it out")
                for i=1,#shuffle_hand do
                    tell("Shuffle Hand "..i)
                    if (not shuffle_hand[i].edition or override > 0) and not shuffle_hand[i].ability.rgmc_easter_egg then
                        targets = targets + 1 -- +1 target

                        -- do the actual event
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            delay = 0.3,
                            func = (function()
                                shuffle_hand[i]:set_edition(RGMC.funcs.get_weighted_edition(), true)
                                shuffle_hand[i]:juice_up(0.5, 0.7)
                                shuffle_hand[i].ability.rgmc_easter_egg = true
                            return true
                            end)
                        }))

                        -- we are done
                        if targets >= card.ability.extra.value then
                            break
                        end
                    end
                end

                if targets < card.ability.extra.value then
                    override = override + 1 -- try again with editioned cards or move to deck
                end
            end
        end
    end
}

-- 14. Null and Void
local null_and_void = {
	object_type = "Joker",
    key = 'null_and_void',
    name = name('null_and_void'),
    atlas = sprites,
    pos = get_pos(1,3),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    blueprint_compat = false, -- bad idea.
    config =  {
        extra ={
            cards_to_debuff
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards_to_debuff or 1
            }
        }
    end,
    calculate = function(self, card, context)

		if
            context.cardarea == G.jokers
            and context.before
            and not context.blueprint
        then
            local disabling = false
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    if not disabling then
                        -- remove debuff
                        if G.jokers.cards[i].ability.rgmc_nullified then
                            G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.3,
                            func = (function()
                                G.jokers.cards[i].ability.rgmc_nullified = nil
                                G.jokers.cards[i]:set_debuff(false)
                                G.jokers.cards[i]:juice_up(0.3, 0.4)
                                return true
                            end)}))
                        end
                    else
                        -- only do one
                        if not G.jokers.cards[i].ability.rgmc_nullified then
                            G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.3,
                            func = (function()
                                G.jokers.cards[i].ability.rgmc_nullified = true
                                G.jokers.cards[i]:set_debuff(true)
                                play_sound("tarot1")
                                G.jokers.cards[i]:juice_up(0.3, 0.4)
                                return true
                            end)}))
                        end
                        break
                    end
                else
                    disabling = true
                end
            end
        end
    end,
}

-- 15. Pretentious Joker
local pretentious_joker = {
	object_type = "Joker",
    key = 'pretentious_joker',
    name = name('pretentious_joker'),
    atlas = sprites,
    pos = get_pos(1,4),
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = {
        extra = {
            mult = 6,
            suit = 'rgmc_goblets'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult),
                localize(card.ability.extra.suit, 'suits_singular'),
                colours = {G.C.SUITS[card.ability.extra.suit] },
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.suit) then
            return { mult = card.ability.extra.mult, card = card }
        end
    end,
}

-- 16. Deceitful Joker
local deceitful_joker = {
	object_type = "Joker",
    key = 'deceitful_joker',
    name = name('deceitful_joker'),
    atlas = sprites,
    pos = get_pos(1,5),
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = {
        extra = {
            mult = 6,
            suit = 'rgmc_towers'
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult),
                localize(card.ability.extra.suit, 'suits_singular'),
                colours = {G.C.SUITS[card.ability.extra.suit] },
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.suit) then
            return { mult = card.ability.extra.mult, card = card }
        end
    end,
}

-- 17. Pentagon
local pentagon = {
    atlas = sprites,
    key = 'pentagon',
    name = name('pentagon'),
    pos = get_pos(1,6),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config = {
        extra = {
            mult = 6,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult),
            }
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            local rank = SMODS.Ranks[context.other_card.base.value].key
            if rank == "Ace"
                or rank == "Queen" -- queen counts as 12 for now
                or rank == "5"
            then
                return {
                    mult = card.ability.extra.mult,
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
    end,
}

-- 18. Barbershop Joker
local barbershop_joker = {
	object_type = "Joker",
    key = 'barbershop_joker',
    atlas = sprites,
    pos = get_pos(1,8),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
        extra = {
            mult = 2,
            scored = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            localize(G.GAME.blind and G.GAME.current_round.rgmc_barbershop.suit or 'Spades', 'suits_singular'),
            number_format(card.ability.extra.mult)
        }
    }
    end,
    calculate = function(self, card, context)
        local target = G.GAME.current_round.rgmc_barbershop.suit
        if
            context.individual
            and context.cardarea == G.play
            and context.other_card:is_suit(target)
        then
            G.GAME.current_round.rgmc_barbershop.changed = false
            card.ability.extra.scored = true
            return {
                mult = card.ability.extra.mult,
                card = card,
            }
        end

        if
            context.after
            and card.ability.extra.scored
            and not G.GAME.current_round.rgmc_barbershop.changed -- only switch it ONCE!
        then
            G.GAME.current_round.rgmc_barbershop.changed = true
            G.GAME.current_round.rgmc_barbershop.index = G.GAME.current_round.rgmc_barbershop.index + 1

            if G.GAME.current_round.rgmc_barbershop.index > #G.GAME.current_round.rgmc_barbershop.order then
                G.GAME.current_round.rgmc_barbershop.index = 1
            end

            G.GAME.current_round.rgmc_barbershop.suit = G.GAME.current_round.rgmc_barbershop.order[G.GAME.current_round.rgmc_barbershop.index]

            tell('Barbershop Changed to ' .. number_format(G.GAME.current_round.rgmc_barbershop.suit))
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
	object_type = "Joker",
    key = 'cup_of_joeker',
    name = name('cup_of_joeker'),
    atlas = sprites,
    pos = get_pos(1,7),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
    calculate = function(self, card, context)

        if
            (context.end_of_round
                and context.cardarea == G.jokers)
            or context.forcetrigger
        then
            local card_type = "Tarot"
            if
                (G.GAME.current_round.hands_played <= 1
                    and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit)
                or context.forcetrigger
            then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({ -- make a card
                trigger = 'before',
                delay = 0.08,
                func = (function()
                    local n_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
                    play_sound('timpani')
                    n_card:add_to_deck()
                    G.consumeables:emplace(n_card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))
            end
        end
    end
}



-- 20. Supreme With Cheese
local supreme_with_cheese = {
	object_type = "Joker",
    key = 'supreme_with_cheese',
    name = name('supreme_with_cheese'),
    atlas = sprites,
    pos = get_pos(1,9),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config = {
        extra = { x_mult = 2, rounds_remaining = 8 }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.rounds_remaining)
            }
        }
    end,
    calculate = function(self, card, context)
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { number_format(card.ability.extra.x_mult) },
                }),
                Xmult_mod = lenient_bignum(card.ability.extra.x_mult),
                colour = G.C.MULT,
            }
        end

        if
            get_end_of_round(context)
        then
            return RGMC.funcs.food_joker_logic(card)
        end
    end
}

-- 21. Bluenana
local bluenana = {
	object_type = "Joker",
    key = 'bluenana',
    name = name('bluenana'),
    atlas = sprites,
    pos = get_pos(2,0),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config = { extra = { x_chips = 2, odds = 200 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                number_format(card.ability.extra.x_chips),
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds)
            }
        }
	end,
    calculate = function(self, card, context)
        if
            context.forcetrigger or
            (context.cardarea == G.jokers and context.joker_main)
        then
            return {
                xchips = card.ability.extra.x_chips
            }
        end

        if
			context.end_of_round
			and not context.individual
			and not context.repetition
			and not context.blueprint
			and not context.retrigger_joker
		then
            return RGMC.funcs.banana_logic(card, 'bluenana')
        end
    end
}

-- 22. Redd Dacca
local redd_dacca = {
	object_type = "Joker",
    key = 'redd_dacca',
    name = name('redd_dacca'),
    atlas = sprites,
    pos = get_pos(2,1),
    rarity = 1, -- Thanks, Beige Deck
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config = {
        extra = {
            powmult = 2,
            odds = 200,
            numer_factor = 0.1 -- a little trick to mak
        }
    },
	loc_vars = function(self, info_queue, card)
        local adv_numerator = (G.GAME.probabilities.normal or 1) ^ (1 + (card.ability.numer_factor or 0))
		return {
            vars = {
                number_format(card.ability.extra.powmult),
                number_format(math.floor(adv_numerator)),
                number_format(card.ability.extra.odds)
            }
        }
	end,
    calculate = function(self, card, context)
        if
            (context.cardarea == G.jokers
            and context.joker_main)
            or context.forcetrigger
        then
			return {
				message = localize({
					type = "variable",
					key = "a_powmult",
					vars = {
						number_format(card.ability.extra.powmult),
					},
				}),
				Emult_mod = lenient_bignum(card.ability.extra.powmult),
				colour = G.C.RGMC_EMULT,
			}
		end

        if
			context.end_of_round
			and not context.individual
			and not context.repetition
			and not context.blueprint
			and not context.retrigger_joker
		then
        local adv_numerator = (G.GAME.probabilities.normal or 1) ^ (1 + (card.ability.numer_factor or 0))
            if RGMC.funcs.calculate_roll({
                card    = card,
                exp     = math.floor(adv_numerator) -- just to make it less OP on beige deck
            }) then -- 1 in 200^n chance to POOF!
                return RGMC.funcs.banana_remove(card)
            else
                return { message = localize("k_safe_ex") } -- safe!
            end
        end
    end
}

-- 23. Changing Had
local changing_had = {
	object_type = "Joker",
    key = 'changing_had',
    name = name('changing_had'),
    atlas = sprites,
    pos = get_pos(2,2),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            retriggers = 3,
        },
        immutable = {
            position = 1,
            changing = true
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                RGMC.funcs.get_num_position(card.ability.immutable.position or 1),
                number_format(card.ability.extra.retriggers)
            }
        }
    end,
    calculate = function(self, card, context)
        if
            context.repetition
            and context.cardarea == G.play
            and (context.other_card == context.scoring_hand[card.ability.immutable.position]
            or context.forcetrigger)
        then
            card.ability.immutable.changing = true
            return {
                message = localize('k_again_ex'),
				repetitions = lenient_bignum(card.ability.extra.retriggers),
				card = context.other_card
            }
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
	object_type = "Joker",
    key = 'ball_breaker',
    name = name('ball_breaker'),
    atlas = sprites,
    pos = get_pos(2,3),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            chips = 0,
            chip_mod = 6,
            active = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chips)
            }
        }
    end,
    calculate = function(self, card, context)
		if
            context.cardarea == G.jokers
            and context.before
            and context.scoring_hand
        then
            local fibonacci = true
			for k, v in ipairs(G.play.cards) do -- check for all fibonacci
                local rank = SMODS.Ranks[v.base.value].key
                if not (rank == "Ace" or rank == "2" or rank == "3" or rank == "5" or rank == "8") then
                    fibonacci = false
                    break
                end
			end
			if fibonacci then -- WOW U GOT THE FIBONACCI!!
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize("k_upgrade_ex"),
                }
			end
        end
        if -- demicolon
            context.joker_main
            or context.forcetrigger
        then
            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
                chip_mod = card.ability.extra.chips
            }
        end
    end
}

--[[
    Scored cards from Ace to 9
    have a 1 in 4 chance
    of turning into another rank
    (4 ~ 7, 2 ~ 5, 3 ~ 8, 6 ~ 9,
]]

-- 25. Thorium Joker
local thorium_joker = {
	object_type = "Joker",
    key = 'thorium_joker',
    name = name('thorium_joker'),
    atlas = sprites,
    pos = get_pos(2,4),
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true, -- do later
    config =  {
        extra = {
            odds = 3,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds)
            }
        }
    end,
    calculate = function(self, card, context)
        if
            context.cardarea == G.play
            and context.individual
            and context.other_card
            and context.scoring_hand
        then
            local this_card = context.other_card
            if
                RGMC.funcs.calculate_roll({ card = card, seed = 'rgmc_thorium_joker' })
                or context.forcetrigger
            then
                local rank, new_rank = SMODS.Ranks[context.other_card.base.value].key, nil

                tell("Choosing New Rank...")
                if rank == "2" then new_rank = "5"
                elseif rank == "3" then new_rank = "8"
                elseif rank == "4" then new_rank = "7"
                elseif rank == "5" then new_rank = "2"
                elseif rank == "6" then new_rank = "9"
                elseif rank == "7" then new_rank = "4"
                elseif rank == "8" then new_rank = "3"
                elseif rank == "9" then new_rank = "6"
                end

                if new_rank then
                    -- do the new thing
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound((sound or 'tarot2'), 0.76, 0.4)
                            this_card:juice_up()
                            SMODS.change_base(this_card, _, new_rank) -- change da rank
                        return true
                        end
                    }))
                end
            end
        end
    end
}

-- 26. Twinkle of Contagion
local twinkle_of_contagion = {
	object_type = "Joker",
    key = 'twinkle_of_contagion',
    name = name('twinkle_of_contagion'),
    atlas = sprites,
    pos = get_pos(2,5),
    rarity = 2,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = false, -- try to add compat later?
    config = {
        extra = {
            twinkles = 1,
            odds = 2,
            record = {},
            card = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds),
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.record = {} -- used in reset
            card.ability.extra.card = nil
        end

        if context.setting_blind then

            local polychrome = false
            for i = 1, #G.deck.cards do
                if
                    G.deck.cards[i].edition
                    and G.deck.cards[i].edition.polychrome == true
                then
                    polychrome = true
                    break
                end
            end

            if
                not polychrome
            then
                G.deck.cards[1]:set_edition({ polychrome = true }, true)
                G.deck.cards[1]:juice_up(0.5, 0.7)
                pseudoshuffle(G.deck.cards, pseudoseed('rgmc_twinkle_of_contagion'))
                play_sound('rgmc_contagion', 1, 0.6)
            end

        elseif
            context.individual
            and context.cardarea == G.play
            and context.other_card
            and context.other_card.edition
        then

            if
                (not card.ability.extra.card
                    or card.ability.extra.card ~= context.other_card)
                and RGMC.funcs.calculate_roll({ card = card, seed = 'rgmc_twinkle_of_contagion' })
            then
                local temp_hand, finished = {}, false
                local from_card, to_card = context.other_card, nil
                local can_do = true

                -- Shuffle the hand
                for i = 1, #G.hand.cards do
                    if not G.hand.cards[i].edition then temp_hand[#temp_hand + 1] = G.hand.cards[i] end
                end
                pseudoshuffle(temp_hand, pseudoseed('rgmc_contagion'))

                -- Pick the first viable card
                for i = 1, #temp_hand do
                    local can_do = true
                    for j = 1, #card.ability.extra.record do -- loop thru to see if same card
                        if temp_hand[i] == card.ability.extra.record[j] then can_do = false; break; end
                    end
                    if can_do then -- possible!
                        to_card = temp_hand[i]
                        card.ability.extra.record[#card.ability.extra.record+1] = to_card
                        break
                    end
                end

                if to_card then
                    card.ability.extra.card = context.other_card
                    local edition = from_card.edition
                    G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                        from_card:set_edition(nil,true,true)
                        to_card:set_edition(edition,true,true)
                        from_card:juice_up(0.5, 0.7)
                        to_card:juice_up(0.5, 0.7)
                        play_sound('rgmc_contagion', 1, 0.6)
                    return true end }))
                end
            end
        end
    end
}

-- 27. Iron Joker
local iron_joker = {
	object_type = "Joker",
    key = 'iron_joker',
    name = name('iron_joker'),
    atlas = sprites,
    pos = get_pos(2,6),
    rarity = 2,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
	config = {
        enhancement = 'rgmc_ferrous',
        extra = { chips = 25 }
    },
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(card.ability.extra.chips),
				number_format(card.ability.extra.chips * RGMC.funcs.get_num_enhanced(G.playing_cards,card.ability.enhancement)),
			},
        }
    end,
    calculate = function(self, card, context)
        if
            context.joker_main
            or context.forcetrigger
        then
            local enhanced_cards = RGMC.funcs.get_num_enhanced(G.playing_cards,card.ability.enhancement)
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { number_format(card.ability.extra.chips * enhanced_cards) },
				}),
				chip_mod = lenient_bignum(card.ability.extra.chips * enhanced_cards),
				colour = G.C.CHIPS,
			}
        end
    end
}

-- 28. Tungsten Joker
local tungsten_joker = {
	object_type = "Joker",
    key = 'tungsten_joker',
    name = name('tungsten_joker'),
    atlas = sprites,
    pos = get_pos(2,7),
    rarity = 2,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
	config = {
        enhancement = 'rgmc_wolfram',
        extra = { mult = 6 }
    },
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(card.ability.extra.mult),
				number_format(card.ability.extra.mult * RGMC.funcs.get_num_enhanced(G.playing_cards,card.ability.enhancement)),
			},
        }
    end,
    calculate = function(self, card, context)
        if
            context.joker_main
            or context.forcetrigger
        then
            local enhanced_cards = RGMC.funcs.get_num_enhanced(G.playing_cards,card.ability.enhancement)
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { number_format(card.ability.extra.mult * enhanced_cards) },
				}),
				mult_mod = lenient_bignum(card.ability.extra.mult * enhanced_cards),
				colour = G.C.MULT,
			}
        end
    end
}

-- 29. Jeweler Joker
local jeweler_joker = {
	object_type = "Joker",
    key = 'jeweler_joker',
    name = name('jeweler_joker'),
    atlas = sprites,
    pos = get_pos(2,8),
    rarity = 2,
    cost = 3,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
	config = {
        enhancement = 'rgmc_lustrous',
        extra = { x_mult = 0.1 }
    },
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(card.ability.extra.x_mult),
				number_format(card.ability.extra.x_mult * RGMC.funcs.get_num_enhanced(G.playing_cards,card.ability.enhancement)),
			},
        }
    end,
    calculate = function(self, card, context)
        if
            context.joker_main
            or context.forcetrigger
        then
            local enhanced_cards = RGMC.funcs.get_num_enhanced(G.playing_cards,card.ability.enhancement)
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { number_format(card.ability.extra.x_mult * enhanced_cards) },
				}),
				Xmult_mod = lenient_bignum(card.ability.extra.x_mult * enhanced_cards),
				colour = G.C.MULT,
			}
        end
    end
}

-- 30. Plentiful Ametrine
local plentiful_ametrine = {
	object_type = "Joker",
    key = 'plentiful_ametrine',
    name = name('plentiful_ametrine'),
    atlas = sprites,
    pos = get_pos(2,9),
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            odds = 6,
            mult = 0,
            mult_mod = 4
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.mult_mod),
                number_format(card.ability.extra.mult)
            }
        }
    end,
    calculate = function(self, card, context)
        -- scaling
        if
            context.cardarea == G.play
            and context.individual
            and not context.blueprint
        then
            if
                context.other_card:is_suit('rgmc_goblets')
                and RGMC.funcs.calculate_roll({ card = card, seed = 'rgmc_plentiful_ametrine' })
            then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = localize("k_upgrade_ex"), -- Upgrade!
                    card = card,
                }
            end
        end

        -- give the mult
		if context.joker_main or context.forcetrigger then
			return {
				mult_mod = lenient_bignum(card.ability.extra.mult),
			}
		end

		-- reset at end of ante
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and G.GAME.round % RGMC.funcs.get_blinds_per_ante() == 0
        then
            card.ability.extra.mult = 0
            return {
                message = localize("k_reset"), -- Reset!
                card = card,
            }
        end
    end
}

-- 31. Toughened Shungite
local toughened_shungite = {
	object_type = "Joker",
    key = 'toughened_shungite',
    name = name('toughened_shungite'),
    atlas = sprites,
    pos = get_pos(3,0),
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            odds = 7,
            chips = 0,
            chip_mod = 15
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chips)
            }
        }
    end,
    calculate = function(self, card, context)
        -- scaling
        if
            context.cardarea == G.play
            and context.individual
            and not context.blueprint
        then
            if -- suit is towers, 1 in 2 chance
                context.other_card:is_suit('rgmc_towers')
                and RGMC.funcs.calculate_roll({ card = card, seed = 'rgmc_toughened_shungite' })
            then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize("k_upgrade_ex"), -- Upgrade!
                    card = card,
                }
            end
        end

        -- give the chip
		if context.joker_main or context.forcetrigger then
			return {
				chip_mod = lenient_bignum(card.ability.extra.chips),
			}
		end

        if -- reset at end of ante
            context.end_of_round
            and not context.individual
            and not context.repetition
            and G.GAME.round % RGMC.funcs.get_blinds_per_ante() == 0
        then
            card.ability.extra.chips = 0
            return {
                message = localize("k_reset"), -- Reset!
                card = card,
            }
        end
    end
}

-- 32. Six Shooter
local six_shooter = {
	object_type = "Joker",
    key = 'six_shooter',
    name = name('six_shooter'),
    atlas = sprites,
    pos = get_pos(3,1),
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            odds = 7,
            chips = 0,
            chip_mod = 60
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(G.GAME.probabilities.normal or 1),
                number_format(card.ability.extra.odds),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chips)
            }
        }
    end,
    calculate = function(self, card, context)
        if -- build the chips
            context.cardarea == G.play
            and context.individual
            and context.other_card
            and not context.forcetrigger
        then
			local rank = context.other_card:get_id()
			if
                rank == 6
                and RGMC.funcs.calculate_roll({ card = card, seed = 'rgmc_six_shooter' })
			then
                -- do a little dance
                local target = context.other_card
				G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    delay = 0.08,
                    func = function()
                        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                        play_sound(('tarot2'), 0.76, 0.4)
                        target:juice_up(0.3, 0.4)
                        return {
                            message = localize({
                                type = "variable",
                                key = "a_chips",
                                vars = { number_format(card.ability.extra.chip_mod) },
                            }),
                            chip_mod = lenient_bignum(card.ability.extra.chip_mod),
                        }
                    end,
                }))
                -- DIE
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.28,
                    func = function()
                        target:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                        return true
                    end,
                }))
			end
		end


		if -- give the chips
            (context.joker_main and (to_big(card.ability.extra.mult) > to_big(0)))
            or context.forcetrigger
        then
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { number_format(card.ability.extra.chips) },
				}),
				mult_mod = lenient_bignum(card.ability.extra.chips),
				colour = G.C.CHIPS,
			}
		end
    end
}

-- 33. Conspiracy Wizard
local conspiracy_wizard = {
	object_type = "Joker",
    key = 'conspiracy_wizard',
    name = name('conspiracy_wizard'),
    atlas = sprites,
    pos = get_pos(3,2),
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            mult = 5,
            chips = 10
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.chips),
                (RGMC.devmode and G.GAME.MADCAP) and G.GAME.current_round.rgmc_wizard_card.rank or "SEKRIT",
                (RGMC.devmode and G.GAME.MADCAP) and RGMC.devmode and G.GAME.current_round.rgmc_wizard_card.suit or "SEKRIT",
            }
        }
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
                return {
                    message = localize({
                        type = "variable",
                        key = "a_chips",
                        vars = { number_format(card.ability.extra.chips) },
                    }),
                    mult_mod = lenient_bignum(card.ability.extra.chips),
                    colour = G.C.CHIPS,
                }
			end
			if context.other_card:is_suit(G.GAME.current_round.rgmc_wizard_card.suit) then -- u got the suit
                G.GAME.current_round.rgmc_wizard_card.suit_discovered = true
                return {
                    message = localize({
                        type = "variable",
                        key = "a_mult",
                        vars = { number_format(card.ability.extra.mult) },
                    }),
                    mult_mod = lenient_bignum(card.ability.extra.mult),
                    colour = G.C.MULT,
                }
            end
		end
		if context.forcetrigger then -- do both chip and mult
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 0.3,
                blockable = false,
                func = function()
                    return {
                        message = localize({
                            type = "variable",
                            key = "a_mult",
                            vars = { number_format(card.ability.extra.mult) },
                        }),
                        mult_mod = lenient_bignum(card.ability.extra.mult),
                        colour = G.C.CHIPS,
                    }
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 0.3,
                blockable = false,
                func = function()
                    return {
                        message = localize({
                            type = "variable",
                            key = "a_chips",
                            vars = { number_format(card.ability.extra.chips) },
                        }),
                        chip_mod = lenient_bignum(card.ability.extra.chips),
                        colour = G.C.CHIPS,
                    }
                end
            }))
		end
    end
}

-- 34. Cavalier (only appears if you have a Knight)
local cavalier = {
	object_type = "Joker",
    key = 'cavalier',
    name = name('cavalier'),
    atlas = sprites,
    pos = get_pos(3,3),
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            x_chips = 2,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.x_chips),
            }
        }
    end,
    calculate = function(self, card, context)

		if
			(context.cardarea == G.hand
			and context.other_card
			and context.other_card.base.value == "rgmc_knight" -- is a knight card
			and not context.end_of_round)
			or context.forcetrigger
		then
			if context.other_card.debuff then
				return {
					message = localize("k_debuffed"),
					colour = G.C.RED,
					card = card,
				}
			else
                return {
                    message = localize({
                        type = "variable",
                        key = "a_xchips",
                        vars = { number_format(card.ability.extra.x_chips) },
                    }),
                    Xchip_mod = lenient_bignum(card.ability.extra.x_chips),
                }
			end
		end
    end
}

-- 35. Blindfold Joker (Demicolon compat!)
local blindfold_joker = {
	object_type = "Joker",
    key = 'blindfold_joker',
    name = name('blindfold_joker'),
    atlas = sprites,
    pos = get_pos(3,4),
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            x_mult = 3,
            x_mult_penalty = 0.25,
            active = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.x_mult_penalty),
                card.ability.extra.active
                    and localize("k_active_ex")
                    or localize("rgmc_inactive")
            }
        }
    end,
    calculate = function(self, card, context)

        -- start blind: activate if big blind show it's active
        if context.setting_blind then
            local is_big_blind = G.GAME.blind:get_type() == "Big"
            card.ability.extra.active = is_big_blind
            if is_big_blind then
                tell('Big Blind detected')
                local eval = function()
                    return G.GAME.blind:get_type() ~= "Big"
                end
                juice_card_until(card, eval, true)
            end
        end

		if context.skip_blind then -- uh oh...
            card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.x_mult_penalty
            if card.ability.extra.x_mult > 1 then -- going down
				return {
					message = localize("k_debuffed"),
					colour = G.C.RED,
					card = card,
				}
            else
                -- fucking explode
                return RGMC.funcs.banana_remove(card)
            end
        end

		if -- big blind be like
            (context.joker_main and G.GAME.blind:get_type() == "Big")
            or context.forcetrigger
        then
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { number_format(card.ability.extra.x_mult) },
                }),
                Xmult_mod = lenient_bignum(card.ability.extra.x_mult),
            }
		end
    end
}

-- 36. Crystal Cola
local crystal_cola = {
	object_type = "Joker",
    key = 'crystal_cola',
    name = name('crystal_cola'),
    atlas = sprites,
    pos = get_pos(3,5),
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
    calculate = function(self, card, context)
		if (context.selling_self and not context.blueprint) or context.forcetrigger then -- Boomerang on sell
            local tag = Tag("tag_rgmc_boomerang")
            add_tag(tag)
            play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
            play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
		end
    end
}

-- 37. Sigma Joker
local sigma_joker = {
	object_type = "Joker",
    key = 'sigma_joker',
    name = name('sigma_joker'),
    atlas = sprites,
    pos = get_pos(3,6),
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            x_chips = 0, -- sum/10
            xchip_mod = 0.1
        }
    },
    loc_vars = function(self, info_queue, card)

        local sigma_sum = 0

        if #G.hand.highlighted > 0 then
            sigma_sum = to_big(RGMC.funcs.get_hand_sigma(G.hand.highlighted))
        end

        return {
            vars = {
                number_format(card.ability.extra.xchip_mod),
                "~"..number_format(sigma_sum * card.ability.extra.xchip_mod)
            }
        }
    end,
    calculate = function(self, card, context)
        if
            context.before -- sets the x chips to sigma amount
            and context.cardarea == G.hand
            and ((not context.repetition and not context.blueprint) or context.forcetrigger)
            and not context.end_of_round -- why tf does it
        then
            local value = to_big(RGMC.funcs.get_hand_sigma(G.hand.cards))
            card.ability.extra.x_chips = 1 + value*card.ability.extra.xchip_mod
            tell(card.ability.extra.x_chips)
        end

        -- held in hand stuff
		if
			context.individual
			and context.cardarea == G.hand
			and context.other_card.base.value == 'rgmc_sum' -- is a sum card
			and not context.repetition
		then
            tell('We got a Sigma in here!')
			if context.other_card.debuff then
				return {
					message = localize("k_debuffed"),
					colour = G.C.RED,
					card = card,
				}
			else
                return {
                    message = localize({
                        type = "variable",
                        key = "a_xchips",
                        vars = { number_format(card.ability.extra.x_chips) },
                    }),
                    Xchip_mod = lenient_bignum(card.ability.extra.x_chips),
                }
			end
		end

		if context.repetition then
            local value = to_big(RGMC.funcs.get_hand_sigma(G.hand.cards))
            card.ability.extra.x_chips = 1 + value*card.ability.extra.xchip_mod
            return {
                message = localize({
                    type = "variable",
                    key = "a_xchips",
                    vars = { number_format(card.ability.extra.x_chips) },
                }),
                Xchip_mod = lenient_bignum(card.ability.extra.x_chips),
            }
		end
    end
}

-- the base 4 suits
base_suits = { 'Hearts', 'Diamonds', 'Clubs', 'Spades' }

-- suits outside the base 4
modded_suits = {
    'rgmc_goblets',
    'rgmc_towers',
    'rgmc_blooms',
    'rgmc_daggers',
    'rgmc_voids',
    'entr_nilsuit',
    'paperback_Stars',
    'paperback_Moons',
    'bunc_Fleurons',
    'bunc_Halberds',
    'ink_Colors',
    'ink_Inks',
    'rcb_thunders',
    'rcb_waters',
    'six_Stars',
    'six_Moons',
}

-- light suits
light_suits = {
    'Hearts',
    'Diamonds',
    'rgmc_goblets',
    'rgmc_blooms',
    'paperback_Stars',
    'bunc_Fleurons',
    'ink_Colors',
    'six_Stars',
    'rcb_thunders'
}

-- dark suits
dark_suits = {
    'Clubs',
    'Spades',
    'rgmc_towers',
    'rgmc_daggers',
    'paperback_Crowns',
    'bunc_Halberds',
    'ink_Inks',
    'six_Moons',
    'rcb_waters'
}

base_ranks = { 'Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' }

-- 38. Venn Diagram
local venn_diagram = {
	object_type = "Joker",
    key = 'venn_diagram',
    name = name('venn_diagram'),
    atlas = sprites,
    pos = get_pos(3,7),
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            mult = 6
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult)
            }
        }
    end,
    calculate = function(self, card, context)
        -- so basically i'm monke
        if (context.individual and context.cardarea == G.play
                and not (RGMC.funcs.card_suit_in_list(context.other_card,base_suits)
                or RGMC.funcs.card_rank_in_list(context.other_card,base_ranks)))
            or context.repetition -- demicolon compat
        then -- has to have custom rank and suit
            return {
                mult = card.ability.extra.mult,
                card = card,
            }
        end
    end

}

local function continuum_effect(list,starting_point)
    -- double trigger to the left
    tell('Continuum Effect')
    for i = starting_point, 1, -1 do
        local card = list[i]
        tell('DOODOO')
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.8,
            blockable = false,
            func = function()
                tell("Retrigger card at index "..tostring(i))
                play_sound((sound or 'tarot2'), 0.76, 0.4)
                return {
                    message = localize('...'),
					colour = G.C.FILTER,
                    repetitions = 1,
                    card = card
                }
            end
        }))
    end
end

-- 39. Continuum
local continuum = {
	object_type = "Joker",
    key = 'continuum',
    atlas = sprites,
    pos = get_pos(3,8),
    rarity = 2,
    cost = 9,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true, -- i mean, knock yourself out
	demicoloncompat = false, -- i dunt think you can demicolon this :(
    config =  {
        extra = {
            retrigger_cards = 1,
        },
        immutable = {
            current_position = 0
        },
        active = false
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.retrigger_cards)
            }
        }
    end
    -- no calculation here - mostly happens using lovely shenanigans
}

-- 40. Three Trees
local three_trees = {
	object_type = "Joker",
    key = 'three_trees',
    name = name('three_trees'),
    atlas = sprites,
    pos = get_pos(3,9),
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config = {
        extra = {
            x_mult = 3,
            active = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.x_mult)
            }
        }
    end,
    calculate = function(self, card, context)
        -- before scoring, see if the hand passes the VIBE test
		if context.cardarea == G.jokers and context.before and not context.blueprint then
            local suits = {nil, nil, nil} -- light, dark, modded

			for k, v in ipairs(context.scoring_hand) do -- check for all fibonacci
                if not suits[1] then -- needs light suit
                    if RGMC.funcs.card_suit_in_list(v,light_suits) then
                        suits[1] = v.base.suit
                    end
                end
                if not suits[2] then -- needs dark suit
                    if RGMC.funcs.card_suit_in_list(v,dark_suits) then
                        suits[2] = v.base.suit
                    end
                end
                if not suits[3] then -- needs modded suit
                    if RGMC.funcs.card_suit_in_list(v,modded_suits)
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
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { number_format(card.ability.extra.x_mult) },
                }),
                Xmult_mod = lenient_bignum(card.ability.extra.x_mult),
                colour = G.C.MULT,
            }
        end
    end
}

-- 41. Jimbo's Funeral (TESTED!)
local jimbos_funeral = {
	object_type = "Joker",
    key = 'jimbos_funeral',
    name = name('jimbos_funeral'),
    atlas = sprites,
    pos = get_pos(4,0),
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false, -- really shouldn't be used by blueprint
	demicoloncompat = false,
    config =  {
        extra = {
            active = true
        }
    },
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.active and localize("k_active_ex") or localize("rgmc_inactive")}}
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
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        return {
                            message = localize("k_upgrade_ex"), -- Safe!
                            card = card,
                        }
                    end
                }))
            end
        end
    end
}

-- 42. Shovel Joker
local shovel_joker = {
	object_type = "Joker",
    key = 'shovel_joker',
    name = name('shovel_joker'),
    atlas = sprites,
    pos = get_pos(4,1),
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            x_mult = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.x_mult)
            }
        }
    end,
    calculate = function(self, card, context)

        if
            context.cardarea == G.play
            and context.individual
            and context.other_card
        then
            print(context.other_card.base.value)
        end

        if
            context.cardarea == G.play
            and (context.individual
                and context.other_card
                and context.other_card.base.value == "rgmc_knight") -- is a knight card
                and RGMC.funcs.card_suit_in_list(context.other_card,dark_suits)
            or context.forcetrigger -- demicolon
        then
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { number_format(card.ability.extra.x_mult) },
                }),
                Xmult_mod = lenient_bignum(card.ability.extra.x_mult),
                colour = G.C.MULT,
            }
        end
    end
}

-- 43. Rhodochrosite
local rhodochrosite = {
	object_type = "Joker",
    key = 'rhodochrosite',
    name = name('rhodochrosite'),
    atlas = sprites,
    pos = get_pos(4,2),
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        active = false,
        extra = {
            mult = 6,
            chips = 30
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.chips)
            }
        }
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
                context.other_card:is_suit("Diamonds")
            then
                local active = nil -- needs a diamond suit to activate
                for i=1,#context.scoring_hand do
                -- if club or spade suit
                    if context.scoring_hand[i] == context.other_card then
                        break -- bruh it's the same damn card
                    elseif
                        context.scoring_hand[i]:is_suit("Spades")
                        or context.scoring_hand[i]:is_suit("Clubs")
                    then
                        active = context.scoring_hand[i].base.suit -- it comes after a diamond, we're done here ;)
                        break
                    end
                end
                if active == ("Clubs") then
                    return {
                        message = localize({
                            type = "variable",
                            key = "a_mult",
                            vars = { number_format(card.ability.extra.mult) },
                        }),
                        mult_mod = lenient_bignum(card.ability.extra.mult),
                        colour = G.C.MULT,
                    }
                elseif active == ("Spades") then
                    return {
                        message = localize({
                            type = "variable",
                            key = "a_mult",
                            vars = { number_format(card.ability.extra.chips) },
                        }),
                        chip_mod = lenient_bignum(card.ability.extra.chips),
                        colour = G.C.CHIPS,
                    }
                end
            end
        end
        if context.forcetrigger then -- do both chip and mult
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 0.3,
                blockable = false,
                func = function()
                    return {
                        message = localize({
                            type = "variable",
                            key = "a_mult",
                            vars = { number_format(card.ability.extra.mult) },
                        }),
                        mult_mod = lenient_bignum(card.ability.extra.mult),
                        colour = G.C.CHIPS,
                    }
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 0.3,
                blockable = false,
                func = function()
                    return {
                        message = localize({
                            type = "variable",
                            key = "a_chips",
                            vars = { number_format(card.ability.extra.chips) },
                        }),
                        chip_mod = lenient_bignum(card.ability.extra.chips),
                        colour = G.C.CHIPS,
                    }
                end
            }))
		end
    end
}

-- 44. Waveworx
local waveworx = {
	object_type = "Joker",
    key = 'waveworx',
    name = name('waveworx'),
    atlas = sprites,
    pos = get_pos(4,3),
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = false,
	demicoloncompat = false, -- NOPE!
    config =  { },
    loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.current_round.hands_played == 0 and localize("k_active_ex") or localize("rgmc_inactive")}}
    end,
    calculate = function(self, card, context)

        if -- the card is activated
            context.setting_blind
            or context.forcetrigger
        then
            G.GAME.MADCAP.force_poker_hand = "Straight"
            local eval = function()
                return G.GAME.current_round.hands_played > 0
            end
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
	object_type = "Joker",
    key = 'la_jokeonde',
    name = name('la_jokeonde'),
    atlas = sprites,
    pos = get_pos(4,4),
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true, -- can't really do much
    config =  {
        extra = {
            extra = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.extra or 1 } }
    end,
    calculate = function(self, card, context)


        if
            ((context.joker_main and RGMC.funcs.winning())
            or context.forcetrigger)
            and context.scoring_hand
        then
			for k, v in pairs(context.scoring_hand) do v.rgmc_scoring = true end

			local paintings = 0
			for k, v in pairs(G.play.cards) do
                if not (v.rgmc_scoring or v.edition) then
                    paintings = paintings + 1
                    G.E_MANAGER:add_event(Event({
						func = function()
                            v:set_edition(RGMC.funcs.get_weighted_edition(), true)
							return true
						end,
					}))
					if not (paintings < card.ability.extra.extra) then
                        break
					end
                end
            end
			for k, v in ipairs(context.scoring_hand) do v.rgmc_scoring = nil end
        end

        if
            context.after
            and not context.blueprint
        then
            -- Reset all those things
			for k, v in ipairs(context.scoring_hand) do v.rgmc_scoring = nil end
        end
    end
}

-- 46. Miracle Pop
local miracle_pop = {
	object_type = "Joker",
    key = 'miracle_pop',
    name = name('miracle_pop'),
    atlas = sprites,
    pos = get_pos(4,5),
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
        extra = {
            chips = 0,
            chip_mod = 5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chip_mod * 2),
                number_format(card.ability.extra.chips),
                number_format(G.hand and #G.hand.cards or 0),
                number_format((G.hand and #G.hand.cards > 1) and math.floor(card.ability.extra.chips / #G.hand.cards) or 0)
            }
        }
    end,
    calculate = function(self, card, context)
        if
            (context.cardarea == G.play
                and context.other_card
                and not context.after
                and not context.before
                and not context.blueprint)
            or context.forcetrigger
        then
            if -- clubs or spades activates
                context.other_card:is_suit("Hearts")
                or context.other_card:is_suit("rgmc_goblets")
            then
                local upgrade = card.ability.extra.chip_mod
                -- goblets double the amount
                if context.other_card:is_suit("rgmc_goblets") then
                    upgrade = upgrade * 2
                end
                card.ability.extra.chips = card.ability.extra.chips + upgrade
                return { -- TODO: replace this with the new chip amount? like with wee joker?
                    message = localize("k_upgrade_ex"),
                    card = card
                }
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
	object_type = "Joker",
    key = 'doom_bunny',
    name = name('doom_bunny'),
    atlas = sprites,
    pos = get_pos(4,6),
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
    calculate = function(self, card, context)

        if
            context.individual
            and context.cardarea == G.play
            and #G.playing_cards > 1    -- does not work if you have only 1 card
        then
            -- wild card
            if
                not context.other_card.debuff
                and context.other_card.config.center == G.P_CENTERS.m_wild
            then

                local temp_hand, finished = {}, false
                local from_card, to_card = context.other_card, nil
                local can_do = true

                -- Shuffle the hand
                for i = 1, #G.hand.cards do
                    if
                        G.hand.cards[i] ~= context.other_card
                    then
                        temp_hand[#temp_hand + 1] = G.hand.cards[i]
                    end
                end
                pseudoshuffle(temp_hand, pseudoseed('rgmc_doom_bunny'))

                -- Pick the first viable card
                local attempts = 0
                while attempts < 2 do
                    for i = 1, #temp_hand do
                        if -- prioritize other wild cards first?
                            (temp_hand[i].config.center ~= G.P_CENTERS.m_wild and attempts == 0)
                            or attempts == 1
                        then
                            to_card = temp_hand[i]
                            break
                        end
                    end
                    attempts = attempts + 1
                end


                if to_card then
                    local edition = from_card.edition
                    G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()

                        -- Rank
                        local to_key    = SMODS.Ranks[to_card.base.value].key
                        SMODS.change_base(from_card, _, to_key) -- change da rank

                        if to_card.seal then
                            from_card[i]:set_seal(to_card.seal, true, true)
                        end

                        if to_card.edition then
                            from_card:set_edition(to_card.edition,true,true)
                        end

                        from_card:juice_up(0.5, 0.7)
                        to_card:juice_up(0.5, 0.7)
                        play_sound('rgmc_contagion', 1, 0.6)
                    return true end }))
                end
            end
        end
    end
}

-- 48. Rocket Keychain
local rocket_keychain = {
	object_type = "Joker",
    key = 'rocket_keychain',
    name = name('rocket_keychain'),
    atlas = sprites,
    pos = get_pos(4,7),
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
    config =  {
        extra = {
            level_ups = 1,
            target_hand = "High Card"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.target_hand,
                number_format(card.ability.extra.level_ups),
                RGMC.funcs.get_most_played_hand()
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.target_hand = RGMC.funcs.get_random_poker_hand()
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound((sound or 'tarot2'), 0.76, 0.4)
                    card:juice_up(0.3, 0.4)
                return true
                end
            }))
        end
    end
}

-- 49. Rio
-- enchanted aces are BUFFED? what does that mean?
local legend_rio = {
	object_type = "Joker",
    key = 'legend_rio',
    atlas = 'jokers_legendary',
    pos = legend(1,false),
	soul_pos = legend(1,true),
    rarity = 4,
    cost = 15,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = false, -- can't really do much
    config =  {
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(RGMC.funcs.get_rio_rank(), 'ranks').."s"
            }
        }
    end,
    calculate = function(self, card, context)
		if
			context.cardarea == G.play
			and context.other_card -- must be another card
			and context.other_card.base.value == "Ace" -- base value must be an ace
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
	object_type = "Joker",
    key = 'legend_picky',
    name = name('legend_picky'),
    atlas = 'jokers_legendary',
    pos = legend(0,false),
	soul_pos = legend(0,true),
    rarity = 4,
    cost = 15,
    unlocked = true,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    blueprint_compat = true,
	demicoloncompat = true,
    config =  {
        extra = {
            x_mult = 1.75,
            x_mult_mult = 1.25,
        },
        immutable = {
            antes_completed = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.x_mult_mult*100 - 100),
                number_format(card.ability.immutable.antes_completed),
            }
        }
    end,
    calculate = function(self, card, context)
        if
            not context.individual
            and not context.repetition
            and context.end_of_round
            and not context.blueprint
            and G.GAME.blind.boss
            and not (G.GAME.blind.config and G.GAME.blind.config.bonus)
        then
            card.ability.immutable.antes_completed = card.ability.immutable.antes_completed + 1
            card.ability.extra.x_mult = card.ability.extra.x_mult * card.ability.extra.x_mult_mult -- add on 25%!
		end

        if
            context.forcetrigger
            or (context.cardarea == G.jokers and context.joker_main)
        then
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { number_format(card.ability.extra.x_mult) },
                }),
                Xmult_mod = lenient_bignum(card.ability.extra.x_mult),
                colour = G.C.MULT,
            }
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
