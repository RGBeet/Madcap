-- taken from showdown

local base_suits = {'Diamonds', 'Clubs', 'Hearts', 'Spades'}

local blacklist_suits = {
    'akyrs_booster',
    'akyrs_consumable',
    'akyrs_boucher',
    'akyrs_joker',
    'akyrs_thing',
}

local function inject_p_card_suit_compat(suit, rank)
	local card = {
		name = rank.key .. ' of ' .. suit.key,
		value = rank.key,
		suit = suit.key,
		pos = { x = rank.pos.x, y = rank.suit_map[suit.key] or suit.pos.y },
		lc_atlas = rank.suit_map[suit.key] and rank.lc_atlas or suit.lc_atlas,
		hc_atlas = rank.suit_map[suit.key] and rank.hc_atlas or suit.hc_atlas,
	}

	if
        MadLib.find_in_table(card.suit, base_suits)
        and not MadLib.find_in_table(card.suit, blacklist_suits) == -1
    then -- not found
		if not MadLib.CustomSuits[card.suit] then
			tell("Unknown suit for "..card.name)
			card.lc_atlas = 'rgmc_unknownSuit'
			card.hc_atlas = 'rgmc_unknownSuit'
			card.pos = {x = 0, y = 0}
		else
			card.lc_atlas = MadLib.CustomSuits[card.suit].lc_atlas
			card.hc_atlas = MadLib.CustomSuits[card.suit].hc_atlas
		end
	end
	--tell('Before:')
	--print(G.P_CARDS[suit.card_key .. '_' .. rank.card_key])
	G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = card
	--tell('After:')
	--print(G.P_CARDS[suit.card_key .. '_' .. rank.card_key])
end

-- Knight: goes between Jack and Queen.
local knight = {
    object_type = "Rank",
	hc_atlas = 'new_ranks_hc',
    lc_atlas = 'new_ranks',
	hidden = not Madcap.Data.devmode,
    key = 'Knight',
    card_key = 'KN',
    pos = { x = 0 },
    nominal = 10,
    face_nominal = 0.15,
    face = true,
	--strength_effect = { fixed = 2, random = false, ignore = false },
    shorthand = 'C',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Data.devmode or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
    end,
	inject = function(self)
		for _, suit in pairs(SMODS.Suits) do
			inject_p_card_suit_compat(suit, self)
		end
	end,
}

local sum = {
    object_type = "Rank",
	hc_atlas = 'new_ranks_hc',
    lc_atlas = 'new_ranks',
	hidden = not Madcap.Data.devmode,
    key = 'Sum',
    card_key = 'SU',
    pos = { x = 2 },
    nominal = 0,
    face = false,
    face_nominal = 50,
    shorthand = '=',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Data.devmode or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
    end,
	inject = function(self)
		for _, suit in pairs(SMODS.Suits) do
			inject_p_card_suit_compat(suit, self)
		end
	end,
}

local infinity = {
    object_type = "Rank",
	hc_atlas = 'new_ranks_hc',
    lc_atlas = 'new_ranks',
	hidden = not Madcap.Data.devmode,
    key = 'Infinity',
    card_key = 'IN',
    pos = { x = 3 },
    nominal = 0,
    face = false,
    face_nominal = 70,
    shorthand = '~',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Data.devmode or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
    end,
	inject = function(self)
		for _, suit in pairs(SMODS.Suits) do
			inject_p_card_suit_compat(suit, self)
		end
	end,
}

local x = {
    object_type = "Rank",
	hc_atlas = 'new_ranks_hc',
    lc_atlas = 'new_ranks',
	hidden = not Madcap.Data.devmode,
    key = 'x',
    card_key = 'X',
    pos = { x = 3 },
    nominal = 0,
    face = false,
    face_nominal = 20,
    shorthand = 'X',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Data.devmode or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
    end,
	inject = function(self)
		for _, suit in pairs(SMODS.Suits) do
			inject_p_card_suit_compat(suit, self)
		end
	end,
}

local ten_half = {
    object_type = "Rank",
	hc_atlas = 'new_ranks_hc',
    lc_atlas = 'new_ranks',
	hidden = not Madcap.Data.devmode,
    key = '10.5',
    card_key = 'TH',
    pos = { x = 1 },
    nominal = 10.5,
    face = false,
	--strength_effect = { fixed = 2, random = false, ignore = false },
    shorthand = '21/2',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return Madcap.Data.devmode or (G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks[self.config.key])
    end,
	inject = function(self)
		for _, suit in pairs(SMODS.Suits) do
			inject_p_card_suit_compat(suit, self)
		end
	end,
}

local list = {
    knight,
    sum,
    ten_half,
    infinity,
    x
}

return {
    name = "Ranks",
    init = function()

		-- the straights!
		--table.insert(SMODS.Ranks["rgmc_10.5"].next, "Jack")
		--table.insert(SMODS.Ranks["Jack"].next, "rgmc_knight")
		--table.insert(SMODS.Ranks["rgmc_knight"].next, "Queen")

        SMODS.Atlas({
            key = "rgmc_new_suits_ranks",
            path = "new_suits_ranks.png",
            px = 71, py = 95
        })
        SMODS.Atlas({
            key = "rgmc_new_suits_ranks_hc",
            path = "new_suits_ranks_hc.png",
            px = 71, py = 95
        })

		MadLib.CustomSuits['rgmc_goblets']     = { lc_atlas = 'rgmc_new_suits_ranks',   hc_atlas = 'rgmc_new_suits_ranks_hc'    }
        MadLib.CustomSuits['rgmc_towers']      = { lc_atlas = 'rgmc_new_suits_ranks',   hc_atlas = 'rgmc_new_suits_ranks_hc'    }
		MadLib.CustomSuits['rgmc_blooms']      = { lc_atlas = 'rgmc_new_suits_ranks',   hc_atlas = 'rgmc_new_suits_ranks_hc'    }
        MadLib.CustomSuits['rgmc_daggers']     = { lc_atlas = 'rgmc_new_suits_ranks',   hc_atlas = 'rgmc_new_suits_ranks_hc'    }
		MadLib.CustomSuits['rgmc_voids']       = { lc_atlas = 'rgmc_new_suits_ranks',   hc_atlas = 'rgmc_new_suits_ranks_hc'    }
        MadLib.CustomSuits['rgmc_lanterns']    = { lc_atlas = 'rgmc_new_suits_ranks',   hc_atlas = 'rgmc_new_suits_ranks_hc'    }

        -- Bunco: Adds Fleurons and Halberds
        if next(SMODS.find_mod('Bunco')) then

        SMODS.Atlas({
            key = "rgmc_bunc_suits_ranks",
            path = "bunc_suits_ranks.png",
            px = 71, py = 95
        })

        SMODS.Atlas({
            key = "rgmc_bunc_suits_ranks_hc",
            path = "bunc_suits_ranks_hc.png",
            px = 71, py = 95
        })

            MadLib.CustomSuits['bunc_Fleurons']   = { lc_atlas = 'rgmc_bunc_suits_ranks',  hc_atlas = 'bunc_suits_ranks_hc'   }
            MadLib.CustomSuits['bunc_Halberds']   = { lc_atlas = 'rgmc_bunc_suits_ranks',  hc_atlas = 'bunc_suits_ranks_hc'   }
        end

        print("Ranks!")
    end,
    items = list
}
