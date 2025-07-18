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
			odds 		= 3,
			max_cards	= 4
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
	object_type = "Consumable",
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

-- [Cosma] DEMISE: Gives a random Cosma Tarot (besides Demise).
-- Parallels 0 - The Fool.
local demise = {
    key 	= "demise",
	pos 	= get_pos(0,0),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE CROW: Select two cards to convert to
-- [Daggers]. If already [Daggers], give them [+1 bonus mult].
-- Parallels II - The Magician (Lucky Card).
local crow = {
    key 	= "crow",
	pos 	= get_pos(0,1),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE SWAN: Select two cards to convert to
-- [Goblets]. If already [Goblets], give them [+X0.1 bonus mult].
-- Parallels II - The High Priestess (2 Planets).
local swan = {
    key 	= "swan",
	pos 	= get_pos(0,2),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE PEACOCK: Select two cards to convert to
-- [Blooms]. If already [Blooms], give them a [+$1 bonus money].
-- Parallels III - The Empress (Mult).
local peacock = {
    key 	= "peacock",
	pos 	= get_pos(0,3),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE PELICAN: Select two cards to convert to
-- [Towers]. If already [Towers], give them [+5 bonus chips].
-- Parallels IV - The Pelican (2 Tarots).
local pelican = {
    key 	= "pelican",
	pos 	= get_pos(0,4),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE PHOENIX: Halves chip value, but adds 1/5 of
-- total chip value as bonus mult.
-- Parallels V - The Hierophant (Bonus).
local phoenix = {
    key 	= "phoenix",
	pos 	= get_pos(0,5),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE SOULMATES: Select two cards, change each
-- suit to a random suit played this Blind.
-- Parallels VI - The Lovers (Wild).
local soulmates = {
    key 	= "soulmates",
	pos 	= get_pos(0,6),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

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
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE ORBS: Select two cards - 3 in 4 chance to
-- add random enhancement or change specific enhancement
-- to Madcap equivalent, destroy otherwise
-- Parallels VIII - Justice (Glass).
local orbs = {
    key 	= "orbs",
	pos 	= get_pos(0,8),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE COSMIC TREE: Gain $2 for every
-- unique suit / rank in hand.
-- Parallels IX - The Hermit (X2 Money).
local cosmic_tree = {
    key 	= "cosmic_tree",
	pos 	= get_pos(0,9),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE LIFE MAP: 1 in 4 chance to reroll a Joker
-- into one of a higher rarity.
-- Parallels X - The Wheel of Fortune ("1 in 4").
local life_map = {
    key 	= "life_map",
	pos 	= get_pos(1,0),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] KARMA - choose two cards, reduce higher rank by 2
-- and increase lower rank by 2
-- Parallels XI - Strength (+1 rank).
local karma = {
    key 	= "karma",
	pos 	= get_pos(1,1),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] SACRIFICE - Gain +X Mayhem,
-- but destroy a random Joker
-- Parallels XII - The Hanged Man (-2 cards).
local sacrifice = {
    key 	= "sacrifice",
	pos 	= get_pos(1,2),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] PAST LIVES - select 2 cards, turns
-- cards into previously destroyed cards (e.g. Glass)
-- Parallels XIII - Death (Copy card).
local past_lives = {
    key 	= "past_lives",
	pos 	= get_pos(1,3),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE MAZE: Select two cards, the rest have
-- their rank and suit shuffled. Gain $2 for each
-- changed card
-- Parallels XIV - Temperance (total Jokers).
local maze = {
    key 	= "maze",
	pos 	= get_pos(1,4),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE VESSEL: Select one card, multiply its
-- enhancement values by X1.5.
-- Parallels XV - The Devil (Gold).
local vessel = {
    key 	= "vessel",
	pos 	= get_pos(1,5),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE SHORE: Select one card, apply
-- Shielded sticker.
-- Parallels XVI - The Tower (Stone).
local shore = {
    key 	= "shore",
	pos 	= get_pos(1,6),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE VEIL: ???
-- Parallels XVII - The Star (Diamonds).
local veil = {
    key 	= "veil",
	pos 	= get_pos(1,7),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE BRIDGE: ???
-- Parallels XVIII - The Moon (Clubs).
local bridge = {
    key 	= "bridge",
	pos 	= get_pos(1,8),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] PATHWAYS: ???
-- Parallels XIX - The Sun (Hearts).
local pathways = {
    key 	= "pathways",
	pos 	= get_pos(1,9),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] THE UNKNOWN:
-- Parallels XX - Judgement (+Joker).
local unknown = {
    key 	= "unknown",
	pos 	= get_pos(2,0),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- [Cosma] LIFE ON EARTH: ???
-- Parallels XXI - The World (Spades).
local life_on_earth = {
    key 	= "life_on_earth",
	pos 	= get_pos(2,1),
	config	= { },
	cost 	= 7,
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
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

-- Anti Familiar: removes 1/2 face cards from deck
local familiar = {
	key		= 'anti_familiar',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Grim: removes 1/2 aces from deck
local grim = {
	key		= 'anti_grim',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Incantation: removes highest number cards from deck (ignores 6s)
local incantation = {
	key		= 'anti_incantation',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Talisman: disables blind reward and interest for 2 rounds, gives $10 in 2 rounds
local talisman = {
	key		= 'anti_talisman',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Aura: debuff editions for 2 rounds, gives $1 for each edition card debuffed
local aura = {
	key		= 'anti_aura',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Wraith: debuffs all jokers above uncommonfor 2 rounds, gives $3 for each joker debuffed
local wraith = {
	key		= 'anti_wraith',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Sigil: destroys 1/2 of a random suit from deck
local sigil = {
	key		= 'anti_sigil',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Ouija: destroys 3/4 of a random rank from deck
local ouija = {
	key		= 'anti_ouija',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Ectoplasm: -1 Joker slot, +1 hand size
local ectoplasm = {
	key		= 'anti_ectoplasm',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Immolate = creates X stone cards, -$X
local immolate = {
	key		= 'anti_immolate',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Ankh = Create an Eternal Engraved copy of a random Joker
local ankh = {
	key		= 'anti_ankh',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Ankh = Disable retriggering for 2 rounds, gain $X afterwards
local deja_vu = {
	key		= 'anti_deja_vu',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Hex = Remove 1/2 of enhancements and editions, give $X for each card affected
local hex = {
	key		= 'anti_hex',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Trance = Remove 3 levels from your most played hand, add 1 level to 3 least played hands
local trance = {
	key		= 'anti_trance',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Medium = Disable consumable area for 2 rounds, +1 consumable slot afterwards
local medium = {
	key		= 'anti_medium',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

	end
}

-- Anti Cryptid = +4 Ante, +1 joker slot
local cryptid = {
	key		= 'anti_cryptid',
	config	= { },
	can_use = function(self, card)
		return true
	end,
	use 	= function(self, card, area, copier)

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
