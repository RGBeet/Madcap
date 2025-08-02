local list = {}

local get_pos = function(_y,_x)
    return {
        x = _x,
        y = _y
    }
end

local function get_planet_vars(id)
    return {
        vars = {
            localize(id),
            G.GAME.hands[id].level,
            G.GAME.hands[id].l_mult,
            G.GAME.hands[id].l_chips,
            colours = {
                (
                    to_big(G.GAME.hands[id].level) == to_big(1) and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands[id].level))]
                ),
            },
        },
    }
end

SMODS.ConsumableType({
    key = "SpatiaPlanet",
    primary_colour = HEX("5024FF"),
    secondary_colour = HEX("2600C1"),
    collection_rows = { 5, 6 },
    shop_rate = 0.5,
    loc_txt = {},
    default = "c_rgmc_rocket",
    can_stack = true,
    can_divide = true,
})


local function get_subhand_planet_vars(hand_ids,subhand_ids)
    local vars = {
		colours = {}
    }
    for i=1, #hand_ids do
		local id = hand_ids[i]
		table.insert(vars, localize(id))
		table.insert(vars, G.GAME.hands[id].level)
		table.insert(vars, G.GAME.hands[id].l_mult)
		table.insert(vars, G.GAME.hands[id].l_chips)
    end
    for i=1, #hand_ids do
		local id = hand_ids[i]
		table.insert(vars.colours, to_big(G.GAME.hands[id].level) == to_big(1) and G.C.UI.TEXT_DARK
                    or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands[id].level))])
	end
	for i=1, #subhand_ids do
		local id = subhand_ids[i]
		table.insert(vars, localize(id))
		table.insert(vars, G.GAME.subhands[id].level)
		table.insert(vars, G.GAME.subhands[id].l_mult)
		table.insert(vars, G.GAME.subhands[id].l_chips)
	end
    return { vars }
end


-- Pyramid
local tatooine = {
	key = "tatooine",
	config = { hand_type = "rgmc_pyramid", softlock = true },
	pos = get_pos(0,0),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	generate_ui = 0,
}

SMODS.PokerHand({
	key = "rgmc_pyramid",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
        { 'S_K',    true },
        { 'C_8', 	true },
        { 'H_8', 	true },
        { 'S_4',    true },
        { 'C_4',    true },
        { 'D_4', 	true },
	},
	evaluate = function(parts, hand)
        return parts.rgmc_pyramid_base
	end,
})

-- Pyramid Base
SMODS.PokerHandPart{
    key = 'pyramid_base',
    func = function(hand)

		if #hand < 6 then return { } end

		local card_data = {}

		-- Store card information based on unique values
		for i = 1, #hand do
			local value = hand[i].base.value
			local base_nominal = hand[i].base.nominal
			local face_nominal = hand[i].base.face_nominal
			if not card_data[value] then
				card_data[value] = { count = 0, base_nominal = base_nominal, face_nominal = face_nominal }
			end
			card_data[value].count = card_data[value].count + 1
		end

		local sorted_cards = {}

		-- Collect unique cards and sort them by sum of nominal values
		for value, data in pairs(card_data) do
			table.insert(sorted_cards, { value = value, count = data.count, sum_nominal = data.base_nominal + data.face_nominal })
		end

		table.sort(sorted_cards, function(a, b) return a.sum_nominal < b.sum_nominal end)

		local lowest_three, medium_pair, highest_single = nil, nil, nil

		-- Find a three-of-a-kind, a pair, and a high card
		for _, card in ipairs(sorted_cards) do
			if card.count == 3 and not lowest_three then
				lowest_three = card
			elseif card.count == 2 and not medium_pair and lowest_three and card.sum_nominal > lowest_three.sum_nominal then
				medium_pair = card
			elseif card.count == 1 and medium_pair and card.sum_nominal > medium_pair.sum_nominal then
				highest_single = card
			end
		end

		local pyramid = false

		-- Ensure values are unique and sums are in ascending order
		if lowest_three and medium_pair and highest_single then
			pyramid = lowest_three.value ~= medium_pair.value
			and medium_pair.value ~= highest_single.value
			and highest_single.value ~= lowest_three.value
			and lowest_three.sum_nominal < medium_pair.sum_nominal
			and medium_pair.sum_nominal < highest_single.sum_nominal
		end

		if pyramid then return { hand }
		else return {} end

	end
}

-- Flush Pyramid
local genosis = {
	key = "genosis",
	config = { hand_type = "rgmc_pyramid_flush", softlock = true },
	pos = get_pos(0,1),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	generate_ui = 0,
}

SMODS.PokerHand({
	key = "rgmc_pyramid_flush",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
        { 'S_K',    true },
        { 'S_8', 	true },
        { 'S_8', 	true },
        { 'S_4',    true },
        { 'S_4',    true },
        { 'S_4', 	true },
	},
	evaluate = function(parts, hand)
        --return {SMODS.merge_lists(parts['rgmc_pyramid_base'], parts['_flush'])}
        return false
	end,
})



-- Spectrum Pyramid
local jakku = {
	key = "jakku",
	config = { hand_type = "rgmc_pyramid_spectrum", softlock = true },
	pos = get_pos(0,2),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	generate_ui = 0,
}

SMODS.PokerHand({
	key = "rgmc_pyramid_spectrum",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
        { 'D_K',    true },
        { 'H_8',    true },
        { 'C_8', 	true },
        { 'S_4', 	true },
        { 'GOB_4', 	true },
        { 'TOW_4', 	true },
	},
	evaluate = function(parts, hand)
        --return {SMODS.merge_lists(parts['rgmc_pyramid_base'], parts[MadLib.SpectrumId])}
        return false
	end,
})

local Bunco 	= next(SMODS.find_mod('Bunco'))

local function excard(card)
	return { card, true }
end

-- for the 8 dark/light planet cards
local card_handtypes = {
	{ 'Flush', MadLib.SpectrumId .. 'Spectrum', 'Four of a Kind' },
	{ 'Straight', MadLib.SpectrumId .. 'Straight Spectrum', 'Straight Flush' },
	{ 'Full House', MadLib.SpectrumId .. 'Spectrum House', 'Flush House',  },
	{ 'Five of a Kind', MadLib.SpectrumId .. 'Spectrum Five', 'Flush Five', },
}

local function get_spectrum_example(dark, ranks)
	local card_list = {}
	local suit_pattern = dark and dark_pattern or light_pattern

	for i=1,math.min(#ranks,5) do -- make the suit and pattern
		card_list[i] = { suit_pattern[i]..'_'..ranks[i], true }
	end

	return card_list
end

-- Dark + Spectrum
local prometheus = {
	key = "prometheus",
	pos = get_pos(0,3),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
	end,
	generate_ui = 0,
}

-- Light + Spectrum
local rigel = {
	key = "rigel",
	pos = get_pos(0,4),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		--return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

-- Dark + Full House
local tartarus = {
	key = "tartarus",
	pos = get_pos(0,5),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		--return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

-- Light + Full House
local aquaworld = {
	key = "aquaworld",
	pos = get_pos(0,6),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

-- Dark + Straight
local varakkis = {
	key = "varakkis",
	pos = get_pos(0,7),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

-- Light + Straight
local jurassika = {
	key = "jurassika",
	pos = get_pos(1,0),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

-- Dark + FOAK
local xykulix = {
	key = "xykulix",
	pos = get_pos(1,1),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

-- Light + FOAK
local globulos = {
	key = "globulos",
	pos = get_pos(1,2),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("k_planet"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	generate_ui = 0,
}

Madcap.PickFiveDefault = {
	{ rank = '2' , suit = 'Spades' },
	{ rank = '4' , suit = 'Hearts' },
	{ rank = '6' , suit = 'Diamonds' },
	{ rank = '10' , suit = 'Clubs' },
	{ rank = 'A' , suit = 'Spades' }
}

-- Pick Five
local rocket = {
	key = "rocket",
	pos = get_pos(2,5),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_rocket"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return { vars = {} }
	end,
	generate_ui = 0,
}

SMODS.PokerHand({
	key = "rgmc_pick_five",
	visible = Madcap.Data.devmode,
	chips = 1000,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
		{ "C_2", true },
		{ "H_4", true },
		{ "D_7", true },
		{ "D_9", true },
		{ "S_Q", true },
	},
	evaluate = function(parts, hand)

		if #hand ~= 5 or not G.GAME.MADCAP then return { } end -- must have 5+ face cards
		local pass = true

		local hand_data, pick5_data = {}, MadLib.deep_copy(G.GAME.pick_5)
		
		MadLib.loop_func(hand, function(v,i)
			hand_data[i] = { rank = v.base.value, suit = v.base.suit }
		end)

		MadLib.loop_func({ hand_data, pick5_data }, function(t)
			table.sort(t, function(a,b) return (a.rank ~= b.rank) and (a.rank > b.rank) or (a.suit > b.suit) end)
		end)

		local index = 0
		while pass and index < 5 do
			if 
				hand_data[index].rank ~= pick5_data[index].rank
				or hand_data[index].suit ~= pick5_data[index].suit
			then
				pass = false
			end
			index = index + 1
		end

		return pass and { hand } or { }
	end,
})



-- Blazer
local sol_3 = {
	key = "sol_3",
	config = { hand_type = "rgmc_blazer", softlock = true },
	pos = get_pos(1,3),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_planet_alt"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

-- Blazer - above Two Pair, under Straight?
SMODS.PokerHand({
	key = "rgmc_blazer",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
		{ "C_J", 	true },
		{ "H_J", 	true },
		{ "D_KN",	true },
		{ "D_Q", 	true },
		{ "S_K", 	true },
	},
	evaluate = function(parts, hand)
		local minimum = 5

		if #hand < minimum  then return { } end -- must have 5+ face cards

		local all_faces = true
		for i=1, #hand do
			local rank = SMODS.Ranks[hand[i].base.value]
			if not rank.face then
				all_faces = false
				break -- not a face rank, we done
			end
		end

		return all_faces and { hand } or { }
	end,
})


-- Kaleidoscope: 5 Bismuth cards. Think a gay Bulwark
local lobster = {
	key = "lobster",
	config = { hand_type = "rgmc_kaleidoscope", softlock = true },
	pos = get_pos(1,4),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_space_lobster"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

SMODS.PokerHand({
	key = "rgmc_kaleidoscope",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
		{ "S_A", true, enhancement = "m_rgmc_bismuth" },
		{ "S_A", true, enhancement = "m_rgmc_bismuth" },
		{ "S_A", true, enhancement = "m_rgmc_bismuth" },
		{ "S_A", true, enhancement = "m_rgmc_bismuth" },
		{ "S_A", true, enhancement = "m_rgmc_bismuth" },
	},
	evaluate = function(parts, hand)
		local bismuths = {}
		return MadLib.loop_func(hand, function(v,i)
			if v.config.center_key ~= "m_rgmc_bismuth" then return false end
			table.insert(bismuths,v)
			return true
		end) >= 5 and { bismuths } or {}
	end,
})

-- None of a Kind
local nowhere = {
	key = "nowhere",
	config = { hand_type = "rgmc_noak", softlock = true },
	pos = get_pos(1,5),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_anomality"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}


SMODS.PokerHand({
	key = "rgmc_noak",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
		{ "C_0", 	true },
		{ "H_0", 	true },
		{ "T_0",	true },
		{ "D_SU", 	true },
		{ "S_SU", 	true },
	},
	evaluate = function(parts, hand)
		local noak = 0
		for _,v in pairs(hand) do
			noak = noak + v.base.nominal
		end
		return ( noak == 0 and #hand > 4 ) and { hand } or {}
	end,
})



-- Infinitum
local wormhole = {
	key = "wormhole",
	config = { hand_type = "rgmc_infoak", softlock = true },
	pos = get_pos(1,6),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_anomality"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

SMODS.PokerHand({
	key = "rgmc_infoak",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
		{ "H_IN", 	true },
		{ "S_IN", 	true },
		{ "DAG_IN",	true },
		{ "BLO_IN", true },
		{ "LAN_IN", true },
	},
	evaluate = function(parts, hand)
		local infinity = 0
		for _,v in pairs(hand) do
			if v:get_id() == 'rgmc_infinity' then
				infinity = infinity + 1
			end
		end
		return (infinity > 4) and { hand } or {}
	end,
})



-- Infinitum Fluxus
local everywhere = {
	key = "everywhere",
	config = { hand_type = "rgmc_infoak_flush", softlock = true },
	pos = get_pos(1,7),
	atlas = "planets",
	aurinko = true, -- Aurinko compatible
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_anomality"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
	loc_vars = function(self, info_queue, center)
		return get_planet_vars(self.config.hand_type)
	end,
	generate_ui = 0,
}

SMODS.PokerHand({
	key = "rgmc_infoak_flush",
	visible = Madcap.Data.devmode,
	chips = 100,
	mult = 10,
	l_chips = 50,
	l_mult = 1,
	example = {
		{ "D_IN", 	true },
		{ "D_IN", 	true },
		{ "D_IN",	true },
		{ "D_IN", 	true },
		{ "D_IN", 	true },
	},
	evaluate = function(parts, hand)
		local infinity = false
		return (infinity and parts['_flush']) and { hand } or {}
	end,
})



-- Blue Moon - 0.5 levels to all Light Spectrum hand types.
local blue_moon = {
	key = "blue_moon",
	pos = get_pos(2,6),
	config = {},
	cost = 8,
	aurinko = true,
	atlas = "planets",
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_moon"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

-- Blood Moon - 0.5 levels to all Dark Spectrum hand types.
local blood_moon = {
	key = "blood_moon",
	pos = get_pos(2,7),
	config = {},
	cost = 8,
	aurinko = true,
	atlas = "planets",
	set_card_type_badge = function(self, card, badges)
		badges[1] = create_badge(localize("rgmc_moon"), get_type_colour(self or card.config, card), nil, 1.2)
	end,
}

--[[

		if Cryptid.enabled("set_cry_poker_hand_stuff") ~= true or Cryptid.enabled("c_cry_asteroidbelt") ~= true then
			return {}
		end
]]

local planets = {
    tatooine,
    genosis,
    jakku,
    sol_3,
    lobster,
    nowhere,
    wormhole,
    everywhere,
}

local spatia = {
    prometheus,
    rigel,
    tartarus,
    aquaworld,
	varakkis,
    jurassika,
    xykulix,
    globulos,
    blue_moon,
    blood_moon,
	rocket
}

	--[[
]]

MadLib.loop_func(planets, function(v,i)
    v.object_type = "Consumable"
	v.set = "Planet"
	v.order = i
	table.insert(list,v)
end)

MadLib.loop_func(spatia, function(v,i)
    v.object_type = "Consumable"
	v.set = "SpatiaPlanet"
	v.order = i + 20
	table.insert(list,v)
end)


return {
    name = "Planets",
    init = function() print("Planets!") end,
    items = list
}
