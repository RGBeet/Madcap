Madcap.Funcs.booster_create_card = function(self, card, set, seed)
	return create_card(set, G.pack_cards, nil, nil, true, true, nil, 'rgmc_'..seed)
end

Madcap.Funcs.booster_ease_bg = function(self, colour, special, contrast)
	ease_colour(G.C.DYN_UI.MAIN, colour)
	ease_background_colour({ new_colour = colour, special_colour = special, contrast = (contrast or 2) })
end

Madcap.Funcs.booster_loc_vars = function(self, info_queue, card)
	return MadLib.collect_vars(
			card and card.ability.choose or self.config.choose,
			card and card.ability.extra or self.config.extra)
end

function Madcap.Funcs.digital_hallucinations_compat(set,loc,colour)
	return {
		colour 		= colour,
		loc_key 	= 'k_'.. loc,
		create 		= function()
			local cc = MadLib.get_random_card(set, G.consumeables)
			cc:set_edition({ negative = true }, true)
			cc:add_to_deck()
			G.consumeables:emplace(cc)
		end,
	}
end

Madcap.BoosterTiers = {
	['base'] = {
		choices 	= 3,
		pick		= 1
	},
	['jumbo'] = {
		suffix		= 'jumbo',
		choices 	= 4,
		pick		= 1,
		weight_div	= 2,
		add_money	= 2,
	},
	['mega'] = {
		suffix		= 'mega',
		choices 	= 5,
		pick		= 2,
		weight_div	= 4,
		add_money	= 4,
	},
	['mk1'] = {
		suffix		= 'mk1',
		choices 	= 4,
		pick		= 1,
	},
	['mk2'] = {
		suffix		= 'mk2',
		choices 	= 6,
		pick		= 2,
	},

}

Madcap.BoosterSets = {
	['cosma'] = {
		kind 			= 'CosmaTarot',
		list			= {'base', 'jumbo', 'mega'},
		istart			= 0,
		in_pool			= true,
		base_weight 	= 0.96,
		base_price		= 6,
		create_card		= function(self, card)
			return Madcap.Funcs.booster_create_card(self, card, 'CosmaTarot', 'cosma')
		end,
		ease_background_colour	= function(self)
			Madcap.Funcs.booster_ease_bg(self, G.C.SET.CosmaTarot, G.C.BLACK)
		end,
		digital_hallucinations_compat = Madcap.Funcs.digital_hallucinations_compat('CosmaTarot', 'rgmc_plus_cosma', G.C.SET.CosmaTarot)
	},
	['reward'] = {
		kind 			= 'Reward',
		list			= {'mk1', 'mk2'},
		istart			= 4,
		in_pool			= true,
		update_pack		= function(self, dt)
			ease_colour(G.C.DYN_UI.MAIN, G.C.RGMC_UNUSUAL)
			ease_background_colour({ new_colour = G.C.RGMC_UNUSUAL, special_colour = G.C.BLACK, contrast = 2 })
			SMODS.Booster.update_pack(self, dt)
		end,
		digital_hallucinations_compat = Madcap.Funcs.digital_hallucinations_compat('CosmaTarot', 'rgmc_plus_cosma', G.C.SET.CosmaTarot)
	},
	['ruinous'] = {
		kind 			= 'AntiSpectral',
		list			= {'mk1', 'mk2'},
		in_pool			= false,
		digital_hallucinations_compat = Madcap.Funcs.digital_hallucinations_compat('AntiSpectral', 'rgmc_plus_antispectral', G.C.SET.AntiSpectral)
	}
}

local boosters = {}
MadLib.loop_func_table(Madcap.BoosterSets, function(_bkey,_bset)
	boosters[_bkey] = {}
	tell('Now processing booster set ' .. _bkey .. '...')
	MadLib.loop_func(_bset.list, function(_tier,i)
		tell('Looking for ' .. _tier .. '...')
		local _table = Madcap.BoosterTiers[_tier]
		if _table then
			local _key 						= _bkey .. (_table.suffix and '_' or '') .. (_table.suffix or '')
			tell('key is ' .. _key)
			local _table					= {}
			_table.key 						= _key
			_table.kind 					= _bset.kind
			_table.config 					= { extra = (_bset.choices or 3), choose = (_bset.pick or 1) }
			_table.weight 					= (_bset.base_weight or 0) / (_tier.weight_div or 1)
			_table.cost						= (_bset.base_price or 4) + (_tier.add_money or 0)
			_table.create_card				= _bset.create_card
			_table.in_pool					= _bset.in_pool or true
			_table.ease_background_colour	= _bset.ease_background_colour
			_table.loc_vars					= _bset.loc_vars or Madcap.Funcs.booster_loc_vars
			_table.group_key					= 'k_rgmc_' .. _bkey .. '_pack'
			_table.cry_digital_hallucinations	= _bset.digihal
			_table.update_pack					= _bset.update_pack
			table.insert(boosters[_bkey], _table)
		end
	end)
end)

local function temp_ban_joker(key)
	if G.GAME.banned_keys[key] == true then G.GAME.banned_keys[key] = 214389 end
	if not G.GAME.banned_keys[key] then
		G.GAME.banned_keys[key] = 214389
	elseif G.GAME.banned_keys[key] % 214389 == 0 then
		G.GAME.banned_keys[key] = G.GAME.banned_keys[key] + 214389
	end
end

local function temp_unban_joker(key)
	if G.GAME.banned_keys[key] == 214389 then
		G.GAME.banned_keys[key] = nil
	elseif G.GAME.banned_keys[key] % 214389 == 0 then
		G.GAME.banned_keys[key] = G.GAME.banned_keys[key] - 214389
	end
end

local cogito = {
	key 	= "cogito",
	kind 	= "CosmaTarot",
	no_doe 	= true,
	config 	= { extra = 2, choose = 1 },
	cost 	= 0,
	weight 	= 0,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	loc_vars = SMODS.Booster.loc_vars,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK) -- TODO: update to cogito
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.WHITE, lighten(G.C.GOLD, 0.2) },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
        local aversion_enabled  = i%2 == 0 and not G.GAME.banned_keys['c_rgmc_aversion']
        local sleeping_ships_enabled = i%2 == 1 and not G.GAME.banned_keys['c_rgmc_sleeping_ships']
        local soul_enabled = not G.GAME.banned_keys['c_soul']

        return (aversion_enabled and create_card("CosmaTarot", G.pack_cards, nil, nil, true, true, "c_cry_gateway"))
            or (sleeping_ships_enabled and create_card("CosmaTarot", G.pack_cards, nil, nil, true, true, "c_rgmc_sleeping_ships"))
            or (soul_enabled and create_card("Spectral", G.pack_cards, nil, nil, true, true, "c_soul"))
            or create_card("CosmaTarot", G.pack_cards, nil, nil, true, true)
	end,
	group_key = "k_rgmc_cosma_pack",
	cry_digital_hallucinations = {
		colour = G.C.SECONDARY_SET.Spectral,
		loc_key = "k_plus_cosma",
		create = function()
            local aversion_enabled  = i%2 == 0 and not G.GAME.banned_keys['c_rgmc_aversion']
            local sleeping_ships_enabled = i%2 == 1 and not G.GAME.banned_keys['c_rgmc_sleeping_ships']
            local soul_enabled = not G.GAME.banned_keys['c_soul']

            local ccard = (aversion_enabled and create_card("CosmaTarot", G.consumeables, nil, nil, true, true, "c_cry_gateway"))
                or (sleeping_ships_enabled and create_card("CosmaTarot", G.consumeables, nil, nil, true, true, "c_rgmc_sleeping_ships"))
                or (soul_enabled and create_card("Spectral", G.consumeables, nil, nil, true, true, "c_soul"))
                or create_card("CosmaTarot", G.consumeables, nil, nil, true, true)

			ccard:set_edition({ negative = true }, true)
			ccard:add_to_deck()
			G.consumeables:emplace(ccard)
		end,
	},
	in_pool = function()
		return false
	end,
}

local function get_compatible_jokers(_list, _area)
	return MadLib.get_list_matches(_list,function(w)
		return MadLib.list_matches_one(_area, function(v)
			return v.config.center.key == w
		end)
	end)
end

function Madcap.Funcs.create_joker_from_category(_category, _area, _bypass)
	if not _category or not_proper_table(_category) or #_category < 1 then return nil end

	if not _bypass then
		local _possible_cards = get_compatible_jokers(_list,_area)
	end

	local _joker_id = (#_possible_cards > 0)
		and (not _bypass and pseudorandom_element(_possible_cards,pseudoseed('rgmc')))
		or pseudorandom_element(_category,pseudoseed('rgmc'))

	local _temp = {
		set = "Joker",
		area = _area or G.jokers,
		key = _joker_id,
	}
	local _card = SMODS.create_card(_temp)
	return _card
end

-- Returns a Chip-based or Mult-based joker.
local function create_joker_chipmult(i,_area)
	if not i then return nil end
	local _cat = nil
	if i%2 == 0 then -- Chip
		if not MadLib.calculate_roll({
			seed = 'chips',
			denom = 8
		}) then
			_cat = MadLib.JokerLists.Chips.Multiply
		else
			_cat = MadLib.JokerLists.Chips.Add
		end
	else -- Mult
		if not MadLib.calculate_roll({
				seed = 'mult',
				denom = 8
		}) then
			_cat = MadLib.JokerLists.Mult.Multiply
		else
			_cat = MadLib.JokerLists.Mult.Add
		end
	end

	return Madcap.Funcs.create_joker_from_category(_cat, _area or G.pack_cards)
end

-- Returns a Joker previously destroyed or missed in shop.
local function create_joker_revival(_area)
	-- grab from dead jokers list
	local _matches = get_compatible_jokers(G.dead_jokers,_area)

	-- grab from jokers missed in shop list
	if #_matches == 0 then
		_matches = get_compatible_jokers(G.missed_jokers,_area)
	end

	if _matches > 0 then _matches = MadLib.get_combined_list(G.dead_jokers, G.missed_jokers) end

	return #matches > 0
		and Madcap.Funcs.create_joker_from_category(_matches, _area, true)
		or nil
end

-- Returns a food Joker
local function create_joker_food(_area)
	return get_compatible_jokers(MadLib.JokerLists.Food,_area)
end

local function digihal_prepare(_card,_area)
	_card:set_edition({ negative = true }, true)
	_card:add_to_deck()
	_area:emplace(_card)
end

-- Returns a common Joker
local function create_joker_common(_area)
	return create_card("Joker", _area, nil, "Common")
end

-- Gets one Chip, and one Mult Joker.
local chip_mult = {
	key 	= "chip_mult",
	kind 	= "Variety",
	no_doe 	= true,
	config 	= { extra = 2, choose = 1 }, -- red pill, blue pill
	cost 	= 8,
	weight 	= 0.24,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	unskippable = function(self)
		return G.jokers
			and (#G.jokers.cards == 0 or not G.jokers.cards)
			and not MadLib.list_matches_one(G.jokers.cards, function(v)
				return (v.ability.eternal or v.config.center.rarity == "cry_cursed")
			end)
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.RED, G.C.BLUE },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		-- Get Jokers from Mult and Chip categories
		return create_joker_chipmult(i, G.pack_cards)
	end,
	group_key = "k_rgmc_variety_pack",

	cry_digital_hallucinations = {
		colour = G.C.PURPLE,
		loc_key = "k_plus_joker",
		create = function()
			return digihal_prepare(create_joker_chipmult(math.floor(math.random() * 2), G.jokers.cards), G.jokers)
		end,
	},
	in_pool = function()
		return true
	end,
}

local revival = {
	key 	= "revival",
	kind 	= "Variety",
	no_doe 	= true,
	config 	= { extra = 4, choose = 1 }, -- red pill, blue pill
	cost 	= 8,
	weight 	= 0.24,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.RED, G.C.BLUE },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		-- Get Jokers from Mult and Chip categories
		return create_joker_revival(G.pack_cards)
	end,
	group_key = "k_rgmc_variety_pack",
	cry_digital_hallucinations = {
		colour = G.C.PURPLE,
		loc_key = "k_plus_joker",
		create = function()
			return digihal_prepare(create_joker_revival(G.jokers), G.jokers)
		end,
	},
	in_pool = function()
		return true
	end,
}

local food = {
	key 	= "food",
	kind 	= "Variety",
	no_doe 	= true,
	config 	= { extra = 5, choose = 1 }, -- red pill, blue pill
	cost 	= 8,
	weight 	= 0.24,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.RED, G.C.BLUE },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		return create_joker_food(G.pack_cards)
	end,
	group_key = "k_rgmc_variety_pack",
	cry_digital_hallucinations = {
		colour = G.C.PURPLE,
		loc_key = "k_plus_joker",
		create = function()
			return digihal_prepare(create_joker_food(G.jokers), G.jokers)
		end,
	},
	in_pool = function()
		return true
	end,
}

local common = {
	key 	= "common",
	kind 	= "Variety",
	no_doe 	= true,
	config 	= { extra = 5, choose = 1 }, -- red pill, blue pill
	cost 	= 8,
	weight 	= 0.24,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.RED, G.C.BLUE },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		-- Get Jokers from Mult and Chip categories
		return create_joker_common(G.pack_cards)
	end,
	group_key = "k_rgmc_variety_pack",
	cry_digital_hallucinations = {
		colour = G.C.PURPLE,
		loc_key = "k_plus_joker",
		create = function()
			return digihal_prepare(create_joker_common(G.jokers), G.jokers)
		end,
	},
	in_pool = function()
		return true
	end,
}

local function create_joker_misprintized(_area)
	local _card = create_card("Joker", G.pack_cards, nil, nil, true, true, nil, "rgmc")
	return _card
end

local misprint = {
	key 	= "misprint",
	kind 	= "Variety",
	no_doe 	= true,
	config 	= { extra = 5, choose = 1 }, -- red pill, blue pill
	cost 	= 8,
	weight 	= 0.24,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.RED, G.C.BLUE },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		-- Create a random Joker, but manipulate the card values
		return get_misprintized_joker(G.pack_cards)
	end,
	group_key = "k_rgmc_variety_pack",
	cry_digital_hallucinations = {
		colour = G.C.PURPLE,
		loc_key = "k_plus_joker",
		create = function()
			return digihal_prepare(create_joker_misprintized(G.jokers), G.jokers)
		end,
	},
	in_pool = function()
		return true
	end,
}

Madcap.JokerLists = Madcap.JokerLists or {}
Madcap.JokerLists.Meme = {
	'rgmc_thorium_joker'

}



MadLib.list_append(Madcap.JokerLists.Meme,'j_',nil)
local function create_joker_spam(_area,i)
	local is_spam = not i or i < 4 	-- either digihal'd or orignally spawned
	local _joker_id = 'j_rgmc_spam' -- get SPAM!

	if not is_spam then


	elseif
		G.GAME.spams_killed
		and G.GAME.spams_killed > 8
		and MadLib.calculate_roll({
			seed = 'lobster',
			denom = 10
		})
	then
		_joker_id = 'j_rgmc_lobster_thermidor'
	end

	local _temp = {
		set = "Joker",
		area = _area or G.jokers,
		key = _joker_id,
	}

	local _card = SMODS.create_card(_temp)
	return _card
end

local spam = {
	key 	= "spam",
	kind 	= "Variety",
	no_doe 	= true,
	config 	= { extra = 3, choose = 1 }, -- only SPAM.
	cost 	= 8,
	weight 	= 0.24,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.RED, G.C.BLUE },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		return create_joker_spam(G.pack_cards,i)
	end,
	group_key = "k_rgmc_variety_pack",
	cry_digital_hallucinations = {
		colour = G.C.PURPLE,
		loc_key = "k_plus_joker",
		create = function()
			return digihal_prepare(create_joker_spam(G.jokers), G.jokers)
		end,
	},
	in_pool = function()
		return true
	end,
}

local madcap_select = {
	key 	= "madcap_select",
	kind 	= "Variety",
	no_doe 	= true,
	config 	= { extra = 5, choose = 1 }, -- red pill, blue pill
	cost 	= 8,
	weight 	= 0.24,
	draw_hand = true,
	update_pack = SMODS.Booster.update_pack,
	ease_background_colour = function(self)
		ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
	end,
	create_UIBox = function(self)
		return create_UIBox_spectral_pack()
	end,
	particles = function(self)
		G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
			timer = 0.015,
			scale = 0.1,
			initialize = true,
			lifespan = 3,
			speed = 0.2,
			padding = -1,
			attach = G.ROOM_ATTACH,
			colours = { G.C.RED, G.C.BLUE },
			fill = true,
		})
		G.booster_pack_sparkles.fade_alpha = 1
		G.booster_pack_sparkles:fade(1, 0)
	end,
	create_card = function(self, card, i)
		-- Get Jokers from Mult and Chip categories
		local n_card = create_card("Joker", G.pack_cards, nil, nil, true, true, nil, "mf_modded")
		return n_card
	end,
	group_key = "k_rgmc_variety_pack",
	cry_digital_hallucinations = {
		colour = G.C.PURPLE,
		loc_key = "k_plus_joker",
		create = function()
		end,
	},
	in_pool = function()
		return true
	end,
}

local list = {}

-- Add booster groups
local all_boosters = {}
MadLib.loop_func({
	boosters['cosma'],
	{ cogito },
	boosters['reward'],
	boosters['ruinous'],
	{
		chip_mult,
		revival,
		food,
		common,
		misprint,
		spam,
		madcap_select
	},
}, function(_list,i)
	MadLib.loop_func(_list, function(v, i)
		table.insert(all_boosters, v)
	end)
end)
Madcap.Funcs.LoadBoosters(all_boosters, list, 'boosters')

return {
	name = "Boosters",
	init = function() print("Boosters!") end,
	items = list,
}
