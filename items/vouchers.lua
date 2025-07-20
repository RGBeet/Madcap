

local combo_meal = {
	key 		= "combo_meal",
	cost 		= 6,
    config 		= { extra = 1.5, },
	redeem = function(self)

    end,
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(number_format(card.ability.extra))
    end,
    calculate = function (self, card, context)

        if context.end_of_round and not context.game_over and context.main_eval then
			-- if you get overkill, you get a free tarot card
            local diff = math.abs(to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) -- difference between your chips and blind chips
			if to_big(diff) / to_big(G.GAME.blind.chips) >= 1.5 then
				tell('Good job!')
				MadLib.simple_event(function()
					local card_type = "Tarot"
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

					local n = MadLib.get_random_card(card_type, G.consumeables, 'combo_meal')
					play_sound('timpani')
					n:add_to_deck()
					G.consumeables:emplace(n)

					G.GAME.consumeable_buffer = 0
					return true
				end, 0.15, 'immediate')
			end
		end

    end,
}

local supersize = {
	key 		= "supersize",
	cost 		= 9,
	requires 	= MadLib.get_voucher_reqs('rgmc_combo_meal'),
    config 		= { extra 	= 1.07, active	= true },
	redeem 		= function(self)
    end,
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(number_format(card.ability.extra))
    end,
    calculate 	= function (self, card, context)

        if
            context.end_of_round
			and not context.game_over    -- do nothing if you lose
			and context.main_eval
        then

			-- if you get overkill, you get a free tarot card
			local points, chip_goal = 0, G.GAME.blind.chips

			points = MadLib.build_onto_val(points, function(i)
				return to_big(G.GAME.chips) >= to_big(chip_goal) and i <= 10
			end, function(v,i)
				points = points + 1
				return v ^ self.config.extra
			end, false)

			tell_stat('Rewards Gained',points)

			-- Make a list of 1-9 consumables - weights in Madcap table.
			local rewards = MadLib.get_loop_func_number(math.min(points,9), function(i)
				local set = 'Tarot'
				return MadLib.get_random_card(set, G.consumeables, 'supersize')
			end)

			MadLib.loop_func_list(rwards, function(v,i)
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				MadLib.simple_event(function()
					play_sound('timpani')
					v:add_to_deck()
					v:set_edition({ negative = true }, true) -- now spawns as a Negative!
					G.consumeables:emplace(v)
					G.GAME.consumeable_buffer = 0
					return true
				end, 0.5, 'after')
			end)
		end
    end,
}

local everyman = {
	key 		= "everyman",
	cost 		= 6,
    config 		= { extra = 1.1 },
	redeem 		= function(self)
    end,
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(number_format(card.ability.extra))
    end,
    calculate 	= function (self, card, context)
        if context.after then
			local commons = Madcap.Funcs.get_common_jokers()
			if commons > 0 then return MadLib.do_x_score(card.ability.extra, commons) end
        end
    end,
}

local exceptional = {
	key 		= "exceptional",
	cost 		= 11,
	requires 	= MadLib.get_voucher_reqs('rgmc_everyman'),
    config 		= { extra = 1.01 },
	redeem 		= function(self)
    end,
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(number_format(card.ability.extra))
    end,
    calculate 	= function (self, card, context)
        if context.after then
			local commons = Madcap.Funcs.get_common_jokers()
			if commons > 0 then return MadLib.do_e_score(card.ability.extra, commons) end
        end
    end,
}

local big_bonus = {
	key 		= "big_bonus",
	cost 		= 3,
	unlocked 	= true,
	discovered 	= true,
	available 	= true,
    config 		= { extra = 8 },
	redeem 		= function(self)
    end,
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(number_format(card.ability.extra))
    end,
    calculate = function (self, card, context)
		if
			context.cardarea == G.play
			and context.individual
			and context.other_card
			and MadLib.list_matches_one(Madcap.Data.enhancement_lists.bonus, function(v,k)
				return SMODS.has_enhancement(context.other_card, "m_"..v)
			end)
		then
			local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
			local _chips = card.ability.extra * to_number(G.GAME.hands[text].level)

			return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, context.other_card, chips)
		end
    end
}

local massive_mult = {
	key 		= "massive_mult",
	cost 		= 7,
	requires 	= MadLib.get_voucher_reqs('rgmc_big_bonus'),
    config 		= { extra = 2 },
	redeem 		= function(self)
    end,
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(number_format(card.ability.extra))
    end,
    calculate 	= function (self, card, context)
		if
			context.cardarea == G.play
			and context.individual
			and context.other_card
			and MadLib.list_matches_one(Madcap.Data.enhancement_lists.mult, function(v,k)
				return SMODS.has_enhancement(context.other_card, "m_"..v)
			end)
		then
			local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
			local _mult = card.ability.extra * to_number(G.GAME.hands[text].level)

			return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, context.other_card, _mult)
		end
    end
}

local high_rise = {
	key = "high_rise",
	cost = 4,
    config = {
        extra 		= { retriggers = 1 },
        immutable 	= { max_retriggers = 25 }
    },
    loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(number_format(MadLib.clamp(card.ability.extra.retriggers, 1, card.ability.immutable.max_retriggers)))
    end,
    calculate = function (self, card, context)

		-- retrigger all held cards
		if
			context.repetition
			and context.cardarea == G.play
			and context.scoring_name == "High Card" -- has a scoring hand, of course
		then
			local high_card 	= context.scoring_hand[1]
			local retriggers 	= MadLib.clamp(card.ability.extra.retriggers, 1, card.ability.immutable.max_retriggers)
			return MadLib.get_retrigger_data(high_card,retriggers,localize('k_rgmc_high_rise'))
		end
    end
}

local high_roller = {
	key 		= "high_roller",
	cost 		= 8,
	requires 	= MadLib.get_voucher_reqs('rgmc_high_rise'),
    config = {
        extra 		= { retriggers = 1 },
        immutable 	= { max_retriggers = 25 }
    },
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(number_format(MadLib.clamp(card.ability.extra.retriggers, 1, card.ability.immutable.max_retriggers)))
    end,
    calculate = function (self, card, context)

		-- retrigger all held cards
		if
			context.repetition
			and context.cardarea == G.hand
			and context.scoring_name == "High Card" -- has a scoring hand, of course
		then
			local high_card 	= context.scoring_hand[1]
			local retriggers 	= MadLib.clamp(card.ability.extra.retriggers, 1, card.ability.immutable.max_retriggers)
			return MadLib.get_retrigger_data(high_card,retriggers,localize('k_rgmc_high_roller'))
		end
    end,
}

local function clamp_mayhem(val)
	local _total 	= ((G.GAME and G.GAME.Mayhem) or 0) + math.max(0,val)
	local _max 		= ((G.GAME and G.GAME.max_mayhem) or 10)
	return _total < _max and _total or (_max - _total)
end

local manifest = {
	key 		= "manifest",
	cost 		= 5,
    config = {
        extra = { antes = 1, mayhem = 1 },
        immutable = { max_antes = 25 }
    },
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(
			number_format(clamp_mayhem(card.ability.extra.mayhem)),
			number_format(MadLib.clamp(card.ability.extra.antes, 1, card.ability.immutable.max_antes))
		)
    end,
	redeem 		= function(self)
		Madcap.Funcs.ease_mayhem(clamp_mayhem(card.ability.extra.mayhem))
    end,
}

local mindmelt = {
	key 		= "mindmelt",
	cost 		= 8,
	requires 	= MadLib.get_voucher_reqs('rgmc_manifest'),
    config = {
        extra = { antes = 1, mayhem = 1 },
        immutable = { max_antes = 25 }
    },
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars(
			number_format(clamp_mayhem(card.ability.extra.mayhem)),
			number_format(MadLib.clamp(card.ability.extra.antes, 1, card.ability.immutable.max_antes))
		)
    end,
	redeem 		= function(self)
		Madcap.Funcs.ease_mayhem(clamp_mayhem(card.ability.extra.mayhem))
    end,
}

local cosma_merchant = {
	key 		= "cosma_merchant",
	cost 		= 6,
    config 		= { extra = 2 },
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars_colours( number_format(card.ability.extra), { G.C.SET.CosmaTarot })
    end,
	redeem 		= function(self)
		MadLib.simple_event(function()
			G.GAME.cosma_rate = (G.GAME.cosma_rate or 3) * card.ability.extra.display
			return true
		end)
    end,
}

local cosma_tycoon = {
	key 		= "cosma_tycoon",
	cost 		= 9,
    config 		= { extra = 4 },
	requires 	= MadLib.get_voucher_reqs('rgmc_cosma_merchant'),
    loc_vars 	= function(self, info_queue, card)
		return MadLib.collect_vars_colours( number_format(card.ability.extra), { G.C.SET.CosmaTarot })
    end,
	redeem 		= function(self)
		MadLib.simple_event(function()
			G.GAME.cosma_rate = (G.GAME.cosma_rate or 6) * math.floor(card.ability.extra.display/2)
			return true
		end)
    end,
}

local day_and_night = {
	key 		= "day_and_night",
	cost 		= 6,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.set_subhand('light',true)
			Madcap.Funcs.set_subhand('dark',true)
			return true
		end)
    end,
}

local midday = {
	key 		= "midday",
	cost 		= 8,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_day_and_night'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('light', 1)
			return true
		end)
    end,
}

local midnight = {
	key 		= "midnight",
	cost 		= 8,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_day_and_night'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('dark', 1)
			return true
		end)
    end,
}

local twilight = {
	key 		= "twilight",
	cost 		= 11,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_day_and_night','rgmc_midday','rgmc_midnight'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('dark', 2)
			Madcap.Funcs.empower_subhand('light', 2)
			return true
		end)
    end,
}

local ebb_and_flow = {
	key 		= "ebb_and_flow",
	cost 		= 5,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.set_subhand('high',true)
			Madcap.Funcs.set_subhand('low',true)
			return true
		end)
    end,
}

local eensy_weensy = {
	key 		= "eensy_weensy",
	cost 		= 7,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_ebb_and_flow'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('low', 1)
			return true
		end)
    end,
}

local extra_large = {
	key 		= "extra_large",
	cost 		= 7,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_ebb_and_flow'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('high', 1)
			return true
		end)
    end,
}

local the_median = {
	key 		= "the_median",
	cost 		= 10,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_ebb_and_flow','rgmc_eensy_weensy','rgmc_extra_large'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('high', 2)
			Madcap.Funcs.empower_subhand('low', 2)
			return true
		end)
    end,
}

local radiance = {
	key 		= "radiance",
	cost 		= 6,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.set_subhand('dazzling',true)
			return true
		end)
    end,
}

local brilliance = {
	key 		= "brilliance",
	cost 		= 9,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_brilliance'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('dazzling', 1)
			return true
		end)
    end,
}

local antimony = {
	key 		= "antimony",
	cost 		= 6,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.set_subhand('dazzling',true)
			return true
		end)
    end,
}

local antiquated = {
	key 		= "antiquated",
	cost 		= 9,
    config 		= { },
    loc_vars 	= function(self, info_queue, card)
		return Madcap.BlankVar
    end,
	requires 	= MadLib.get_voucher_reqs('rgmc_brilliance'),
	redeem 		= function(self)
		MadLib.simple_event(function()
			Madcap.Funcs.empower_subhand('dazzling', 1)
			return true
		end)
    end,
}

local list = {}
Madcap.Funcs.LoadVouchers({
	combo_meal,
	supersize,
	everyman,
	exceptional,
	big_bonus,
	massive_mult,
	high_rise,
	high_roller,
	manifest,
	mindmelt,
	day_and_night,
	midday,
	midnight,
	twilight,
	radiance,
	brilliance,
	antimony,
	antiquated,
	ebb_and_flow,
	eensy_weensy,
	extra_large,
	the_median
}, list, 'vouchers')

return {
    name = "Vouchers",
    init = function() print("Vouchers!") end,
    items = list
}
