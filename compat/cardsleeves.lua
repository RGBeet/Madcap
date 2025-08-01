if CardSleeves then -- load the items

	SMODS.Atlas{key = "sleeves", path = "sleeves.png", px = 73, py = 95}
	local sprites = 'rgmc_sleeves'

	-- Pale Sleeve
	local pale = {
		key = "pale_sleeve",
		name = "Pale Sleeve",
		config = {
			hand_size = -2,
			hands = 	-1
		},
		unlock_condition = { deck = "Pale Deck", stake = 1 },
		loc_vars = function(self)
			local key, vars
			local cards_converted = (G.GAME and G.GAME.MADCAP) and math.floor(#G.playing_cards/4) or 13

			if self.get_current_deck_key() == "b_rgmc_pale" then
				key = self.key .. "_alt"
				self.config = {
					hand_size = -4,
					hands = -2
				}
				vars = {
					self.config.hand_size,
					self.config.hands,
					cards_converted,
					cards_converted*2,
				}
			else
				key = self.key
				self.config = {
					hand_size = -2,
					hands = -1
				}
				vars = {
					self.config.hand_size,
					self.config.hands,
					cards_converted,
				}
			end
			return {
				key = key,
				vars = vars
			}
		end,
		trigger_effect = function(self, args)
			-- nothing?
		end,
		apply = function(self) -- Start of the run
			tell('Pale Sleeve applied!')

			G.GAME.modifiers.rgmc_deck    = true  -- music activated
			G.GAME.modifiers.rgmc_pale = true
		end,
		calculate = function(self, sleeve, context)
			if
				context.setting_blind        -- start of round
			then
				local seed = pseudoseed('rgmc_pale_deck_'..tostring(G.GAME.round_resets.ante))
				local number = math.floor(#G.playing_cards/4)

				pseudoshuffle(G.playing_cards,seed)
				for i=1,number do
					if not G.playing_cards[i].pale_deck then
						G.playing_cards[i].pale_deck = true
						G.playing_cards[i]:set_rgmc_twinkling(true)
						G.playing_cards[i]:set_edition({ negative = true },true,true)
					end
				end

				-- rest of cards
				for i=number+1,#G.playing_cards do
					if G.playing_cards[i].pale_deck then
						G.playing_cards[i].pale_deck = nil
					end
				end
			end
		end
	}

	-- Hexing Sleeve
	local hexing = {
		key = "hexing_sleeve",
		name = "Hexing Sleeve",
		config = { },
		unlock_condition = { deck = "Hexing Deck", stake = 1 },
		loc_vars = function(self)
			local key, vars
			local cards_converted = (G.GAME and G.GAME.MADCAP) and math.floor(#G.playing_cards/4) or 13

			if self.get_current_deck_key() == "b_rgmc_hexing" then
				key = self.key .. "_alt"
				self.config = {
					starting_ranks = { '2', '3', '4', '5' },
					hands = -2
				}
				vars = {
				}
			else
				key = self.key
				self.config = {
				}
				vars = {
				}
			end
		end,
		trigger_effect = function(self, args)
			-- nothing?
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck    	= true  -- music activated
			G.GAME.modifiers.rgmc_hexing 	= true

			if self.configs.starting_ranks then
				tell('Added extra starting ranks!') -- add 11, and Knight?
			end
		end,
	}

	local function get_deck_dualsuit_locvars(self,deck,light_suit,dark_suit)
		local key
		if self.get_current_deck_key() == "b_"..deck then
			key = self.key .. "_alt"
			self.config = {
				force_suits = {
					light 	= light_suit,
					dark 	= dark_suit
				}
			}
		else
			key = self.key
			self.config = {}
		end
		return { key = key }
	end

	local function get_deck_dualsuit_forcesuit(light_suit,dark_suit)
		local card = context.card
		local is_playing_card = card and (card.ability.set == "Default" or card.ability.set == "Enhanced") and card.config.card_key
		if
			(context.create_card or context.modify_playing_card)
			and card
			and is_playing_card
		then
			local val = (card:has_light_suit() and 1 or 0) + (card:has_dark_suit() and 2 or 0)
			local to_suit = (val == 1 and light_suit)  or (val == 2 and dark_suit) or nil
			if to_suit ~= nil then -- light suit
				local base = SMODS.Suits[to_suit].card_key .. "_" .. SMODS.Ranks[card.base.value].card_key
				local initial = G.GAME.blind == nil or context.create_card
				card:set_base(G.P_CARDS[base], initial)
			end
		end
	end

	-- Sangria Sleeve
	local sangria = {
		key = "sangria_sleeve",
		name = "Sangria Sleeve",
		config = { suits = { 'rgmc_goblets','rgmc_towers' } },
		unlock_condition = { deck = "Sangria Deck", stake = 1 },
		loc_vars = function(self)
			return get_deck_dualsuit_locvars(self,'rgmc_sangria', self.config.suits[1], self.config.suits[2])
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck    	= true  -- music activated
			G.GAME.modifiers.rgmc_sangria   = true
			G.GAME.Exotic = true -- also works with bunco stuff!
		end,
		calculate = function(self, sleeve, context)
			if not sleeve.config.force_suits then return false end
				get_deck_dualsuit_forcesuit(self.config.suits[1], self.config.suits[2])
			return true
		end,
	}

	-- Merlot Sleeve
	local merlot = {
		key = "merlot_sleeve",
		name = "Merlot Sleeve",
		config = { suits = { 'rgmc_goblets','rgmc_towers' } },
		unlock_condition = { deck = "Merlot Deck", stake = 1 },
		loc_vars = function(self)
			return get_deck_dualsuit_locvars(self,'rgmc_merlot', self.config.suits[1], self.config.suits[2])
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck    	= true  -- music activated
			G.GAME.modifiers.rgmc_merlot   	= true
			G.GAME.Exotic = true -- also works with bunco stuff!
		end,
		calculate = function(self, sleeve, context)
			if not sleeve.config.force_suits then return false end
				get_deck_dualsuit_forcesuit(self.config.suits[1], self.config.suits[2])
			return true
		end,
	}

	-- Target Sleeve
	local target = {
		key = "target_sleeve",
		name = "Target Sleeve",
		config = {
			good_max = 0.25,
			bad_min = 1.25
		},
		unlock_condition = { deck = "Target Deck", stake = 1 },
		loc_vars = function(self)
			local key, vars
			local cards_converted = (G.GAME and G.GAME.MADCAP) and math.floor(#G.playing_cards/4) or 13

			if self.get_current_deck_key() == "b_rgmc_target" then
				key = self.key .. "_alt"
				self.config = {
					good_max = 0.25,
					bad_min = 1.25,
					double_dipping = true
				}
				vars = {
					self.config.good_max,
					self.config.bad_min
				}
			else
				key = self.key
				self.config = {
					good_max = 0.25,
					bad_min = 1.25,
				}
				vars = {
					self.config.good_max,
					self.config.bad_min
				}
			end
		end,
		trigger_effect = function(self, args)
			-- nothing?
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck    = true  -- music activated
			G.GAME.modifiers.rgmc_target  = true
		end,
		calculate = function(self, sleeve, context)
			if
				context.end_of_round         -- end of round
				and not context.game_over    -- do nothing if you lose
				and not context.individual
				and not context.repetition
			then
				local diff = math.abs(to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) -- difference between your chips and blind chips
				local div = to_big(diff) / to_big(G.GAME.blind.chips) -- blind chips / difference

				local punishment, prize = false, false
				tell_stat('Diff / Chips',div)

				if div < 0.5 then -- div less than 50%
					-- Receive a prize!
					prize = true

						local boosters = {}

					for k, v in pairs(G.P_CENTERS) do
						if v.set == 'Booster' then table.insert(boosters, k) end
					end

					if div < 0.01 then -- div less than 1% (prize 5)
						Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
						Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
					elseif div < 0.05 then -- div less than 5% (prize 4)
						Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
						Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
					elseif div < 0.10 then -- div less than 10% (prize 3)
						Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk2')
					elseif div < 0.25 then -- div less than 25% (prize 2)
						Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
					else -- prize 1
						Madcap.Funcs.create_target_deck_reward(boosters,'tag_rgmc_target_mk1')
					end
				elseif div > 1 then -- div 100% or greater
					-- Receive a punishment!
					punishment = true

					if div < 1.5 then -- div less than 150% (punishment 1)
						-- apply rental to joker
					elseif div < 2.5 then -- div less than 250% (punishment 2)
						-- apply perishable to joker
					elseif div < 4.0 then -- div less than 400% (punishment 3)
						--  gain antag (right now only the boomerang one)
					elseif div < 6.0 then -- div less than 600% (punishment 4)
						-- lose 1 joker or 1 joker slot
					else -- div 600% or greater (punishment 5)
						-- lose 1 hand size
					end
				end
			end
		end
	}

	local micro_list = {
		"High Card",
		"Pair",
		"Three of a Kind",
		"Two Pair",
		"Four of a Kind",
	}

	-- Micro Sleeve
	local micro = {
		key = "micro_sleeve",
		name = "Micro Sleeve",
		config = {
			hand_size = -2,
			play_limit = -1,
			ante_scaling = 0.66,
			list_index = 5
		},
		unlock_condition = { deck = "Micro Deck", stake = 1 },
		loc_vars = function(self)
			local key, vars
			local cards_converted = (G.GAME and G.GAME.MADCAP) and math.floor(#G.playing_cards/4) or 13

			if self.get_current_deck_key() == "b_rgmc_micro" then
				key = self.key .. "_alt"
				self.config = {
					hand_size = -1,
					play_limit = -1,
					ante_scaling = 0.75,
					list_index = 3
				}
				vars = {
					self.config.hand_size,
					self.config.play_limit,
					self.config.ante_scaling,
				}
			else
				key = self.key
				self.config = {
					hand_size = -2,
					play_limit = -1,
					ante_scaling = 0.66,
					list_index = 5
				}
				vars = {
					self.config.hand_size,
					self.config.play_limit,
					self.config.ante_scaling,
				}
			end
		end,
		trigger_effect = function(self, args)
			-- nothing?
		end,
		apply = function(self) -- Start of the run

			-- play limit go boing boing
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.7,
				func = function()
					SMODS.change_play_limit(self.config.play_limit)
					return true
				end,
			}))

			-- remove hands with 5+ cards (+4 cards with deck/slot)
			for _, v in ipairs(G.handlist) do
				local valid = false
				for i=1,self.config.list_index do
					if v == micro_list[i] then
						valid = true
						break
					end
				end
				if not valid then -- must be doable with 4 hand size
					G.GAME.hands[v].visible = false
				end
			end
		end,
		calculate = function(self, sleeve, context)
		end
	}

	local mayhem = {
		key = "mayhem_sleeve",
		name = "Mayhem Sleeve",
		config = { },
		unlock_condition = { deck = 'Mayhem Deck', stake = 1 },
		trigger_effect = function(self, args)
		end,
		apply = function(self) -- Start of the run
		end,
	}

	local capital = {
		key = "capital_sleeve",
		name = "Capital Sleeve",
		config = { },
		unlock_condition = { deck = 'Capital Deck', stake = 1 },
		trigger_effect = function(self, args)
		end,
		apply = function(self) -- Start of the run
		end,
	}

	local cross = {
		key = "cross_sleeve",
		name = "Cross Sleeve",
		config = { },
		unlock_condition = { deck = 'Cross Deck', stake = 1 },
		trigger_effect = function(self, args)
		end,
		apply = function(self) -- Start of the run
		end,
	}

	local jumble = {
		key = "jumble_sleeve",
		name = "Jumble Sleeve",
		config = { },
		unlock_condition = { deck = 'Jumble Deck', stake = 1 },
		trigger_effect = function(self, args)
		end,
		apply = function(self) -- Start of the run
		end,
	}

	local sleeves = {}
	Madcap.Funcs.LoadSleeves({
		pale,
		hexing,
		sangria,
		target,
		micro,
		mayhem,
		capital,
		cross,
		merlot,
		jumble
	}, sleeves, 'rgmc_sleeves') -- load into sleeves cause 

	MadLib.loop_func(sleeves, function(w,i)
		w.unlocked = true
		CardSleeves.Sleeve(w)
	end)
end

return {
    name = "CardSleeves Compatability",
    init = function() -- does the non item stuff ig?
		if not CardSleeves then
			tell("CardSleeves is not loaded - skipping!")
			return false
		end

		return true
    end,
    items = list
}
