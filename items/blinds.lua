local get_pos = function(n)
    return { x=0, y=n }
end

-- Used to get chip value for The Sum
local function get_sum_chips(self)
    local chippies = 0
    for key, _ in pairs(G.GAME.round_resets.blind_choices) do
        local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[key]]
        local blind_key = bl.key
        if blind_key ~= self.key then
            local blind_mult = bl.mult or 1
            chippies = chippies + get_blind_amount(G.GAME.round_resets.ante) * bl.mult
        end
    end
    return chippies
end

local boss_bottle = {
	object_type = "Blind",
    key = 'bottle',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(0),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('DF463F'),
    in_pool = function(self)
        if G.playing_cards then
            -- must have at least 5 goblet cards
            local goblets = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_suit("rgmc_goblets") then goblets = goblets + 1 end
            end
            return goblets > 4
        end
        return RGMC.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    mult = 2,
    dollars = 5,
    debuff = { suit = 'rgmc_goblets' },
}

local boss_sword = {
	object_type = "Blind",
    key = 'sword',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(1),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('435B8C'),
    in_pool = function(self)
        if G.playing_cards then
            -- must have at least 5 goblet cards
            local towers = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_suit("rgmc_towers") then towers = towers + 1 end
            end
            return towers > 4
        end
        return RGMC.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    mult = 2,
    dollars = 5,
    debuff = { suit = 'rgmc_towers' },
}

local keyhole_whitelist = {
    'High Card',
    'Pair',
    'Two Pair',
    'Three of a Kind',
    'Four of a Kind',
    'Straight',
    'Flush',
    'Full House',
    'Straight Flush',
    'Royal Flush'
}

-- Disables non-standard poker hand types
local boss_keyhole = {
	object_type = "Blind",
    key = 'keyhole',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(2),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('C6A839'),
    in_pool = function(self)
        return true
    end,
    mult = 2,
    dollars = 5,
	debuff_hand = function(self, cards, hand, handname, check)
		if not G.GAME.blind.disabled then
            for i=1, #keyhole_whitelist do -- is in the whitelist
                if handname == keyhole_whitelist[i] then return false end
            end
            G.GAME.blind.triggered = true
            return true -- outside whitelist
        end
        return false -- blind disabled
    end
}


local boss_ladder = {
	object_type = "Blind",
    key = 'ladder',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(3),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('7C5949'),
    config = {
        immutable = {
            min_rarity = 'Rare'
        },
        extra = {
            mult_increase = 1.00
        }
    },
    in_pool = function(self) -- must have at least 1 ladder joker
        if not G.jokers then
            return true
        else
            return RGMC.funcs.jokers_greater_than_rarity(G.jokers.cards,self.config.immutable.min_rarity,true) > 0 or RGMC.devmode
        end
    end,
    loc_vars = function(self, info_queue, card)
        local rarity = SMODS.Rarities[self.config.immutable.min_rarity]
        return {
            vars = {
                number_format(self.config.extra.mult_increase),
                localize(string.lower("k_" .. rarity.key))
            }
        }
    end,
    mult = 2,
    dollars = 5,
	set_blind = function(self, reset, silent)
        if not G.GAME.blind.disabled then

            local matches = RGMC.funcs.jokers_greater_than_rarity(G.jokers.cards,self.config.immutable.min_rarity,true) or 0
            local multiplier = 1

            if matches > 1 then
                tell("Ooh, now you've done it! You've increased the blind by X" .. tostring(multiplier) .. "!!")
                G.GAME.blind.triggered = true
            end

            local old_amount = G.GAME.blind.chips
            multiplier = multiplier + (matches * self.config.extra.mult_increase)
            G.GAME.blind.chips = G.GAME.blind.chips * multiplier

            G.GAME.rgmc_boss_blind_penalty = G.GAME.blind.chips / old_amount
            return true
        end
	end,
	disable = function(self, silent)
        if G.GAME and G.GAME.blind.disabled then
            -- revert!
            G.GAME.blind.chips = G.GAME.blind.chips / (G.GAME.rgmc_boss_blind_penalty or 1)
            G.GAME.rgmc_boss_blind_penalty = nil
        end
    end,
	defeat = function(self, silent)
        -- no longer needed
        G.GAME.rgmc_boss_blind_penalty = nil
	end,
}

local boss_levy = {
	object_type = "Blind",
    key = 'levy',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(4),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('3F8451'),
    in_pool = function(self)
        -- cannot be bankrupt
        return RGMC.devmode or (to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) > to_big(0)
    end,
    config = {
        extra = {
            levy = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(self.config.extra.levy or 1),
            }
        }
    end,
    mult = 1.5,
    dollars = 8,
    calculate = function (self, blind, context)
        if
            not blind.disabled
            and context.end_of_round
            and not context.repetition
            and not context.individual
        then
            ease_dollars(#G.hand.cards * -self.config.extra.levy)
            self.triggered = true
        end
    end
}

-- discard a card, it gets debuffed for the next three blinds :(
local boss_grave = {
	object_type = "Blind",
    key = 'grave',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(5),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('73Cc4E'),
    in_pool = function(self)
        return true -- always!
    end,
    mult = 2,
    dollars = 6,
	calculate = function(self, blind, context)
		if
            context.discard
            and not G.GAME.blind.disabled
            and not context.repetition
        then
            for k,v in pairs(G.hand.highlighted) do
                tell('Engraved')
                SMODS.Stickers["rgmc_engraved"]:apply(v,true)
            end
            -- make a death noise
		end
	end,
}

local boss_jest = {
	object_type = "Blind",
    key = 'jest',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(6),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('97Cd6A'),
    debuff = {
        add_antes = 1,
        blind_mult = 2
    },
    in_pool = function(self)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(self.debuff.blind_mult or 2),
                number_format(self.debuff.add_antes or 1),
            }
        }
    end,
    mult = 1.5,
    dollars = 5,
    calculate = function (self, blind, context)
        if
            not blind.disabled
            and context.end_of_round
            and not context.repetition
            and not context.individual
            and to_big(G.GAME.chips) > to_big(G.GAME.blind.chips) * blind.debuff.blind_mult
        then
            ease_ante(blind.debuff.add_antes)
        end
    end
}

local boss_force = {
	object_type = "Blind",
    key = 'force',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(7),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('47848B'),
    in_pool = function(self)
        if G.playing_cards then
            local negatives = 0
            for k, v in pairs(G.playing_cards) do
                if v.edition and v.edition.negative then negatives = negatives + 1 end
            end
            return negatives > 4
        end
        return RGMC.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    mult = 2,
    dollars = 7,
    stay_flipped = function(self, area, card)
        if
            card.edition
            and card.edition.negative
            and area == G.hand
        then
            return true
        end
	end,
    calculate = function (self, blind, context)
        if
            context.end_of_round
            and G.GAME.modifiers.rgmc_force_awakened
        then
            G.GAME.modifiers.rgmc_force_awakened = false    -- the force is dead
            G.GAME.modifiers.rgmc_force_chance = -1
        end
    end
}

--

local boss_elevator = {
	object_type = "Blind",
    key = 'elevator',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(8),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('A9463B'),
    config = {
        extra = {
            odds = 6,
        }
    },
    in_pool = function(self)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME and G.GAME.probabilities.normal or 1,
                self.config.extra.odds or 6
            }
        }
    end,
    mult = 2,
    dollars = 7,
	calculate = function(self, blind, context)
		if
			context.final_scoring_step
            and not G.GAME.blind.disabled
		then
            RGMC.funcs.flip_cards(context.scoring_hand, function(card)
                tell(card)
                local suit = SMODS.Suits[card.base.suit]

                local rank_data = SMODS.Ranks[card.base.value]
                local behavior = rank_data.strength_effect or { fixed = 1, ignore = false, random = false }
                local new_rank

                if behavior.ignore or not next(rank_data.next) then
                    return true
                elseif behavior.random then
                    -- TODO doesn't respect in_pool
                    new_rank = pseudorandom_element(rank_data.next, pseudoseed('strength'))
                else
                    local ii = (behavior.fixed and rank_data.next[behavior.fixed]) and behavior.fixed or 1
                    new_rank = rank_data.next[ii]
                end

                assert(SMODS.change_base(card, nil, new_rank))
            end)
        end
    end
}

local boss_sum = {
	object_type = "Blind",
    key = 'sum',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(9),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('423894'),
    in_pool = function(self)
        return true
    end,
    mult = 0,
    dollars = 5,
    rgmc_ante_start = function(self)
        G.GAME.blind.chips = get_sum_chips(self)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        return true
    end,
	set_blind = function(self, reset, silent)
        G.GAME.blind.chips = get_sum_chips(self)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        G.GAME.blind.triggered = true
        return true
	end,
	defeat = function(self, silent)
        -- no longer needed
        self.mult = 0
	end,
}

local boss_statue = {
	object_type = "Blind",
    key = 'statue',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(10),
	boss = { boss = true, min = -1, max = -1 },
    boss_colour = HEX('454E4D'),
    config = {
        extra = {
            odds = 6,
        }
    },
    in_pool = function(self)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME and G.GAME.probabilities.normal or 1,
                self.config.extra.odds or 6
            }
        }
    end,
    mult = 2,
    dollars = 5,
	calculate = function(self, blind, context)

		if
            context.final_scoring_step
            and not G.GAME.blind.disabled
		then
            local stoned = false
            for k,v in pairs(context.scoring_hand) do
                if -- fixed  1 in 6
                    (pseudorandom(pseudoseed("rgmc_statue")) < ((G.GAME.probabilities.normal) / self.config.extra.odds))
                then
                    tell('STONED!')
                    -- turn to stone
                    stoned = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:set_ability(G.P_CENTERS.m_stone)
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
            if stoned then
                -- make concrete noise for the laughs
                print("H!!!")
            end
		end
	end,
}

local final_blindfold = {
	object_type = "Blind",
    key = 'final_blindfold',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(15),
	boss = { showdown = true, min = -1, max = -1 },
    boss_colour = HEX('CFBB8F'),
    config = {
        extra = {
            mult_increase = 0.25,
            odds = 4 -- odds of showing up if player hasnt skipped any blinds
        }
    },
    in_pool = function(self)
        -- 1 in 4 chance to enter pool if you haven't skipped prior to this ante
        return G.GAME.MADCAP.blinds_skipped > 0
            or pseudorandom(pseudoseed("rgmc_blindfold")) < ((G.GAME.probabilities.normal) / self.config.extra.odds)
            or RGMC.devmode
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(self.config.extra.mult_increase or 0.25)
            }
        }
    end,
    mult = 2,
    dollars = 8,
	set_blind = function(self, reset, silent)
		if not G.GAME.blind.disabled then
            local blind_increase =  (1 + (G.GAME.MADCAP.blinds_skipped * self.config.extra.mult_increase))
            local new_amount = G.GAME.blind.chips * blind_increase

            tell_stat(blind_increase)
            if blind_increase > 1 then
                tell("Ooh, now you've done it! You've increased the blind by X" .. tostring(blind_increase) .. "!!")
                G.GAME.blind.triggered = true
            end

            G.GAME.rgmc_boss_blind_penalty = new_amount / G.GAME.blind.chips
            G.GAME.blind.chips = new_amount
			return true
		end
	end,
	disable = function(self, silent)
        if G.GAME and G.GAME.blind.disabled then
            -- revert!
            G.GAME.blind.chips = G.GAME.blind.chips / (G.GAME.rgmc_boss_blind_penalty or 1)
            G.GAME.rgmc_boss_blind_penalty = nil
        end
    end,
	defeat = function(self, silent)
        -- no longer needed
        G.GAME.rgmc_boss_blind_penalty = nil
	end,
}

local function get_suits_in_group(group)
    local suits = {}
    for k, v in pairs(group) do
        suits[v.base.suit] = true
    end

    local n = 0
    for k, v in pairs(suits) do
        n = n + 1
    end

    return n
end

local final_hoop = {
	object_type = "Blind",
    key = 'final_hoop',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(16),
	boss = { showdown = true, min = -1, max = -1 },
    boss_colour = HEX('712B9F'),
    config = {
        extra = {
            min_suits = 3
        }
    },
    in_pool = function(self)
        if G.playing_cards then
            return get_suits_in_group(G.playing_cards) >= self.config.extra.min_suits or RGMC.devmode
        else
            return false
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(self.config.extra.min_suits or 3)
            }
        }
    end,
    mult = 2,
    dollars = 9,
    debuff_hand = function(self, cards, hand, handname, check)
        if not G.GAME.blind.disabled then
            return num_suits < self.config.extra.min_suits
        else
            return false
        end
    end,
}

local final_pin = {
	object_type = "Blind",
    key = 'final_pin',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(17),
	boss = { showdown = true, min = -1, max = -1 },
    boss_colour = HEX('ABB3FF'),
    config = {
        immutable = {
            min_rarity = 'Rare'
        },
        extra = {
            mult_increase = 1.00
        }
    },
    in_pool = function(self)
        if not G.jokers then
            return true
        else
            return RGMC.funcs.jokers_greater_than_rarity(G.jokers.cards,self.config.immutable.min_rarity,true) > 0 or RGMC.devmode
        end
    end,
    loc_vars = function(self, info_queue, card)
        local rarity = SMODS.Rarities[self.config.immutable.min_rarity]
        return {
            vars = {
                number_format(self.config.extra.mult_increase),
                localize(string.lower("k_" .. rarity.key))
            }
        }
    end,
    mult = 2,
    dollars = 8,
	set_blind = function(self, reset, silent)
        if not G.GAME.blind.disabled then

            local matches = RGMC.funcs.jokers_greater_than_rarity(G.jokers.cards,self.config.immutable.min_rarity,true)
            local multiplier = 1

            tell_stat("Matches",matches)
            print(matches)

            if matches and matches > 1 then
                tell("Ooh, now you've done it! You've increased the blind by X" .. tostring(multiplier) .. "!!")
                G.GAME.blind.triggered = true
            end

            local old_amount = G.GAME.blind.chips
            multiplier = multiplier + (matches * self.config.extra.mult_increase)
            G.GAME.blind.chips = G.GAME.blind.chips * multiplier

            G.GAME.rgmc_boss_blind_penalty = G.GAME.blind.chips / old_amount
            return true
        end
	end,
	disable = function(self, silent)
        if G.GAME and G.GAME.blind.disabled then
            -- revert!
            G.GAME.blind.chips = G.GAME.blind.chips / (G.GAME.rgmc_boss_blind_penalty or 1)
            G.GAME.rgmc_boss_blind_penalty = nil
        end
    end,
	defeat = function(self, silent)
        -- no longer needed
        G.GAME.rgmc_boss_blind_penalty = nil
	end,
}

local final_chimes = {
	object_type = "Blind",
    key = 'final_chimes',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(18),
	boss = { showdown = true, min = -1, max = -1 },
    boss_colour = HEX('C9A0DC'),
    in_pool = function(self)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        local key = SMODS.Ranks[tostring(G.GAME.MADCAP.x_value)].key
        return {
            vars = {
                (G.GAME and G.GAME.MADCAP) and (key or "N/A") or "?!?"
            }
        }
    end,
    mult = 1.25,
    dollars = 8,
	debuff_hand = function(self, cards, hand, handname, check)
        if not G.GAME.blind.disabled then
            local _, _2, _3, scoring = G.FUNCS.get_poker_hand_info(cards)

            -- Splash scores all cards.
            if next(find_joker('Splash')) then
                scoring = cards
            end

            local key = SMODS.Ranks[tostring(G.GAME.MADCAP.x_value)].key
            for i = 1, #scoring do
                if scoring[i].base.value == key then
                    return false
                end
            end
            return true
        end
    end
}

function RGMC.funcs.manipulate_chips_mult(chips,mult)
    G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.5, 0.5)
    hand_chips = 0
    mult = 0
end

local final_target = {
	object_type = "Blind",
    key = 'final_target',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(19),
	boss = { showdown = true, min = -1, max = -1 },
    boss_colour = HEX('D22A49'),
    debuff = {
        chip_window = 2,
    },
    config = {
        active = true
    },
    in_pool = function(self)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                number_format(1/self.debuff.chip_window)
            }
        }
    end,
    mult = 1.75,
    dollars = 8,
    calculate = function(self, card, context)
        if
            not G.GAME.blind.disabled
            and context.rgmc_total_score
        then

            local chip_window = 1/self.debuff.chip_window
            local minimum  = G.GAME.blind.chips * chip_window
            local maximum = G.GAME.blind.chips * (1+chip_window)
            local new_total = G.GAME.chips + context.rgmc_total_score

            tell('Minimum: ' .. tostring(minimum) ..  ', Score,' .. tostring(new_total) .. ', Maximum: ' .. tostring(maximum))

            if
                to_big(new_total) > to_big(maximum)
                or to_big(new_total) < to_big(minimum)
            then
                G.GAME.chips = 0
                RGMC.funcs.manipulate_chips_mult(0,0)
                G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 1,
                func = function()
                    G.GAME.blind:wiggle() -- nuh uh!
                    G.GAME.blind.triggered = true
                    return true
                end
            }))
            end
        end
    end,
}

local final_void = {
	object_type = "Blind",
    key = 'final_void',
    atlas = 'blinds',
    discovered = true,
    pos = get_pos(20),
	boss = { showdown = true, min = -1, max = -1 },
    boss_colour = HEX('5C5C5C'),
    in_pool = function(self)
        local negatives = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if v.edition and v.edition.negative then negatives = negatives + 1 end
            end
        end
        return RGMC.devmode or negatives > 7
    end,
    loc_vars = function(self, info_queue, card)
    end,
    mult = 2,
    dollars = 9,
	debuff_hand = function(self, cards, hand, handname, check)
        if not G.GAME.blind.disabled then
            local condition = true
            for i = 1, #cards do
                if cards[i].edition and cards[i].edition.negative then return false end -- negative card
            end
            return true -- no negative cards
        end
        return false -- blind disabled
    end
}

local list = {
    boss_bottle,
    boss_sword,
    boss_keyhole,
    boss_ladder,
    boss_levy,
    boss_grave,
    boss_jest,
    boss_force,
    boss_elevator,
    boss_sum,
    boss_statue,
    final_blindfold,
    final_hoop,
    final_pin,
    final_chimes,
    final_target,
    final_void
}

for i=1, #list do
    if list[i] then list[i].order = i-1 end
end

return {
    name = "Blinds",
    init = function() print("Blinds!") end,
    items = list
}
