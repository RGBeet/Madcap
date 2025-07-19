local list = {} -- loads a blank list if mod is not added
local mod_id, mod_name = "Partner", "Partner"

if mod_loaded(mod_id) and Partner_API then -- load the items

	local sprites = 'rgmc_partners'

	local function partner_card(name,id)
		return 'j_' .. (id or 'rgmc') .. '_' .. name
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
			extra = {
                related_card = partner_card('chinese_takeout')
			}
		},
		loc_vars = function(self, info_queue, card)
			return { vars = { } }
		end,
		calculate = function(self, card, context)

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
                related_card = partner_card('rhodochrosite'),
                chips = 40,
                mult = 7
			}
		},
		loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.chips, card.ability.mult } }
		end,
		calculate = function(self, card, context)

		end,
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
		calculate = function(self, card, context)

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
