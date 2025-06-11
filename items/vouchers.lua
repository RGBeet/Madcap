local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

local combo_meal = {
    object_type = "Voucher",
	key = "combo_meal",
	atlas = "vouchers",
	pos = get_pos(0,0),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        extra = 1.5,
        immutable = {
			active = true
        }
    },
	redeem = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(self.config.extra)
			}
		}
    end,
    calculate = function (self, card, context)

        if
            context.end_of_round
			and not context.game_over    -- do nothing if you lose
			and context.main_eval
        then
			-- if you get overkill, you get a free tarot card
            local diff = math.abs(to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) -- difference between your chips and blind chips
            local div = to_big(diff) / to_big(G.GAME.blind.chips) -- blind chips / difference

			if RGMC.funcs.greater_than(div, 1.5) then
				local card_type = "Tarot"
				tell('Good job!')
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({ -- make a card
					trigger = 'immediate',
					delay = 0.08,
					func = (function()
						local n_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
						play_sound('timpani')
						n_card:add_to_deck()
						G.consumeables:emplace(n_card)
						G.GAME.consumeable_buffer = 0
						return true
					end
				)}))
			end

		end
    end,
}

local supersize = {
    object_type = "Voucher",
	key = "supersize",
	atlas = "vouchers",
	pos = get_pos(0,1),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        extra = 1.07,
        immutable = {
			active = true
        }
    },
	redeem = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(self.config.extra)
			}
		}
    end,
    calculate = function (self, card, context)

        if
            context.end_of_round
			and not context.game_over    -- do nothing if you lose
			and context.main_eval
        then
			card.ability.immutable.active = false

			-- if you get overkill, you get a free tarot card
			local points = 0
			local chip_goal = G.GAME.blind.chips

			-- does chips^extra, then (chips^extra)^extra, and so forth...
			for i=1,10 do
				chip_goal = chip_goal ^ self.config.extra
				tell('Chip goal is now '..tostring(chip_goal))
				if RGMC.funcs.greater_than(G.GAME.chips, chip_goal, true) then
					points = points + 1
				else
					break -- we done
				end
			end


			tell_stat('Rewards Gained:',points)

			local rewards = {}

			local card_type, numbert = "Tarot", math.min(points,9)

			for i=1,numbert do
				local n_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
				rewards[#rewards+1] = n_card
			end

			for i=1,#rewards do
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({ -- make a card
				trigger = 'after',
				delay = 0.5,
				func = (function()
					play_sound('timpani')
					rewards[i]:add_to_deck()
					rewards[i]:set_edition({ negative = true }, true) -- now spawns as a Negative!
					G.consumeables:emplace(rewards[i])
					G.GAME.consumeable_buffer = 0
					return true
				end)}))
			end
		end
    end,
}

local everyman = {
    object_type = "Voucher",
	key = "everyman",
	atlas = "vouchers",
	pos = get_pos(0,2),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        extra = {
			x_score = 1.1
        }
    },
	redeem = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(self.config.extra.x_score)
			}
		}
    end,
    calculate = function (self, card, context)
        if
            context.after
        then
			local commons = RGMC.funcs.get_common_jokers()
			if commons > 0 then
				return RGMC.funcs.do_x_score(self.config.extra.x_score, commons)
			end
        end
    end,
}

local exceptional = {
    object_type = "Voucher",
	key = "exceptional",
	atlas = "vouchers",
	pos = get_pos(0,3),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        extra = {
			e_score = 1.01
        }
    },
	redeem = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(self.config.extra.e_score)
			}
		}
    end,
    calculate = function (self, card, context)
        if
            context.after
        then
			local commons = RGMC.funcs.get_common_jokers()
			if commons > 0 then
				return RGMC.funcs.do_e_score(self.config.extra.e_score, commons)
            end
        end
    end,
}


local big_bonus = {
    object_type = "Voucher",
	key = "big_bonus",
	atlas = "vouchers",
	pos = get_pos(1,0),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        per_level = 8
    },
	redeem = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(self.config.per_level)
			}
		}
    end,
    calculate = function (self, card, context)
		if
			context.cardarea == G.play
			and context.individual
			and context.other_card
		then
			local has_bonus = false
			for i=1,#RGMC.enhancement_lists.bonus do
				if SMODS.has_enhancement(context.other_card, "m_"..RGMC.enhancement_lists.bonus[i]) then
					has_bonus = true
					break
				end
			end

			if has_bonus then
				local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
				local level = to_number(G.GAME.hands[text].level)
				local chip_return = card.ability.per_level * level

				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize({
						type = "variable",
						key = "a_chips",
						vars = { number_format(chip_return) },
						card = context.other_card
					}),
					colour = G.C.CHIPS,
				})

				G.GAME.chips = G.GAME.chips + chip_return
			end
		end
    end,
}

local massive_mult = {
    object_type = "Voucher",
	key = "massive_mult",
	atlas = "vouchers",
	pos = get_pos(1,1),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        per_level = 1
    },
	redeem = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				number_format(self.config.per_level)
			}
		}
    end,
    calculate = function (self, card, context)
		if
			context.cardarea == G.play
			and context.individual
			and context.other_card
		then
			local has_bonus = false
			for i=1,#RGMC.enhancement_lists.mult do
				if SMODS.has_enhancement(context.other_card, "m_"..RGMC.enhancement_lists.mult[i]) then
					has_bonus = true
					break
				end
			end

			if has_bonus then
				local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
				local level = to_number(G.GAME.hands[text].level)
				local chip_return = card.ability.per_level * level

				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize({
						type = "variable",
						key = "a_mult",
						vars = { number_format(chip_return) },
						card = context.other_card
					}),
					colour = G.C.MULT,
				})

				G.GAME.chips = G.GAME.chips + chip_return
			end
		end
    end,
}

local high_rise = {
    object_type = "Voucher",
	key = "high_rise",
	atlas = "vouchers",
	pos = get_pos(1,2),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        extra = {
			retriggers = 1
        },
        immutable = {
			max_retriggers = 40
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				math.floor(math.max(1, math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers)))
			}
		}
    end,
    calculate = function (self, card, context)

		-- retrigger all held cards
		if
			context.repetition
			and context.cardarea == G.play
			and context.scoring_name == "High Card" -- has a scoring hand, of course
		then
			return {
				repetitions = math.floor(math.max(1, math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers))),
				card = card
			}
		end
    end

}

-- if context.other_card.config.center ~= G.P_CENTERS.c_base then

local high_roller = {
    object_type = "Voucher",
	key = "high_roller",
	atlas = "vouchers",
	pos = get_pos(1,3),
	cost = 8,
	unlocked = true,
	discovered = true,
	available = true,
    config = {
        extra = {
			retriggers = 1
        },
        immutable = {
			max_retriggers = 40
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
			vars = {
				math.max(1, math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers))
			}
		}
    end,
    calculate = function (self, card, context)

		-- retrigger all held cards
		if
			context.repetition
			and context.cardarea == G.hand
			and context.scoring_name == "High Card" -- has a scoring hand, of course
		then
			return {
				repetitions = math.floor(math.max(1, math.min(card.ability.immutable.max_retriggers, card.ability.extra.retriggers))),
				card = card
			}
		end
    end,
}

local list = {
	combo_meal,
	supersize,
	everyman,
	exceptional,
	big_bonus,
	massive_mult,
	high_rise,
	high_roller
}

for i=1, #list do
    if list[i] then list[i].order = i-1 end
end

return {
    name = "Voucher",
    init = function() print("Vouchers!") end,
    items = list
}
