local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

local girder = {
	set = "Tarot",
	key = "girder",
	pos = get_pos(0,0),
	config = {
		max_highlighted = 2,
		mod_conv = 'm_rgmc_ferrous'
	},
	cost = 4,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[mod_conv]
		return MadLib.collect_vars(card.ability.max_highlighted)
	end,
    can_use = function(self, card)
      return MadLib.can_use_transform_tarot(card)
    end,
}

local filament = {
	set = "Tarot",
	key = "filament",
	pos = get_pos(0,1),
	config = { max_highlighted = 1, mod_conv = 'm_rgmc_wolfram' },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[mod_conv]
		return MadLib.collect_vars(card.ability.max_highlighted)
	end,
    can_use = function(self, card)
      return MadLib.can_use_transform_tarot(card)
    end,
}

local polish = {
	set = "Tarot",
	key = "polish",
	pos = get_pos(0,2),
	config = {
		max_highlighted = 1,
		mod_conv = 'm_rgmc_lustrous'
	},
	cost = 4,
	atlas = "consumables",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[mod_conv]
		return MadLib.collect_vars(card.ability.max_highlighted)
	end,
    can_use = function(self, card)
      return MadLib.can_use_transform_tarot(card)
    end,
}

local providence = {
	set = "Tarot",
	key = "providence",
	pos = get_pos(0,3),
	config = {
		extra = {
			odds 		= 4,
			max_cards	= 2
		},
	},
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(MadLib.base_prob(card), card.ability.odds, card.ability.max_highlighted)
	end,
    can_use = function(self, card)
		return #G.hand.cards > 0 -- is there a hand of cards available?
    end,
	cost = 4,
	use = function(self, card, area, copier)

		MadLib.loop_func(G.jokers.cards, function(v, i)
			Madcap.Funcs.mayhemize(v)
		end)

	end,
}

local oxidize = {
	set = "Spectral",
	key = "oxidize",
	pos = get_pos(0,5),
	config = {
		extra = "rgmc_patina",
		max_highlighted = 1
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra]
		return MadLib.collect_vars(card.ability.max_highlighted)
	end,
	cost = 4,
	use = function(self, card, area, copier) --Good enough
		MadLib.flip_cards(G.hand.highlighted, function(c)
			MadLib.simple_event(function()
				c:set_seal(card.ability.extra)
			end)
		end)
	end,
}

local reduct = {
	set = "Spectral",
	key = "reduct",
	pos = get_pos(0,4),
	config = {
		extra = "rgmc_bronze",
		max_highlighted = 2
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra]
		return MadLib.collect_vars(card.ability.max_highlighted)
	end,
	cost = 4,
	use = function(self, card, area, copier) --Good enough
		MadLib.flip_cards(G.hand.highlighted, function(c)
			MadLib.simple_event(function()
				c:set_seal(card.ability.extra)
			end)
		end)
	end,
}

local madcrap_list = { "2", "3", "4", "5" }

local madcrap = {
	object_type = "Consumable",
	set = "Spectral",
	name = "rgmc_madcrap",
	key = "madcrap",
	pos = get_pos(0,6),
	config = {
		extra = { odds = 4 }
	},
	cost = 4,
	atlas = "consumables",
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end,
    use = function(self, card, area, copier)

		MadLib.flip_cards(MadLib.get_cards_from_shuffled_deck(G.hand.cards, #G.hand.cards, function(c)
			return MadLib.calculate_roll({
                seed = 'rgmc_madcrap',
                denom = self.config.extra.odds
            })
		end), function(c)
			MadLib.simple_event(function ()
				SMODS.change_base(c, SMODS.Suits[c.base.suit].value, pseudorandom_element(list, pseudoseed("rgmc_madcrap"))) -- change da rank
			end)
		end)

    end,
}

local chalice = {
	set = "Spectral",
	key = "chalice",
	pos = get_pos(0,7),
	config = {
		suit_conv = 'rgmc_goblets'
	},
	cost = 4,
	can_use = function(self, card)
		return #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)
		Madcap.Funcs.set_special_suits(true)

		MadLib.flip_cards(MadLib.get_cards_from_shuffled_deck(G.hand.cards, #G.hand.cards, function(c)
			return MadLib.has_suit_in_list(c,MadLib.SuitTypes.Light) -- has light cards
				and c.base.suit ~= card.ability.suit_conv
		end), function(c)
			MadLib.simple_event(function ()
				SMODS.change_base(c, SMODS.Suits[card.ability.suit_conv].value, pseudorandom_element(list, pseudoseed("rgmc_chalice"))) -- change da rank
			end)
		end)
	end
}

local armoire = {
	set = "Spectral",
	key = "armoire",
	pos = get_pos(0,8),
	config = {
		suit_conv = 'rgmc_towers'
	},
	cost = 4,
	can_use = function(self, card)
		return #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)
		Madcap.Funcs.set_special_suits(true)

		MadLib.flip_cards(MadLib.get_cards_from_shuffled_deck(G.hand.cards, #G.hand.cards, function(c)
			return MadLib.has_suit_in_list(c,MadLib.SuitTypes.Dark) -- has light cards
				and c.base.suit ~= card.ability.suit_conv
		end), function(c)
			MadLib.simple_event(function ()
				SMODS.change_base(c, SMODS.Suits[card.ability.suit_conv].value, pseudorandom_element(list, pseudoseed("rgmc_armoire"))) -- change da rank
			end)
		end)
	end,
}

-- adds two temporary hands (max: 8)
local bluebell = {
	set = "Spectral",
	key = "bluebell",
	pos = get_pos(0,9),
	config = { extra = { add = 1 } },
	cost = 4,
	can_use = function(self, card)
		return G.GAME.MADCAP.temporary_hands < 8
	end,
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.add)
	end,
	use = function(self, card, area, copier)
		local words = localize("rgmc_temp_hand_plus")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = Madcap.Funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
		G.GAME.MADCAP.temporary_hands = G.GAME.MADCAP.temporary_hands + card.ability.extra.add
	end,
}

-- adds two temporary discards (max: 8)
--
local amaryllis = {
	set = "Spectral",
	key = "amaryllis",
	pos = get_pos(1,0),
	config = { extra = { add = 1 } },
	cost = 4,
	can_use = function(self, card)
		return G.GAME.MADCAP.temporary_discards < 8
	end,
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra.add)
	end,
	use = function(self, card, area, copier)
		local words = localize("rgmc_temp_discard_plus")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = Madcap.Funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
		G.GAME.MADCAP.temporary_discards = G.GAME.MADCAP.temporary_discards + card.ability.extra.add
	end,
}

--[[
	Cosma Tarots
]]

SMODS.ConsumableType({
    key = "CosmaTarot",
    primary_colour = HEX("69FFAA"),
    secondary_colour = HEX("1F8268"),
    collection_rows = { 5, 6 },
    shop_rate = 0.5,
    loc_txt = {},
    default = "c_rgmc_orbs",
    can_stack = true,
    can_divide = true,
})

function Madcap.Funcs.use_cosma(self, card, area, copier, num_cards, check, func)
	if not G.hand then return false end
	tell('Cards be like')
    local used_tarot = copier or card
    G.hand:unhighlight_all()

	-- no suitless
	local valid = MadLib.shuffle_sort_list(G.hand.cards, num_cards, check)
	tell_stat('Valid Cards',valid)

	-- up down
	Madcap.loop_func(G.hand.cards,function(v, i)
		MadLib.simple_event(function()
			v:highlight(true)
			play_sound('card3', math.random()*0.2 + 0.9, 0.35)
			return true
		end, 0.08, 'after')

		MadLib.simple_event(function()
			v:highlight(false)
			return true
		end, 0.08, 'after')
	end)

	-- up
	Madcap.loop_func(G.hand.cards,function(v, i)
		MadLib.simple_event(function()
			play_sound('card3', math.random()*0.2 + 0.9, 0.35)
			v:highlight(true)
        	v:flip()
			return true
		end, 0.1, 'after')
	end)

	-- change
	Madcap.loop_func(valid,function(v, i)
		MadLib.simple_event(function()
			func(v,card,i)
			return true
		end, 0.05, 'after')
	end)

	-- down
	Madcap.loop_func(G.hand.cards,function(v, i)
		MadLib.simple_event(function()
			v:highlight(false)
        	v:flip()
			return true
		end, 0.1, 'after')
	end)
    
	if used_tarot then
	used_tarot:juice_up(0.3, 0.5)
	end
	return true
end

local cosma_can_use = function(self, card)
	return G.hand and type(G.hand.cards) == 'table' and #G.hand.cards > 0
end



-- [Cosma] DEMISE: Gives a random Cosma Tarot (besides Demise). 1 in 4 chance chance to copy last cosma tarot.
-- Parallels 0 - The Fool.
local demise = {
    key 	= "demise",
	pos 	= get_pos(0,0),
	config	= {},
	cost 	= 6,
	can_use = function(self, card)
		return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables)
	end,
	use 	= function(self, card, area, copier)
      	local used_tarot = copier or card
		local card = nil
		--select a random cosma tarot from 1-21. Has a 1 in 200 chance to give Sleeping Ships instead.
		if 
			(G.GAME.last_cosma_tarot and G.GAME.last_cosma_tarot ~= 'c_rgmc_demise')
			and MadLib.calculate_roll({ denom = card, seed = 'rgmc_demise' }) 
		then -- copy the thing
            card = create_card('CosmaTarot', G.consumeables, nil, nil, nil, nil, G.GAME.last_cosma_tarot, 'fool')
		else
            card = MadLib.get_random_card("CosmaTarot")
		end

		if card then
            play_sound('timpani')
            card:add_to_deck()
            G.consumeables:emplace(card)
		end
        used_tarot:juice_up(0.3, 0.5)
	end
}

-- [Cosma] THE CROW: Select two cards to convert to
-- [Daggers]. If already [Daggers], give them [+3 bonus mult].
-- Parallels I - The Magician (Lucky Card).
local crow = {
    key 	= "crow",
	pos 	= get_pos(0,1),
	config	= { select = 2, extra = { mult_mod = 2, suit = 'rgmc_daggers'} },
	cost 	= 5,
	can_use = cosma_can_use,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
			return true -- must have suit
		end, function(v, card)
			local no_bonus = v.base.suit ~= card.ability.extra.suit
			
			if no_bonus then -- switch into suit
				MadLib.simple_event(function()
					assert(SMODS.change_base(v, card.ability.extra.suit, nil))
					return true
				end, 0.2, 'after')
			else -- give permanent bonus!
				MadLib.simple_event(function()
					v.ability.perma_mult = (v.ability.perma_mult or 0) + card.ability.extra.mult_mod
					return true
				end, 0.2, 'after')
			end
			
			-- juice
			MadLib.simple_event(function()
				v:juice_up()
				return true
			end, 0.08, 'immediate')
		end)
}

-- [Cosma] THE SWAN: Select two cards to convert to
-- [Goblets]. If already [Goblets], give them [+X0.1 bonus mult].
-- Parallels II - The High Priestess (2 Planets).
local swan = {
    key 	= "swan",
	pos 	= get_pos(0,2),
	config	= { select = 2, extra = { xmult_mod = 0.04, suit = 'rgmc_goblets'} },
	cost 	= 5,
	can_use = cosma_can_use,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
			return true -- must have suit
		end, function(v, card)
			local no_bonus = v.base.suit ~= card.ability.extra.suit
			
			if no_bonus then -- switch into suit
				MadLib.simple_event(function()
					assert(SMODS.change_base(v, card.ability.extra.suit, nil))
					return true
				end, 0.2, 'after')
			else -- give permanent bonus!
				MadLib.simple_event(function()
					v.ability.perma_x_mult = (v.ability.perma_h_x_mult or 1) + card.ability.extra.x_mult_mod
					return true
				end, 0.2, 'after')
			end
			
			-- juice
			MadLib.simple_event(function()
				v:juice_up()
				return true
			end, 0.08, 'immediate')
		end)
}

-- [Cosma] THE PEACOCK: Select two cards to convert to
-- [Blooms]. If already [Blooms], give them a [+$1 bonus money].
-- Parallels III - The Empress (Mult).
local peacock = {
    key 	= "peacock",
	pos 	= get_pos(0,3),
	config	= { select = 2, extra = { money_mod = 1, suit = 'rgmc_blooms'} },
	cost 	= 5,
	can_use = cosma_can_use,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
			return true -- must have suit
		end, function(v, card)
			local no_bonus = v.base.suit ~= card.ability.extra.suit
			
			if no_bonus then -- switch into suit
				MadLib.simple_event(function()
					assert(SMODS.change_base(v, card.ability.extra.suit, nil))
					return true
				end, 0.2, 'after')
			else -- give permanent bonus!
				MadLib.simple_event(function()
					v.ability.perma_h_money = (v.ability.perma_h_money or 0) + card.ability.extra.money_mod
					return true
				end, 0.2, 'after')
			end
			
			-- juice
			MadLib.simple_event(function()
				v:juice_up()
				return true
			end, 0.08, 'immediate')
		end)
}

-- [Cosma] THE PELICAN: Select two cards to convert to
-- [Towers]. If already [Towers], give them [+5 bonus chips].
-- Parallels IV - The Emperor (2 Tarots).
local pelican = {
    key 	= "pelican",
	pos 	= get_pos(0,4),
	config	= { select = 2, extra = { chip_mod = 10, suit = 'rgmc_towers'} },
	cost 	= 5,
	can_use = cosma_can_use,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
			return true -- must have suit
		end, function(v, card)
			local no_bonus = v.base.suit ~= card.ability.extra.suit
			
			if no_bonus then -- switch into suit
				MadLib.simple_event(function()
					assert(SMODS.change_base(v, card.ability.extra.suit, nil))
					return true
				end, 0.2, 'after')
			else -- give permanent bonus!
				MadLib.simple_event(function()
					v.ability.perma_chips = (v.ability.perma_chips or 0) + card.ability.extra.chip_mod
					return true
				end, 0.2, 'after')
			end
			
			-- juice
			MadLib.simple_event(function()
				v:juice_up()
				return true
			end, 0.08, 'immediate')
		end)
}

-- [Cosma] THE PHOENIX: Halves chip value, but adds 1/5 of
-- total chip value as bonus mult.
-- Parallels V - The Hierophant (Bonus).
local phoenix = {
    key 	= "phoenix",
	pos 	= get_pos(0,5),
	config	= { extra = 0.2 },
	cost 	= 7,
	can_use = function(self, card)
		return G.hand
	end,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
			return true -- must have suit
		end, function(v, card)
			MadLib.simple_event(function()
				local _value = (v.ability.chips) or 0
				v.ability.chips 		= _value  / 2
				v.ability.perma_mult 	= (v.ability.perma_mult or 0) + _value * (card.ability.extra.fraction or 0.2)
				return true
			end, 0.2, 'after')
			
			-- juice
			MadLib.simple_event(function()
				v:juice_up()
				return true
			end, 0.08, 'immediate')
		end)
}

-- [Cosma] THE SOULMATES: Select two cards, change each
-- suit to a random suit played this Blind.
-- Parallels VI - The Lovers (Wild).
local soulmates = {
    key 	= "soulmates",
	pos 	= get_pos(0,6),
	config	= { self.config.select = 3 },
	cost 	= 7,
	can_use = function(self, card)
		return G.GAME.blind_info and G.GAME.blind_info.suits_played true
	end,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
			return true -- must have suit
		end, function(v, card)
			-- try not to have suits swap into the SAME SUIT
			local _suit = pseudorandom_element(G.GAME.blind_info.suits_played, psuedoseed('rgmc_soulmates')) -- pick a suit
			MadLib.simple_event(function()
				assert(SMODS.change_base(v, _suit, nil))
				return true
			end, 0.2, 'after')
		end)
	end
}

-- [Cosma] THE SPIRIT PLANE: Select two cards, change each
-- enhancement to a random enhancement in deck.
-- Parallels VII - The Chariot (Steel).
local spirit_plane = {
    key 	= "spirit_plane",
	pos 	= get_pos(0,7),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return #MadLib.get_enhanced_cards(G.playing_cards) > 1
	end,
	use 	= function(self, card, area, copier)
		-- targets cards with no enhancement
		local sorted_hand = MadLib.shuffle_sort_list(G.hand.cards, self.config.select or 2, nil, function(a,b)
			return (a:has_enhancement() and 0 or 1) > (b:has_enhancement() and 0 or 1)
		end)

		Madcap.Funcs.use_cosma(self, card, area, copier, 3, function(v)
			return true -- must have suit
		end, function(v, card)
			local _enhancement = pseudorandom_element(_enhancement, psuedoseed('rgmc_spirit_plane')) -- pick a suit
			
			MadLib.simple_event(function()
				v:set_ability(G.P_CENTERS[_enhancement.center.key])
				return true
			end, 0.2, 'after')
		end)
	end
}

-- [Cosma] THE ORBS: Select two cards - 3 in 4 chance to
-- add random enhancement or change specific enhancement
-- to Madcap equivalent, destroy otherwise
-- Parallels VIII - Justice (Glass).
local orbs = {
    key 	= "orbs",
	pos 	= get_pos(0,8),
	config	= { extra = { select = 2, odds = 4 } },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)
		local selection = MadLib.shuffle_sort_list(G.hand.cards, self.config.select or 2, nil, function(a,b)
			return math.random() > 0.5 -- coin flip
		end)
	
		MadLib.loop_func(selection, function(v,i)
		if not MadLib.calculate_roll({ -- 3 in 4
            seed = 'rgmc_madcrap',
            denom = self.config.extra.odds
        }) then -- add random enhancement
			
		else -- fucking blow up
		
		end)
	end
}

-- [Cosma] THE COSMIC TREE: Gain $2/$1 for every
-- unique suit / rank in hand.
-- Parallels IX - The Hermit (X2 Money).
local cosmic_tree = {
    key 	= "cosmic_tree",
	pos 	= get_pos(0,9),
	config	= { extra = { money = 2 } },
	cost 	= 7,
	can_use = function(self, card)
		return true -- always time for money
	end,
	use 	= function(self, card, area, copier)
		local ranks, suits = #get_ranks_from_cards(G.playing_cards), #get_suits_from_cards(G.playing_cards)
		ease_dollars(ranks + suits * (self.config.extra.money or 2))
	end
}

function MadLib.compare_and_pick_unique(main_list, compare_list, seed_name)
	return pseudorandom_element(MadLib.list_matches_all(main_list, function(v1)
		return not MadLib.list_matches_one(compare_list, function(v2)
			v2 ~= v1
		end), 
	end), psuedoseed('rgmc_life_map'))
end

-- [Cosma] THE LIFE MAP: 1 in 4 chance to reroll a Joker
-- into one of a higher rarity.
-- Parallels X - The Wheel of Fortune ("1 in 4").
local life_map = {
    key 	= "life_map",
	pos 	= get_pos(1,0),
	config	= { select = 1, extra = { odds = 2 } },
	cost 	= 7,
	can_use = function(self, card)
		return G.jokers and #G.jokers.cards > 0
	end,
	use 	= function(self, card, area, copier)
		local changed = {}
		MadLib.number_func(nil, self.config.select, function(i)
			if MadLib.calculate_roll({ -- 3 in 4
				seed = 'rgmc_life_map',
				denom = self.config.extra.odds
			}) then -- add random enhancement
				local pick = MadLib.compare_and_pick_unique()
				-- get rarity
			end
		end)
	end
}

-- [Cosma] KARMA - choose two cards, reduce higher rank by 2
-- and increase lower rank by 2
-- Parallels XI - Strength (+1 rank).
local karma = {
    key 	= "karma",
	pos 	= get_pos(1,1),
	config	= { select = 2, extra = 2 },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)
		-- targets cards with no enhancement
		local to_destroy = MadLib.shuffle_sort_list(G.hand.cards, self.config.select or 2, nil, function(a,b)
			return math.random() < 0.5
		end)

		Madcap.Funcs.use_cosma(self, card, area, copier, 3, function(v)
			return true -- must have suit
		end, function(v, card)
			local _enhancement = pseudorandom_element(_enhancement, psuedoseed('rgmc_spirit_plane')) -- pick a suit
			
			MadLib.simple_event(function()
				v:set_ability(G.P_CENTERS[_enhancement.center.key])
				return true
			end, 0.2, 'after')
		end)
	end
}

-- [Cosma] SACRIFICE - Gain +X Mayhem,
-- but destroy a random Joker
-- Parallels XII - The Hanged Man (-2 cards).
local sacrifice = {
    key 	= "sacrifice",
	pos 	= get_pos(1,2),
	config	= { select = 1, extra = 1.0 },
	cost 	= 7,
	can_use = function(self, card)
		return true (G.jokers and #G.jokers.cards > 1) and (Madcap.Funcs.get_mayhem() + self.config.extra) <= Madcap.Funcs.get_max_mayhem()
	end,
	use = function(self, card, area, copier)
		Madcap.Funcs.ease_mayhem(self.config.extra or 1, true)

		local selection = MadLib.shuffle_sort_list(G.jokers.cards, self.config.select or 2, nil, function(a,b)
			return math.random() < 0.5
		end)
	
		MadLib.loop_func(selection, function(v,i)
			-- destroy v
		end)
	end
}

-- [Cosma] PAST LIVES - Creates a previously destroyed Joker
-- at the cost of 1 Mayhem.
-- Parallels XIII - Death (Copy card).
local past_lives = {
    key 	= "past_lives",
	pos 	= get_pos(1,3),
	config	= { extra = 1 },
	cost 	= 7,
	can_use = function(self, card)
		return (G.GAME.dead_jokers and #G.GAME.dead_jokers or 0) > 0
			and (Madcap.Funcs.get_mayhem() - self.config.extra) >= 0
	end,
	use = function(self, card, area, copier)
		local _key = pseudorandom_element(G.GAME.dead_jokers, psuedoseed('rgmc_past_lives'))
		Madcap.Funcs.ease_mayhem(self.config.extra and -self.config.extra or -1, true)
		MadLib.simple_event(function()
			local _joker = MadLib.create_joker(_key)
			return true
		end, 0.2, 'after')
	end
}

-- [Cosma] THE MAZE: Select two cards, the rest have
-- their rank and suit shuffled. Gain $2 for each
-- changed card
-- Parallels XIV - Temperance (total Jokers).
local maze = {
    key 	= "maze",
	pos 	= get_pos(1,4),
	config	= { select = 2, extra = 2 },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local shuffled_deck = MadLib.shuffle_sort_list(G.hand.cards, nil, nil, function(a,b)
			return math.random() < 0.5
		end)

		local shuffle_suits, shuffle_ranks = {}, {}
		local save_n = math.min(self.config.select, #G.hand.cards)
		for i = save_n+1, #G.hand.cards do -- for the first 
			table.insert(shuffle_suits, shuffled_deck[i].base.suit)
			table.insert(shuffle_ranks, shuffled_deck[i].base.value)
		end

		-- shuffle everything
		pseudoshuffle(shuffle_ranks, psuedoseed('rgmc_maze'))
		pseudoshuffle(shuffle_suits, psuedoseed('rgmc_maze'))

		local change_cards = {}
		
		for i = save_n+1, #G.hand.cards do -- for the first
			table.insert(change_cards, G.hand.cards[i - save_n])
		end

		Madcap.Funcs.use_cosma(self, card, area, copier, #change_cards, function(v,card,i)
			return (v.base.value ~= shuffle_ranks[i]) or (v.base.suit ~= shuffle_suits[i])
		end, function(v)
			assert(SMODS.change_base(v, shuffle_suits[i], shuffle_ranks[i]))
			v:juice_up(0.3, 0.5)
		end)
	end
}

-- [Cosma] THE VESSEL: Select two cards, multiply their values by X1.25.
-- Parallels XV - The Devil (Gold).
local vessel = {
    key 	= "vessel",
	pos 	= get_pos(1,5),
	config	= { select = 2, extra = 1.25},
	cost 	= 7,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 1
	end,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, nil, function(v)
		Madcap.Funcs.mayhemize(_card, { 
				force_values 	= true,
				min_mult 		= self.config.extra or 1.25,
				max_mult 		= self.config.extra or 1.25
			}, false)
			end
		)
	end
}

-- [Cosma] THE SHORE: Select one card, apply
-- Shielded sticker.
-- Parallels XVI - The Tower (Stone).
local shore = {
    key 	= "shore",
	pos 	= get_pos(1,6),
	config	= { select = 1 },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, nil, function(v)
		Madcap.Funcs.mayhemize(_card, { 
				force_values 	= true,
				min_mult 		= self.config.extra or 1.25,
				max_mult 		= self.config.extra or 1.25
			}, false)
			end
		)
	end
}

-- [Cosma] THE VEIL: Inverts 3 random light suit cards into their dark counterpart.
-- Parallels XVII - The Star (Diamonds).
local veil = {
    key 	= "veil",
	pos 	= get_pos(1,7),
	config	= { select = 3 },
	cost 	= 7,
	can_use = function(self, card)
		return G.hand and MadLib.loop_func(G.hand.cards, function(v)
			return v:has_light_suit()
		end) >= (self.config.select or 3)
	end,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 3, function(v)
		return v:has_light_suit()
	end, function(v)
		local _suit = MadLib.suit_get_counterpart_lightdark(v.base.suit)
		MadLib.simple_event(function() assert(SMODS.change_base(v, _suit, nil)) end)
	end)
}

-- [Cosma] THE BRIDGE: Inverts 3 random dark suit cards into their light counterpart.
-- Parallels XVIII - The Moon (Clubs).
local bridge = {
    key 	= "bridge",
	pos 	= get_pos(1,8),
	config	= { select = 3 },
	cost 	= 7,
	can_use = function(self, card)
		return G.hand and MadLib.loop_func(G.hand.cards, function(v)
			return v:has_dark_suit()
		end) >= (self.config.select or 3)
	end,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 3, function(v)
		return v:has_dark_suit()
	end, function(v)
		local _suit = MadLib.suit_get_counterpart_lightdark(v.base.suit)
		MadLib.simple_event(function() assert(SMODS.change_base(v, _suit, nil)) end)
	end)
}

local get_joker_shop_width(jokers)
	return jokers * 1.02 * G.CARD_W * (jokers > 4 and 4 / jokers or 1)
end

local buy_shop_ref = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
	local r 	= buy_shop_ref(e)
    local c1 	= e.config.ref_table

	if r and (G.GAME.rgmc_pathway and G.GAME.rgmc_pathway > 0) then
		SMODS.change_booster_limit(-1)
		SMODS.change_voucher_limit(-1)
		G.GAME.shop.joker_max = G.GAME.shop.joker_max + (self.config.extra or 1)
		G.GAME.rgmc_pathway = G.GAME.rgmc_pathway - 1
		G.shop_jokers.T.w = get_joker_shop_width()
		G.shop_jokers.T.h = 1.05*G.CARD_H
		G.shop:recalculate()
	end
	
	return r
end

-- [Cosma] PATHWAYS: For the next shop, give +1 Booster, +1 Shop Item, and +1 Voucher
-- (Choose one)
-- Parallels XIX - The Sun (Hearts).
local pathways = {
    key 	= "pathways",
	pos 	= get_pos(1,9),
	config	= { extra = 1},
	cost 	= 7,
	can_use = function(self, card)
		return not G.shop -- not in shop
	end,
	use 	= function(self, card, area, copier)
    local used_tarot = copier or card
		MadLib.simple_event(function()
			play_sound("timpani")
			card:juice_up(0.3, 0.5)
            G.GAME.rgmc_pathway = (G.GAME.rgmc_pathway or 0) + 1
			SMODS.change_booster_limit(self.config.extra or 1)
			SMODS.change_voucher_limit(self.config.extra or 1)
			G.GAME.shop.joker_max = G.GAME.shop.joker_max + (self.config.extra or 1)
            return true
			-- in case this triggers in shop?
			if G.shop then
				G.shop_jokers.T.w = get_joker_shop_width()
				G.shop_jokers.T.h = 1.05*G.CARD_H
				G.shop:recalculate()
			end
		end, 0.3, 'after')
	end
}

-- Gets a random consumable
Madcap.Funcs.get_random_consumable = function()
	local selected = ""
    local passed = false
    local tries = 50
    
	while tries > 0 and not passed do -- modified from a cryptid function, could easily be absolute garbage
        tries = tries - 1
        passed = false
        selected = G.P_CENTERS[pseudorandom_element(G.P_CENTER_POOLS.Consumeables, pseudoseed("raffle_cons")).key]
        
		if not (selected["hidden"] or (G.GAME and G.GAME["hidden"] and G.GAME["hidden"][selected]) or false) then
            passed = true
        end
		if passed or tries <= 0 then selected = tries <=0 and 'c_strength' or selected end
	return selected
end

local function check_add(area,slots)
	return (G[area] and (#G[area].jokers + (slots or 1)) < G[area].config.card_limit)
end

-- [Cosma] THE UNKNOWN: Creates a random Negative consumable, Joker, or card. Mayhemize its values.
-- 1 in 3 chance to retrigger
-- Parallels XX - Judgement (+Joker).
local unknown = {
    key 	= "unknown",
	pos 	= get_pos(2,0),
	config	= { extra = { odds = 4, min = 0.5, max = 1.5 } },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local done = false -- always
		local i = 1

		while not done do
			local roll = math.ceil(math.random()*6)
			if check_add('jokers') and roll > 5 then  
				-- make negative joker (1 in 6)
                SMODS.add_card { set = 'Joker', edition = 'e_negative', key_append = 'rgmc_' }
                G.GAME.joker_buffer = 0
			elseif roll <= 3 and check_add('consumeables') then
				-- make a negative consumable (1 in 2)
				MadLib.simple_event(function()
                    SMODS.add_card( { 
						area = G.consumeables, 
						soulable = false, 
						key = Madcap.Funcs.get_random_consumable().key, 
						edition = 'e_negative'
					})
                    G.GAME.consumeable_buffer = 0
                    return true
				end, 0.3, 'after')
			else
				-- make negative playing card (1 in 3)
            	SMODS.create_card { set = "Base", area = G.discard, edition = 'e_negative' }
            	G.playing_card = (G.playing_card and G.playing_card + 1) or 1
			end
			-- if you don't roll a 1 in 4+i, it ends
			done = not MadLib.calculate_roll({
                seed = 'rgmc_madcrap',
                denom = self.config.extra.odds + i
            })
		end
	end
}

-- [Cosma] LIFE ON EARTH: Converts 2 random cards to Voids/Lanterns
-- Parallels XXI - The World (Spades).
local life_on_earth = {
    key 	= "life_on_earth",
	pos 	= get_pos(2,1),
	config	= { select = 2, extra = { suits = {'rgmc_voids', 'rgmc_lanterns'} } },
	cost 	= 7,
	can_use = function(self, card)
		return G.hand and MadLib.loop_func(G.hand.cards, function(v)
			return not (v:is_suit(self.config.extra[1]) or v:is_suit(self.config.extra[2])
		end) >= (self.config.select or 2)
	end,
	use = Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
		return not (v:is_suit(self.config.extra[1]) or v:is_suit(self.config.extra[2])
	end, function(v)
		local _suit = v:has_light_suit() and self.config.extra[2] 
			or v:has_dark_suit() and self.config.extra[1]
			or pseudorandom_element(self.config.suits)
		MadLib.simple_event(function() assert(SMODS.change_base(v, _suit, nil)) end)
	end)
}


-- [Cosma] SLEEPING SHIPS
-- Parallels The Soul.
local sleeping_ships = {
    key 		= "sleeping_ships",
	pos 		= get_pos(2,2),
	soul_pos	= get_pos(2,3),
	config		= { extra = 1 },
	cost 		= 24,
	loc_vars = function(self, info_queue, card)
		return MadLib.collect_vars(card.ability.extra)
	end,
	can_use 	= function(self, card)
		return true -- Always
	end,
	hidden = true, -- Hard as hell to get
	use 	= function(self, card, area, copier)
		for i=1,card.ability.extra do
			-- Create an Unusual Joker
			MadLib.simple_event(function()
				play_sound("timpani")
				local card = create_card("Joker", G.jokers, nil, "rgmc_unusual", nil, nil, nil, "rgmc_sleeping_ships")
				card:set_edition({ negative = true })
				card:add_to_deck()
				G.jokers:emplace(card)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
	end
}

-- [Cosma] AVERSION
-- Parallels Gateway.
local aversion = {
	object_type = "Consumable",
	set 		= "CosmaTarot",
	key 	= "aversion",
	atlas 	= "aversion",
	order 	= 10000,
	pos 	= 	{ x = 0, y = 0},
	soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 } },
	config 	= { },
	cost 	= 66,
	can_use = function(self, card)
		return true -- Always
	end,
	hidden = true, -- Hard as hell to get
	use = function(self, card, area, copier)

		-- Delete the Jokers
		local _first_dissolve = nil
		MadLib.simple_event(function()
			MadLib.loop_func(MadLib.get_list_matches(G.jokers.cards, function(v)
				return not (v.ability.eternal or v.config.center.rarity == 'rgmc_unusual')
			end),
			function(v)
				if
					v.config.center.rarity == "cry_exotic" then
					check_for_unlock({ type = "what_have_you_done" })
				end
				v:start_dissolve(nil, _first_dissolve)
				_first_dissolve = true
			end)
		end, 0.75, 'before')

		-- Create a Chaotic Joker
		MadLib.simple_event(function()
			return true
		end, 0.4, 'after')

		delay(0.6)
	end,
}

--[[
	Antispectrals
]]

SMODS.ConsumableType({
    key = "AntiSpectral",
    primary_colour = HEX("DF463F"),
    secondary_colour = HEX("A9463B"),
    collection_rows = { 5, 6 },
    shop_rate = 0.0, -- only seen in evil boosters
    loc_txt = {},
    default = "c_strength",
    can_stack = true,
    can_divide = true,
})

function Madcap.Funcs.add_sinister(key, v1, subkey, v2)
	-- access data
	G.GAME.rgmc_sinister = G.GAME.rgmc_sinister or {}
	G.GAME.rgmc_sinister[key] = G.GAME.rgmc_sinister[key] or {}
	local sinister_key = G.GAME.rgmc_sinister[key]
	-- add rounds
	sinister_key.rounds 	= (sinister_key.rounds or 0) + v1
	sinister_key[subkey]	= (sinister_key[subkey] or 0) + v2
end

local prioritize_vulnerable_cards = function(a,b)
	local _a = (a:is_invulnerable() and 1 or 0) + math.random()/2
	local _b = (b:is_invulnerable() and 1 or 0) + math.random()/2
	return _a > _b
end

-- Anti Familiar: removes 1/2 face cards from deck.
-- if paraedolia is added, counts ALL face cards!
local familiar = {
	key		= 'anti_familiar',
	config	= { select = 0.5 },
	can_use = function(self, card)
		return G.playing_cards and MadLib.list_matches_one(list, function(v)
        	return v:is_face()
   		end)
	end,
	use = function(self, card, area, copier)
		local selection = MadLib.shuffle_sort_list(G.playing_cards, #G.playing_cards, function(v)
			return v:is_face() -- is face card
		end, prioritize_vulnerable_cards)

		-- removes up to 1/2 of face cards
		MadLib.number_func(math.ceil(#selection/2), function(i)
			local _card = selection[i]
			local _first_dissolve = nil
			MadLib.simple_event(function()
				_card:start_dissolve(nil, _first_dissolve)
				_first_dissolve = true
			end, 0.1, 'after')
		end)
	end
}

-- Anti Grim: removes 1/2 aces from deck
local grim = {
	key		= 'anti_grim',
	config	= { select = 0.5, extra = { rank = 'Ace' } },
	can_use = function(self, card)
		return G.playing_cards and MadLib.list_matches_one(G.playing_cards, function(v)
        	return v:get_id() == (self.config.extra.rank or 'Ace')
   		end)
	end,
	use 	= function(self, card, area, copier)
		local selection = MadLib.shuffle_sort_list(G.playing_cards, #G.playing_cards, function(v)
			return v:get_id() == (self.config.extra.rank or 'Ace')
		end, prioritize_vulnerable_cards)

		-- removes up to 1/2 of ace cards
		MadLib.number_func(math.ceil(#selection/2), function(i)
			local _card = selection[i]
			local _first_dissolve = nil
			MadLib.simple_event(function()
				_card:start_dissolve(nil, _first_dissolve)
				_first_dissolve = true
			end, 0.1, 'after')
		end)
	end
}

function Madcap.Funcs.get_highest_rank(group, allow_faces, inverse)
	local max_value, highest = -30, nil
	local ranks = MadLib.get_ranks_from_cards(G.playing_cards, true)
	for k, _ in pairs(ranks) do
		local pts = SMODS.Ranks[k].nominal
		if SMODS.Ranks[k].face_nominal > 0 and not allow_faces then pts = max_value-1 end
		if pts > max_value then
			highest 	= k
			max_value 	= SMODS.Ranks[k].nominal + SMODS.Ranks[k].face_nominal
		end
	end
	return highest
end

-- Anti Incantation: removes highest number cards from deck
local incantation = {
	key		= 'anti_incantation',
	config	= { },
	can_use = function(self, card)
		return G.playing_cards and #G.playing_cards > 0
	end,
	use = function(self, card, area, copier)
		local highest_rank = Madcap.Funcs.get_highest_rank(G.playing_cards, false) -- id key

		-- grabs all the cards with the highest rank
        local selection = MadLib.get_list_matches(G.playing_cards, function(v)
			return v:get_id() == highest_rank
		end)

		MadLib.loop_func(selection, function(v)
			local _first_dissolve = nil
			MadLib.simple_event(function()
				_card:start_dissolve(nil, _first_dissolve)
				_first_dissolve = true
			end, 0.1, 'after')
		end)
	end
}

-- Anti Talisman: disables blind reward and interest for 2 rounds, gives $10 in 2 rounds
local talisman = {
	key		= 'anti_talisman',
	config	= { extra = { rounds = 2, money = 10  } },
	can_use = function(self, card)
		return true -- always
	end,
	use 	= function(self, card, area, copier)
        play_sound('timpani')
		Madcap.Funcs.add_sinister('talisman', self.config.extra.rounds or 2, 'money', self.config.extra.money or 10)
	end
}

-- Anti Aura: debuff editions for +2 rounds, gives $2 for each edition card debuffed
local aura = {
	key		= 'anti_aura',
	config	= { extra = 2 },
	can_use = function(self, card) -- at least one editioned playing card
		return MadLib.valid_table(MadLib.get_editioned_cards(G.playing_cards), 1)
	end,
	use = function(self, card, area, copier)
		Madcap.Funcs.add_sinister('aura', self.config.extra.rounds or 2)
		ease_dollars(#MadLib.get_editioned_cards(G.playing_cards) * (self.config.extra or 2))
	end
}

-- Anti Wraith: debuffs all jokers above uncommon for +2 rounds, gives $3 for each joker debuffed
local wraith = {
	key		= 'anti_wraith',
	config	= { extra = 3 },
	can_use = function(self, card)
		return MadLib.valid_table(MadLib.get_jokers_matching_min_rarity(G.jokers.cards, 'Uncommon', true), 1)
	end,
	use = function(self, card, area, copier)
		Madcap.Funcs.add_sinister('wraith', self.config.extra.rounds or 2)
		ease_dollars(#MadLib.get_jokers_matching_min_rarity(G.jokers.cards, 'Uncommon', true) * (self.config.extra or 3))
	end
}

local function gcd(a, b)
    while b ~= 0 do a, b = b, a % b end
    return a
end

function Madcap.Funcs.get_numer_denom(n)(x, max_denom)
    max_denom = max_denom or 1000
    local sign = x < 0 and -1 or 1
    x = math.abs(x)

    local best_numer, best_denom = 1, 1
    local best_error = math.abs(x - best_numer / best_denom)

    for denominator = 1, max_denom do
        local numerator = math.floor(x * denominator + 0.5)
        local error = math.abs(x - numerator / denominator)
        if error < bestError then
            best_numer = numerator
            best_denom = denominator
            best_error = error
            if best_error < 1e-10 then break end
        end
    end

    -- Simplify the fraction
    local common_devisor = gcd(best_numer, best_denom)
    best_numer = math.floor(best_numer / common_devisor)
    best_denom = math.floor(best_denom / common_devisor)

    return sign * best_numer, best_denom
end

-- Anti Sigil: destroys 3/4 of a random suit from deck
local sigil = {
	key		= 'anti_sigil',
	config	= { extra = 0.75 },
	can_use = function(self, card)
		return MadLib.list_matches_one(G.playing_cards, function(v)
			return not v:is_suitless() -- has a suit
		end)
	end,
	use = function(self, card, area, copier)
		local _suits = {}
		MadLib.loop_func_table(MadLib.get_suits_from_cards(G.playing_cards), function(k,v) table.insert(_suits,k) end)
		local _pick = pseudorandom_element(_suit,psuedoseed('rgmc_anti_sigil'))
		
		local selection = MadLib.shuffle_sort_list(G.playing_cards, #G.playing_cards, function(v)
			return v:is_suit(_pick)
		end, prioritize_vulnerable_cards)

		MadLib.number_func(math.ceil(#selection * self.config.extra ), function(i)
			local _card = selection[i]
			local _first_dissolve = nil
			MadLib.simple_event(function()
				_card:start_dissolve(nil, _first_dissolve)
				_first_dissolve = true
			end, 0.08, 'after')
		end)
	end
}

-- Anti Ouija: destroys 1/2 of a random rank from deck
local ouija = {
	key		= 'anti_ouija',
	config	= { extra = 0.5 },
	can_use = function(self, card)
		return MadLib.list_matches_one(G.playing_cards, function(v)
			return not v:is_rankless() -- has a suit
		end)
	end,
	use = function(self, card, area, copier)
		local _ranks = {}
		MadLib.loop_func_table(MadLib.get_ranks_from_cards(G.playing_cards), function(k,v) table.insert(_ranks,k) end)
		local _pick = pseudorandom_element(_suit,psuedoseed('rgmc_anti_ouija'))
		
		local selection = MadLib.shuffle_sort_list(G.playing_cards, #G.playing_cards, function(v)
			return v:get_id() == _pick
		end, prioritize_vulnerable_cards)

		MadLib.number_func(math.ceil(#selection * self.config.extra ), function(i)
			local _card = selection[i]
			local _first_dissolve = nil
			MadLib.simple_event(function()
				_card:start_dissolve(nil, _first_dissolve)
				_first_dissolve = true
			end, 0.08, 'after')
		end)
	end
}

-- Anti Ectoplasm: -1 Joker slot, +1 hand size
local ectoplasm = {
	key		= 'anti_ectoplasm',
	config	= { extra = 1 },
	can_use = function(self, card)
		return (G.jokers.config.card_limit - self.config.extra) >= 0
	end,
	use = function(self, card, area, copier)

	end
}

-- Anti Immolate = creates 5 Vino cards, -$10
local immolate = {
	key		= 'anti_immolate',
	config	= { extra = { add = 5, money = 15 } },
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		MadLib.simple_event(function()
			local _first_dissolve = nil
            local new_cards = {}
			MadLib.number_func(nil, self.config.extra.add or 5, function(i)
                cards[i] = SMODS.add_card { set = "Base", enhancement = 'rgmc_vino' }
			end)
        	SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
			ease_dollars(-self.config.extra.money, true)
        	return true
		end)
	end
}

-- Anti Ankh = Create an Eternal Engraved copy of a random Joker (bypasses compats)
local ankh = {
	key		= 'anti_ankh',
	config	= { },
	can_use = function(self, card)
		return G.jokers and #G.jokers.cards > 0
	end,
	use = function(self, card, area, copier)
		local chosen_joker = pseudorandom_element(G.jokers.cards, 'ankh_choice')
		MadLib.simple_event(function()
			-- make joker
			local copied_joker = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition)
            copied_joker:start_materialize()
            copied_joker:add_to_deck()
            if copied_joker.edition then copied_joker:set_edition(copied_joker.edition, true) end
			-- add stickers
			copied_joker.ability.eternal 		= true
			copied_joker.ability.rgmc_engraved 	= true
            G.jokers:emplace(copied_joker)
            return true
		end)
	end
}

-- Anti Deja Vu
local deja_vu = {
	key		= 'anti_deja_vu',
	config	= { extra = { rounds = 2, money = 10  } },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)
        play_sound('timpani')
		Madcap.Funcs.add_sinister('deja_vu', self.config.extra.rounds or 2, 'money', self.config.extra.money or 10)
	end
}

-- Anti Hex = Remove all enhancements and editions in deck, give $X for each card affected
local hex = {
	key		= 'anti_hex',
	config	= { extra = { percent = 1, money = 2 } },
	can_use = function(self, card)
		return MadLib.valid_table(MadLib.get_editioned_cards(G.playing_cards), 1)
	end,
	use = function(self, card, area, copier)
		local total_money = 0

		local enhanced 	= MadLib.get_enhanced_cards(G.playing_cards)
		Madcap.loop_func(enhanced, function(v)
			v:set_ability(G.P_CENTERS.c_base, nil, true) -- remove enhancement
			total_money = total_money + self.config.extra.money
		end)
		
		local editioned	= MadLib.get_editioned_cards(G.playing_cards)
		Madcap.loop_func(editioned, function(v)
			v:set_edition(nil,true,true) -- remove editions
			total_money = total_money + self.config.extra.money * 1.5
		end)

		if total_money > 0 then ease_dollars(math.floor(total_money)) end
	end
}

-- Anti Trance = Remove 3 levels from your most played hand, add 1 level to 3 least played hands
local trance = {
	key		= 'anti_trance',
	config	= { extra = 3 },
	can_use = function(self, card)
		return G.GAME.hands[MadLib.get_most_played_hand()].level > (self.config.extra or 3)
	end,
	use = function(self, card, area, copier)
		-- level down most played poker hand
		local most_played = MadLib.get_most_played_hand()
		local least_played_num = most_played.played

		-- get # of least played
		MadLib.loop_func_table(G.GAME.hands, function(k,v)
			if v.played < least_played_num then least_played_num = v.played end
		end)

		-- get possible candidates
		local level_up_hands = MadLib.get_cards_from_shuffled_deck(G.GAME.hands, math.min(self.config.extra,#G.GAME.hands), function(v)
			v.played == least_played_num
		end, function(v)
			return math.random() < 0.5 -- coin flip
		end)

		-- add levels
		MadLib.loop_func(level_up_hands, function(v)
			MadLib.do_level_up(card, v, 1)
		end)
		
		-- get 3 of the least played poker hands, add the levels ala decant
	end
}

-- Anti Medium = Disable consumable area for 2 rounds, +1 consumable slot afterwards
local medium = {
	key		= 'anti_medium',
	config	= { extra = { rounds = 2, add_slots = 1 } },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)
		Madcap.Funcs.add_sinister('medium', self.config.extra.rounds or 2, 'consumeable', self.config.extra.slots or 10)
	end
}

-- Anti Cryptid = +4 Ante, +2 joker slot
local cryptid = {
	key		= 'anti_cryptid',
	config	= { extra = { ante = 4, slots = 2 }},
	can_use = function(self, card)
		return true -- always!
	end,
	use = function(self, card, area, copier)
		ease_ante(card.ability.extra.ante or 4)
		G.jokers.config.card_limit = lenient_bignum(G.jokers.config.card_limit + to_big(card.ability.extra.slots or 1))
	end
}

local cosmas = {
	demise,
	crow,
	swan,
	peacock,
	pelican,
	phoenix,
	soulmates,
	spirit_plane,
	orbs,
	cosmic_tree,
	life_map,
	karma,
	sacrifice,
	past_lives,
	maze,
	vessel,
	shore,
	veil,
	bridge,
	pathways,
	unknown,
	life_on_earth,
	sleeping_ships
}

local antispectrals = {
	familiar,
	grim,
	incantation,
	talisman,

	aura,
	wraith,
	sigil,
	ouija,

	ectoplasm,
	immolate,
	ankh,
	deja_vu,

	hex,
	trance,
	medium,
	cryptid
}

local list = {
	girder,
	filament,
	polish,
	providence,
	reduct,
	oxidize,
	madcrap,
	chalice,
	armoire,
	bluebell,
	amaryllis
}

for i=1, #list do
	list[i].object_type = "Consumable"
	list[i].atlas 		= "consumables"
    list[i].order 		= i-1
end

-- Cosma Tarots
for i=1, #cosmas do
	cosmas[i].object_type 	= "Consumable"
	cosmas[i].set 			= "CosmaTarot"
	cosmas[i].atlas 		= "cosma_tarots"
    cosmas[i].order 		= i+500
    table.insert(list,cosmas[i])
end

-- Anti-spectral Tarots
for i=1, #antispectrals do
	antispectrals[i].object_type 	= "Consumable"
	antispectrals[i].set 			= "AntiSpectral"
	antispectrals[i].atlas 			= "anti_spectrals"
    antispectrals[i].order 			= i+700
    antispectrals[i].pos			= get_pos(math.floor((i-1)/10),(i-1)%10)
    antispectrals[i].draw = function(self, card, layer)
		--card.children.center:draw_shader("negative", nil, card.ARGS.send_to_shader)
		card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
	end
    table.insert(list,antispectrals[i])
end


list[#list+1] = aversion

return {
    name = "Consumables",
    init = function() print("Consumables!") end,
    items = list
}
