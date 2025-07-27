local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "Partner", "Partner"

if mod_loaded(mod_id) and Partner_API then -- load the items

	local sprites = 'rgmc_partners'

	local function partner_card(name,id)
		return 'j_' .. (id or 'rgmc') .. '_' .. name
	end

	function Madcap.Funcs.get_partner_key()
		return G.GAME.selected_partner_card and G.GAME.selected_partner_card.key
	end

	function Madcap.Funcs.get_partner_link_level()
		return G.GAME.selected_partner_card and G.GAME.selected_partner_card:get_link_level()
	end

	-- create the joker atlas
    SMODS.Atlas{
        key = "partners",
        px = 46,
        py = 58,
        path = "partners.png"
    }

	-- Snacky Shark: provides a random stat boost every Blind,
	-- similar to Chinese Takeout.
	-- Not 100% random - tends to skew towards Chips if Mult is higher,
	-- and vice versa.
	
	-- Upon obtaining Chinese Takeout, unlocks stronger effects (?)
	local snacky = {
		key = "snacky",
		config = {
			immutable = {
				mode = 1    -- starts off at just fried rice
			},
			extra = {
				effects = {
					10,     -- +chips
					2,      -- +mult
					30,     -- +chips
					5,      -- +mult
					60,    	-- +chips
					1.25,   -- Xmult
					1.75,   -- Xmult
					1.75    -- Xscore
				},
                related_card = partner_card('chinese_takeout')
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
			if context.setting_blind then
				local new_food = math.random(1, 8)
				card.ability.immutable.mode = new_food
				if card.ability.immutable.mode > 0 and card.ability.immutable.mode <= 8 then
					return { message = localize("rgmc_chinese_line" .. card.ability.immutable.mode) }
				end
			end

			-- Scoring?
			if (context.cardarea == G.jokers and context.joker_main) then
				tell('Value: '..number_format(card.ability.extra.effects[card.ability.immutable.mode]))
				local _mode = card.ability.immutable.mode
				local _scorekey = _mode < 6 
					and (_mode % 2 == 1 and MadLib.ScoreKeys.AddChips or MadLib.ScoreKeys.AddMult)
					or (_mode < 8 and MadLib.ScoreKeys.MultiMult)
					or MadLib.ScoreKeys.MultiScore
				local _amt = card.ability.extra.effects[card.ability.immutable.mode]

				return MadLib.get_simple_score_data(_scorekey, card, _mode)
			end
		end,
	}

	-- Manganese: first scored Diamond gives +7 Mult OR +40 Chips if
	-- succeding Clubs / Spades, similar to Rhodochrosite.

	-- Upon obtaining Rhodochrosite, Diamonds also have a 1 in 2 chance
	-- to give X2 Mult.
	local manganese = {
		key = "manganese",
		config = {
			extra = {
                related_card 	= partner_card('rhodochrosite'),
                chips 	= 20,
                mult	= 4,
				suits 	= { "Diamonds", "Spades", "Clubs" }
			}
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
			if context.cardarea == G.play and context.other_card then
				if context.other_card:is_suit(card.ability.extra.suits[1]) then
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
		end
	}

	-- Traveller: Upon using a Planet card, levels up the last
	-- played poker hand by 1/2 level (1 with Rocket Keychain).
	local traveller = {
		key = "traveller",
		config = {
			extra = {
				bonus_levels = 0.5,
                related_card = partner_card('rocket_keychain')
			}
		},
		loc_vars = function(self, info_queue, card)
			return {
				vars = {
					card.ability.bonus_levels,
					(G.GAME and G.GAME.previous_poker_hand) or "High Card" -- get previous poker hand
				}
			}
		end,
	}

	-- Paschal: Upon selecting blind, applys random enhancement
	-- to card in hand.
	-- With Easter Egg, also adds edition to selected card.
	local paschal = {
		key = "paschal",
		config = {
			extra = {
                related_card = partner_card('easter_egg')
			}
		},
		loc_vars = function(self, info_queue, card)
			return { vars = { } }
		end,
		calculate = function(self, card, context)
        	if context.setting_blind then
				MadLib.simple_event(function()
					-- priotized base cards (no edition nor enhancement), then enhanced only
					MadLib.shuffle_sort_list(G.hand.cards, nil, function(a,b)
						local _a = (SMODS.has_enhancement(a) and -2 or 0) + (a.edition and -1 or 0)
						local _b = (SMODS.has_enhancement(b) and -2 or 0) + (a.edition and -1 or 0)
						return _a < _b
					end)
				end, 0.5, 'after')
			end
		end,
	}

	-- Squeezy: After scoring, gives X0.25 Mult for every
	-- +50 Chips scored (past base chips)
	-- With Squeezy Cheeze, doubles this to X0.5 Mult
	local squeezy = {
		key = "squeezy",
		config = {
			extra = {
                x_mult 	= 0.25,
                a_chips = 50
			},
			immutable = {
				before_score = 0
			}
		},
		loc_vars = function(self, info_queue, card)
			return {
				vars = {
					card.ability.x_mult,
					card.ability.a_chips
				}
			}
		end,
		calculate = function(self, card, context)
			-- calculate before score
			if context.before then
				card.ability.immutable.before_score = 0
			end


			-- final step of scoring
		end,
	}

	-- Foolish: 
	local foolish = {
		key = "foolish",
		config = {
			extra = {
                related_card = partner_card('catch_the_clown')
			}
		},
		loc_vars = function(self, info_queue, card)
			return { vars = { } }
		end,
		calculate = function(self, card, context)

		end,
	}

	local aces = {
		key = "aces",
		config = {
			extra = {
                related_card = partner_card('legend_rio'),
                rank = "2"
			}
		},
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.rank } }
		end,
		calculate = function(self, card, context)

		end,
	}


	local partners = {
		snacky,
		manganese,
		traveller,
		paschal,
		squeezy,
		foolish,
		aces
	}
	for i=1, #partners do
		local n = i-1
		partners[i].pos 		= partners[i].pos or {x = n%5, y = math.floor(n/5)}
		partners[i].unlocked 	= true
		partners[i].discovered 	= true
		partners[i].atlas = sprites
		Partner_API.Partner(partners[i])
	end
end


return {
    name = mod_name .. " Compatability",
    init = function() -- does the non item stuff ig?
		if not mod_loaded(mod_id) then
			tell(mod_name .. "is not loaded - skipping!")
			return false
		end
		return true
    end,
    items = list
}
