

-- Quick way of determining whether the context involves editions
-- (usually trigger if a Joker or scoring card has one)
function Madcap.Funcs.edition_in_play(context, card)
	return (
		context.edition
		and context.cardarea == G.jokers
		and card.config.trigger
	) or (
		context.main_scoring
		and context.cardarea == G.play
	)
end

-- end of edition funcs

local iridescent = {
    key 	= 'iridescent',
	shader 	= 'iridescent',
	weight 	= 2,
	in_shop = true,
	extra_cost = 4,
	config = {
		x_chips = 2.5,
		trigger = nil
	},
	sound = {
		sound = "rgmc_e_iridescent",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		return MadLib.collect_vars(self.config.x_chips)
	end,
	calculate = function(self, card, context)
		if Madcap.Funcs.edition_in_play(context,card) then

			-- Redistributes the sum of chips and mult 70-30
			-- (larger value gets 70%, smaller gets 30%)
			local tyler = hand_chips + mult
			local major = hand_chips >= mult and 'hand_chips' or 'mult'
			local minor = hand_chips <= mult and 'mult' or 'hand_chips'
			local major_score, minor_score = tyler*0.7, tyler*0.3

			hand_chips = major == 'hand_chips' and major_score or minor_score
			mult = major == 'mult' and major_score or minor_score

			G.HUD:get_UIE_by_ID('hand_chips'):juice_up(0.5, 0.5)
			G.HUD:get_UIE_by_ID('hand_mult'):juice_up(0.3, 0.3)

			play_sound("gong", 0.94 * 1.5, 0.2)

			return {
				message = localize("rgmc_balanced"),
				colour = G.C.PURPLE
			}
		end

		if context.joker_main then
			card.config.trigger = true -- context.edition triggers twice, this makes it only trigger once (only for jonklers)
		end

		if context.after then
			card.config.trigger = nil
		end
	end,
}

local infernal = {
    key 	= 'infernal',
	shader 	= 'infernal',
	weight 	= 2,
	extra_cost = 5,
	config = {
		x_score = 3,
		odds = 3,
		will_shatter = false,
		trigger = nil
	},
	sound = {
		sound = "rgmc_e_infernal",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		return MadLib.collect_vars(self.config.x_score, G.GAME.probabilities.normal or 1, self.config.odds)
	end,
	calculate = function(self, card, context)

        if
            Madcap.Funcs.edition_in_play(context,card)
            or context.joker_main
		then
			card.ability.infernaled = true
            return {
				message = "...?",
				colour = G.C.PURPLE
			}
		end

        if	-- Gives X3 Score after scoring
			context.after
			and card.ability.infernaled
		then
            return MadLib.do_x_score(self.config.x_score)
        end

        -- If card was activated at any time during blind, 1 in 3 chance it BURNS UP!
        if context.end_of_blind then
			if
				card.ability.infernaled 		-- has been activated at least once this round
                and not card.ability.eternal	-- not eternal
            then
				if  MadLib.calculate_roll({
                seed = 'rgmc_infernal',
                denom = self.config.extra.odds
				}) then
					if Yahimod then -- yahimod make card go BOOM!
						tell('Card asplode')
						explodeCard(card)
					else
						card:start_dissolve()
						card = nil
					end
				end

			end
			if card then card.ability.infernaled = nil end
		end


		if context.joker_main then
            card.config.trigger = true
        end

		if context.after then
            card.config.trigger = nil
        end
	end,
}

-- credit to astronomica for idea
local chrome = {
    key 	= 'chrome',
	shader 	= 'chrome',
	weight 	= 3, --slightly rarer than Polychrome
	in_shop = true,
	extra_cost = 5,
	config = { x_score = 1.5, },
	sound = {
		sound = "rgmc_e_chrome",
		per = 1,
		vol = 0.2,
	},
	active = false,
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		return MadLib.collect_vars(self.config.x_score)
	end,
	calculate = function(self, card, context)

        if
            Madcap.Funcs.edition_in_play(context,card)
            or context.joker_main
		then
			card.ability.chromed = true
            return {
				message = "...?",
				colour = G.C.PURPLE
			}
		end

        if
			context.after
			and card.ability.chromed
		then
			card.ability.infernaled = nil -- not needed now
            return MadLib.do_x_score(self.config.x_score)
        end

	end
}

local disco_weights = {
	{ key = "a_chips", 		weight 	= 6, },
	{ key = "a_mult", 		weight 	= 5, },
	{ key = "a_dollars", 	weight 	= 4, },
	{ key = "x_mult", 		weight 	= 3, },
	{ key = "x_score", 		weight 	= 2, },
	{ key = "x_dollars", 	weight 	= 1, },
}

local disco = {
    key 	= 'disco',
	shader 	= 'disco',
	weight = 2,
	extra_cost = 2,
	config = {
		a_chips = 40,
		a_mult = 8,
		x_mult = 2,
		a_dollars = 7,
		x_dollars = 1.5,
		x_score = 2,
		trigger = nil
	},
	sound = {
		sound = "rgmc_e_disco",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		return MadLib.collect_vars(
			self.config.a_chips or 40,
			self.config.a_mult or 8,
			self.config.x_mult or 2,
			self.config.a_dollars or 7,
			self.config.x_score or 2,
			self.config.x_dollars or 1.5)
	end,
	calculate = function(self, card, context)

		if Madcap.Funcs.edition_in_play(context,card) then

			-- Weighted random choice
			local choice = nil
			local total_weight = 0
			for i = 1, #disco_weights do
				total_weight = total_weight + disco_weights[i].weight
			end

			local nubby = pseudorandom('rgmc_disco_picker', 1, total_weight)

			local running_weight = 0
			for i = 1, #disco_weights do
				running_weight = running_weight + disco_weights[i].weight
				if nubby <= running_weight then
					choice = disco_weights[i].key
					break
				end
			end

			if not self.config[choice] then choice = nil end

			if choice == 'x_dollars' then
				ease_dollars(G.GAME.dollars * lenient_bignum(self.config[choice]))
				return {
					message = "X$" .. lenient_bignum(self.config[choice]),
					colour = G.C.MONEY
				}
			elseif choice == 'a_dollars' then
				ease_dollars(G.GAME.dollars + lenient_bignum(self.config[choice]))
				return {
					message = "+$" .. lenient_bignum(self.config[choice]),
					colour = G.C.MONEY
				}
			elseif choice == 'x_mult' then
				return {
					Xmult_mod = lenient_bignum(self.config[choice]),
					colour = G.C.MULT,
				}
			elseif choice == 'a_mult' then
				return {
					mult_mod = lenient_bignum(self.config[choice]),
					colour = G.C.MULT,
				}
			elseif choice == 'a_chips' then
				return {
					chip_mod = lenient_bignum(self.config[choice]),
					colour = G.C.CHIPS,
				}
			elseif choice == 'x_score' then
				MadLib.simple_event(function()
					G.GAME.chips = to_big(G.GAME.chips) * to_big(amt)
					G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
					play_sound('holo1')
					return true
				end, 0.4, 'after')
				return {
					message = "...?",
					colour = G.C.PURPLE
				}
			else -- this shouldn't happen
				return {
					message = "...",
					colour = G.C.FILTER
				}
			end
		end

		if context.joker_main then
            card.config.trigger = true
        end

		if context.after then
            card.config.trigger = nil
        end
	end,
}

local galactic = {
    key 	= 'galactic',
	shader 	= 'galactic',
	weight = 2,
	in_shop = true,
	extra_cost = 6,
	config = {
		-- idk
	},
	sound = {
		sound = "rgmc_e_disco",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		local poker_hand 	= G.GAME.last_played_hand or 'High Card'
		local hand_chips 	= G.GAME and G.GAME.hands[poker_hand].chips or 5
		local hand_level 	= G.GAME and G.GAME.hands[poker_hand].level or 1
		local total 		= math.floor(hand_chips/2 * hand_level)
		return MadLib.collect_vars(poker_hand,
			number_format(hand_chips),
			number_format(hand_level),
			number_format(total))
	end,
	calculate = function(self, card, context)
		-- get the data for the last played poker hand
		if
			Madcap.Funcs.edition_in_play(context,card)
			and G.GAME.last_played_hand
		then
			local total = math.floor(G.GAME.hands[poker_hand].chips/2 * G.GAME.hands[poker_hand].level)
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, total)
		end
	end,
}

local abyssal = {
    key 	= 'abyssal',
	shader 	= 'abyssal',
	weight = 2,
	in_shop = true,
	extra_cost = 6,
	config = {
		extra = { xmult_mod = 0.08 }
	},
	sound = {
		sound = "rgmc_e_disco",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		local total = (G.GAME.Mayhem or 0) * self.config.extra.xmult_mod
		return MadLib.collect_vars(total, self.config.extra.xmult_mod)
	end,
	calculate = function(self, card, context)
		if
			Madcap.Funcs.edition_in_play(context,card)
			and G.GAME.Mayhem > 0
		then
			local total = G.GAME.Mayhem * self.config.extra.xmult_mod
            return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, total)
		end
	end,
}

local luxury = {
    key 	= "luxury",
	shader 	= 'luxury',
	weight = 2,
	extra_cost = 2,
	config = {
		extra = {
			money_mod 	= 3,
			extra = 1
		},
		trigger = nil,
	},
	sound = {
		sound = "rgmc_e_disco",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		return MadLib.collect_vars(self.config.extra.extra, self.config.extra.money_mod)
	end,
	calculate = function(self, card, context)

		-- adds luxury points
		if Madcap.Funcs.edition_in_play(context,card) then
			G.GAME.luxury_points = G.GAME.luxury_points + 1
            return {
				message = "!!",
				colour	= G.C.PURPLE,
				card 	= card
			}
		end

		if -- takes money at end of round
            context.playing_card_end_of_round
			and to_big(G.GAME.dollars) - to_big(self.config.extra.money_mod) >= to_big(0)
        then
            ease_dollars(-self.config.extra.money_mod)
        end
	end,
}


local flipped = {
	object_type = "Edition",
    key = "flipped",
	shader = "flipped",
	weight = 2,
	config = {
		extra = { chips = 16 },
		trigger = nil,
	},
	sound = {
		sound = "rgmc_e_flipped",
		per = 1,
		vol = 0.2,
	},
	get_weight = function(self)
		return G.GAME.edition_rate * self.weight
	end,
	loc_vars = function(self, info_queue)
		return MadLib.collect_vars(self.config.extra.chips)
	end,
	calculate = function(self, card, context)
	end,
}

local default_get_weight = function(self)
	return 1
end

function Madcap.Funcs.LoadEditions(_f,_t,_args)
	MadLib.loop_func_list(_f,function(w,i)
		if not w or w.key then return false end
		Madcap.Orders['Edition'] = Madcap.Orders['Edition'] + 1
		w.object_type	= "Edition"
		w.shader		= w.shader or w.key
		w.in_shop		= w.in_shop or false
		w.extra_cost		= w.extra_cost or 0
		w.get_weight 	= w.get_weight or default_get_weight
		w.order     	= w.order or Madcap.Orders['Edition']
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
    end)
end


local list = {
    iridescent,
    infernal,
    chrome,
    disco,
	galactic,
	abyssal,
	luxury,
	flipped
}

for i=1, #list do
	list[i].object_type = "Edition"
	list[i].order 		= i
end

return {
    name = "Editions",
    init = function() print("Editions!") end,
    items = list
}
