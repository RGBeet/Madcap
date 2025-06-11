-- taken from showdown
local base_suits = {'Diamonds', 'Clubs', 'Hearts', 'Spades'}

local function inject_p_card_suit_compat(suit, rank)
	local card = {
		name = rank.key .. ' of ' .. suit.key,
		value = rank.key,
		suit = suit.key,
		pos = { x = rank.pos.x, y = rank.suit_map[suit.key] or suit.pos.y },
		lc_atlas = rank.suit_map[suit.key] and rank.lc_atlas or suit.lc_atlas,
		hc_atlas = rank.suit_map[suit.key] and rank.hc_atlas or suit.hc_atlas,
	}

	if findInTable(card.suit, base_suits) == -1 then
		if not RGMC.custom_suits[card.suit] then
			tell("Unknown suit for "..card.name)
			card.lc_atlas = 'rgmc_unknownSuit'
			card.hc_atlas = 'rgmc_unknownSuit'
			card.pos = {x = 0, y = 0}
		else
			card.lc_atlas = RGMC.custom_suits[card.suit].lc_atlas
			card.hc_atlas = RGMC.custom_suits[card.suit].hc_atlas
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
	hidden = true,
    key = 'knight',
    card_key = 'Kn',
    pos = { x = 0 },
    nominal = 10,
    face_nominal = 0.15,
    face = true,
	strength_effect = {
        fixed = 1,
        random = false,
        ignore = false
    },
    next = { 'Queen' },
    prev = { 'Jack' },
    shorthand = 'C',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks.knight
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
	hidden = true,
    key = 'sum',
    card_key = 'sum',
    pos = { x = 2 },
    nominal = 0,
    face = false,
    face_nominal = 99,
    shorthand = '=',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks.sum
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
	hidden = true,
    key = '10.5',
    card_key = '10.5',
    pos = { x = 1 },
    nominal = 10.5,
    face = false,
	strength_effect = {
        fixed = 1,
        random = false,
        ignore = false
    },
    next = { 'Jack' },
    prev = { '10' },
    shorthand = '21/2',
	straight_edge = false,
	in_pool = function(self, args)
        if args and args.initial_deck then
            return false
        end
        return G.GAME and G.GAME.rank_unlocks and G.GAME.rank_unlocks.ten_half
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
    ten_half
}

return {
    name = "Ranks",
    init = function()

		-- the straights!
		table.insert(SMODS.Ranks["Jack"].next, "rgmc_knight")
		table.insert(SMODS.Ranks["10"].next, "rgmc_10.5")

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

		RGMC.custom_suits['rgmc_goblets'] = {lc_atlas = 'rgmc_new_suits_ranks', hc_atlas = 'rgmc_new_suits_ranks_hc'}
        RGMC.custom_suits['rgmc_towers'] = {lc_atlas = 'rgmc_new_suits_ranks', hc_atlas = 'rgmc_new_suits_ranks_hc'}

        print("Ranks!")
    end,
    items = list
}
