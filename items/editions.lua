local iridescent = {
	object_type = "Edition",
    key = "iridescent",
	order = 6,
	weight = 2,
	shader = "iridescent",
	in_shop = true,
	extra_cost = 5,
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
		return { vars = { self.config.x_chips } }
	end,
	calculate = function(self, card, context)
		if RGMC.funcs.edition_in_play(context,card) then

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
	object_type = "Edition",
    key = "infernal",
	order = 7,
	weight = 2,
	shader = "infernal",
	in_shop = false,
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
		return {
			vars = {
				self.config.x_score,
				(G.GAME.probabilities.normal or 1),
				self.config.odds or 3
			}
		}
	end,
	calculate = function(self, card, context)

        if
            RGMC.funcs.edition_in_play(context,card)
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
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
				func = function()
					G.GAME.chips = (to_big(G.GAME.chips))*(to_big(self.config.x_score))
					G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
					play_sound('holo1')
                    card.ability.infernaled = nil -- not needed now
					return true
				end,
			}))

            return {
				message = "X" .. tostring(self.config.x_score),
				colour = G.C.PURPLE
			}
        end

        -- If card was activated at any time during blind, 1 in 3 chance it BURNS UP!
        if context.end_of_blind then
			if
				card.ability.infernaled 		-- has been activated at least once this round
                and not card.ability.eternal	-- not eternal
            then

				local chance = pseudorandom('rgmc_infernal')
				tell('Infernal Chance: ' .. tostring(chance) .. ' ~ ' .. tostring(G.GAME.probabilities.normal / self.config.odds))

				if
					chance < G.GAME.probabilities.normal / self.config.odds		-- 1 in 3
				then
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
	object_type = "Edition",
    key = "chrome",
	order = 10,
	weight = 3, --slightly rarer than Polychrome
	shader = "chrome",
	in_shop = true,
	extra_cost = 5,
	config = {
		x_score = 1.5,
	},
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
		return { vars = { self.config.x_score } }
	end,
	calculate = function(self, card, context)
        if
            RGMC.funcs.edition_in_play(context,card)
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
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
				func = function()
					G.GAME.chips = (to_big(G.GAME.chips))*(to_big(self.config.x_score))
					G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
					play_sound('holo1')
                    card.ability.chromed = nil -- not needed now
					return true
				end,
			}))
            return {
				message = "X" .. tostring(self.config.x_score),
				colour = G.C.PURPLE
			}
        end
	end
}

local disco_weights = {
	{
		key 	= "a_chips",
		weight 	= 6,
	},
	{
		key 	= "a_mult",
		weight 	= 5,
	},
	{
		key 	= "a_dollars",
		weight 	= 4,
	},
	{
		key 	= "x_mult",
		weight 	= 3,
	},
	{
		key 	= "x_score",
		weight 	= 2,
	},
	{
		key 	= "x_dollars",
		weight 	= 1,
	},
}

local disco = {
	object_type = "Edition",
    key = "disco",
	order = 13,
	weight = 2,
	shader = "disco",
	in_shop = false,
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
		return {
			vars = {
				number_format(self.config.a_chips or 40),
				number_format(self.config.a_mult or 8),
				number_format(self.config.x_mult or 2),
				number_format(self.config.a_dollars or 7),
				number_format(self.config.x_score or 2),
				number_format(self.config.x_dollars or 1.5),
			}
		}
	end,
	calculate = function(self, card, context)

		if RGMC.funcs.edition_in_play(context,card) then

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

			print(choice)

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
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
					func = function()
						G.GAME.chips = (to_big(G.GAME.chips))*(to_big(self.config.x_score))
						G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
						play_sound('holo1')
						return {
							message = "X" .. tostring(self.config.x_score),
							colour = G.C.PURPLE
						}
					end,
				}))
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

-- From here:
-- https://www.shadertoy.com/view/wdlGRM
local phasing = {
	object_type = "Edition",
    key = "phasing",
	order = -100,
	weight = 2,
	shader = "phasing",
	in_shop = false,
	extra_cost = 2,
	config = {
		a_chips = 1,
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
		return {
			vars = {
				number_format(self.config.a_chips or 1),
			}
		}
	end,
	calculate = function(self, card, context)

		if RGMC.funcs.edition_in_play(context,card) then
			return {
				chip_mod = lenient_bignum(self.config[choice]),
				colour = G.C.CHIPS,
			}
		end

		if context.joker_main then
            card.config.trigger = true
        end

		if context.after then
            card.config.trigger = nil
        end
	end,
}


local list = {
    iridescent,
    infernal,
    chrome,
    disco,
    --phasing (NOT DONE YET)
}

return {
    name = "Editions",
    init = function() print("Editions!") end,
    items = list
}
