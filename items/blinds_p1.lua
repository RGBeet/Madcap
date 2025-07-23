
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
    key = 'bottle',
    pos = MLIB.coords(0),
    boss_colour = HEX('DF463F'),
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            v:is_suit('rgmc_goblets')
        end) > 4 or Madcap.Data.devmode
    end,
    debuff = { suit = 'rgmc_goblets' },
}

local boss_sword = {
    key = 'sword',
    pos = MLIB.coords(1),
    boss_colour = HEX('435B8C'),
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            v:is_suit('rgmc_towers')
        end) > 4 or Madcap.Data.devmode
    end,
    debuff = { suit = 'rgmc_towers' },
}

Madcap.KeyholeWhitelist = {
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
    key = 'keyhole',
    pos = MLIB.coords(2),
    boss_colour = HEX('C6A839'),
    in_pool = function(self) return true end,
	debuff_hand = function(self, cards, hand, handname, check)
        return (not G.GAME.blind.disabled) and MadLib.list_matches_one(Madcap.KeyholeWhitelist, function(v)
            if handname == v then
                G.GAME.blind:wiggle() -- nuh uh!
                G.GAME.blind.triggered = true
            else
                return false
            end
        end)
    end
}

local boss_ladder = {
    key = 'ladder',
    pos = MLIB.coords(3),
    boss_colour = HEX('7C5949'),
    config = {
        immutable = { min_rarity = 'Rare' },
        extra = { mult_increase = 0.75 }
    },
    in_pool = function(self) -- must have at least 1 ladder joker
        return (not G.jokers)
            or #MadLib.get_jokers_matching_min_rarity(G.jokers.cards,self.config.immutable.min_rarity) > 0
            or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, blind)
        return MadLib.collect_vars(number_format(blind and blind.ability.extra.mult_increase or 1),
            localize(string.lower("k_" .. SMODS.Rarities[blind and blind.ability.immutable.min_rarity or 'Rare'].key)))
    end,
	set_blind = function(self, reset, silent)
        if not G.GAME.blind.disabled then

            local matches = #MadLib.get_jokers_matching_min_rarity(G.jokers.cards,self.config.immutable.min_rarity)
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
    key = 'levy',
    pos = MLIB.coords(4),
    boss_colour = HEX('3F8451'),
    in_pool = function(self)
        -- cannot be bankrupt
        return (to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) > to_big(0)
            or Madcap.Data.devmode
    end,
    config = { extra = 1 },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(self.config.extra or 1))
    end,
    mult = 1.5,
    dollars = 8,
    calculate = function (self, blind, context)
        if
            not G.GAME.blind.disabled
            and context.end_of_round
            and not context.repetition
            and not context.individual
        then
            ease_dollars(#G.hand.cards * -self.config.extra)
            self.triggered = true
        end
    end
}

-- discard a card, it gets debuffed for the next three blinds :(
local boss_grave = {
    key = 'grave',
    pos = MLIB.coords(5),
    boss_colour = HEX('73Cc4E'),
    in_pool = function(self)
        return true -- always appears!
    end,
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
    key = 'jest',
    pos = MLIB.coords(6),
    boss_colour = HEX('97Cd6A'),
    debuff = { add_antes = 1, blind_mult = 2 },
    in_pool = function(self)
        -- cannot appear if added antes skips the finisher ante
        return math.floor(G.GAME.round_resets.ante/G.GAME.win_ante) == math.floor(((G.GAME.round_resets.ante or 1) + self.debuff.add_antes) / G.GAME.win_ante)
    end,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(self.debuff.blind_mult or 2),
            number_format(self.debuff.add_antes or 1))
    end,
    mult = 1.5,
    dollars = 6,
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
    key = 'force',
    pos = MLIB.coords(7),
    boss_colour = HEX('47848B'),
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            return v.edition and v.edition.negative
        end) > 4 or Madcap.Data.devmode
    end,
    dollars = 6,
    stay_flipped = function(self, area, card) return area == G.hand and card.edition and card.edition.negative end,
    calculate = function (self, blind, context)
        if context.end_of_round and G.GAME.modifiers.rgmc_force_awakened then
            G.GAME.modifiers.rgmc_force_awakened = false -- the force is dead
            G.GAME.modifiers.rgmc_force_chance = -1
        end
    end
}

local boss_elevator = {
    key = 'elevator',
    pos = MLIB.coords(8),
    boss_colour = HEX('A9463B'),
    config = { extra = { odds = 6, } },
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            return not v:is_rankless()
        end) > (#G.playing_cards / 4) or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, blind)
        return MadLib.collect_vars(blind and MadLib.base_prob(blind) or 1, blind and blind.ability.extra.odds or 6)
    end,
    dollars = 6,
	calculate = function(self, blind, context)
		if
			context.final_scoring_step
            and not G.GAME.blind.disabled
            and MadLib.calculate_roll({
                seed = 'rgmc_elevator',
                denom = self.config.extra.odds
            })
		then
            MadLib.flip_cards(context.scoring_hand, function(v)
                assert(SMODS.modify_rank(v, card.ability.extra.times))
            end)
        end
    end
}

local boss_sum = {
    key = 'sum',
    pos = MLIB.coords(9),
    boss_colour = HEX('423894'),
    in_pool = function(self)
        return true
    end,
    mult = 0,
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
    key = 'statue',
    pos = MLIB.coords(10),
    boss_colour = HEX('454E4D'),
    config = { extra = { odds = 6, } },
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            return not SMODS.has_enhancement(v, 'm_stone')
        end) > (#G.playing_cards / 4) or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(MadLib.base_prob(card), card.ability.extra.odds or 6)
    end,
	calculate = function(self, blind, context)

		if context.final_scoring_step and not G.GAME.blind.disabled then
            -- Get a random selection.
            local stoned = MadLib.get_list_matches(context.scoring_hand,function (v)
                return not SMODS.has_enhancement(v, 'm_stone')
                and MadLib.calculate_roll({ seed = 'rgmc_statue', denom = self.config.extra.odds })
            end)

            if #stoned > 0 then
                MadLib.flip_cards(stoned, function(v)
                    v:set_ability(G.P_CENTERS.m_stone)
                end, nil, function(v)
                    MadLib.simple_event(function()
                        v:juice_up()
                        return true
                    end)
                end)

                -- make concrete noise for the laughs
            end
		end
	end,
}

local final_blindfold = {
    key = 'final_blindfold',
    pos = MLIB.coords(15),
    boss_colour = HEX('CFBB8F'),
    config = { extra = { mult_increase = 0.4, odds = 4 } },
    in_pool = function(self)
        -- 1 in 4* chance to enter pool if you haven't skipped prior to this ante
        return G.GAME.MADCAP.blinds_skipped > 0
            or MadLib.calculate_roll({
                seed = 'rgmc_final_blindfold',
                denom = self.config.extra.odds
            })
            or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(self.config.extra.mult_increase or 0.25)
    end,
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

local final_hoop = {
    key = 'final_hoop',
    pos = MLIB.coords(16),
    boss_colour = HEX('712B9F'),
    config = { extra = { min_suits = 3 } },
    in_pool = function(self)
        return G.playing_cards or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(self.config.extra.min_suits or 3)
    end,
    mult = 2,
    dollars = 9,
    debuff_hand = function(self, cards, hand, handname, check)
        local trigger = (not G.GAME.blind.disabled)
        and (#MadLib.get_suits_from_cards(cards) < self.config.extra.min_suits)
        or false
        if trigger then
            G.GAME.blind:wiggle() -- nuh uh!
            G.GAME.blind.triggered = true
        end
        return trigger
    end,
}

local final_pin = {
    key = 'final_pin',
    pos = MLIB.coords(17),
    boss_colour = HEX('ABB3FF'),
    config = {
        immutable = { min_rarity = 'Rare' },
        extra = { mult_increase = 1.5 }
    },
    in_pool = function(self)
        return (not G.jokers)
            or #MadLib.get_jokers_matching_min_rarity(G.jokers.cards,self.config.immutable.min_rarity) > 0
            or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
        return  MadLib.collect_vars(number_format(card.ability.extra.mult_increase),
            localize(string.lower("k_" .. SMODS.Rarities[self.config.immutable.min_rarity].key)))
    end,
	set_blind = function(self, reset, silent)
        if not G.GAME.blind.disabled then

            local matches = #MadLib.get_jokers_matching_min_rarity(G.jokers.cards,self.config.immutable.min_rarity)
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
    key = 'final_chimes',
    pos = MLIB.coords(18),
    boss_colour = HEX('C9A0DC'),
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            return v:get_id() == SMODS.Ranks[tostring(G.GAME.MADCAP.x_value)].key
        end) > 4 or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
        return  MadLib.collect_vars(number_format((G.GAME and G.GAME.MADCAP) and (SMODS.Ranks[tostring(G.GAME.MADCAP.x_value)].key or "N/A") or "?!?"))
    end,
    mult = 1.25,
	debuff_hand = function(self, cards, hand, handname, check)
        if not G.GAME.blind.disabled then
            local _, _2, _3, scoring = G.FUNCS.get_poker_hand_info(cards)

            -- Splash scores all cards.
            if next(find_joker('Splash')) then scoring = cards end

            local key = SMODS.Ranks[tostring(G.GAME.MADCAP.x_value)].key
            for i = 1, #scoring do
                if scoring[i].base.value == key then return false end
            end
            G.GAME.blind:wiggle() -- nuh uh!
            G.GAME.blind.triggered = true
            return true
        end
    end
}

local final_target = {
    key = 'final_target',
    pos = MLIB.coords(19),
    boss_colour = HEX('D22A49'),
    debuff = { chip_window = 2, },
    config = { active = true },
    in_pool = function(self)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(1/self.debuff.chip_window))
    end,
    mult = 1.75,
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
                MadLib.manipulate_chips_mult(0,0)
                MadLib.simple_event(function()
                    G.GAME.blind:wiggle() -- nuh uh!
                    G.GAME.blind.triggered = true
                    return true
                end, 1)
            end
        end
    end,
}

local final_void = {
    key = 'final_void',
    pos = MLIB.coords(20),
    boss_colour = HEX('5C5C5C'),
    in_pool = function(self)
        return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
            return v.edition and v.edition.negative
        end) > (#G.playing_cards / 2) or Madcap.Data.devmode
    end,
    loc_vars = function(self, info_queue, card)
    end,
    dollars = 9,
	debuff_hand = function(self, cards, hand, handname, check)
        return (not G.GAME.blind.disabled) and not MadLib.list_matches_one(cards, function(v)
            if v.edition and v.edition.negative then
                G.GAME.blind:wiggle() -- nuh uh!
                G.GAME.blind.triggered = true
                return true
            else
                return false
            end
        end)
    end
}

local list = {}
Madcap.Funcs.LoadBlind({
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
}, list, 'blinds')

return {
    name = "Blinds",
    init = function() print("Blinds!") end,
    items = list
}
