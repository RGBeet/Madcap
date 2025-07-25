
function mod_loaded(mod_id)
	return SMODS.find_mod(mod_id)
end

function print_debug_text(text,prefix)
	if not Madcap.Data.devmode then return false end
	local finished_text
	if type(text) == 'string' then
		finished_text = "[MADCAP] - "..(prefix and prefix..' ' or '')..(text or '???')
	else
		print(text)
		finished_text = "[MADCAP] - TEXT TYPE IS "..type(text)
	end
	print(finished_text)
end

-- Prints out a MADCAP message!
function tell(text)
   print_debug_text(text)
end

-- Prints out a MADCAP error.
function tell_error(text)
	print_debug_text(text..' - ERROR!')
	return false
end

-- Prints out a MADCAP stat. Foo: Bar
function tell_stat(text,stat)
    print_debug_text(text..": "..tostring(stat))
end

-- Prints out a MADCAP list.
function tell_list(text,list)
    print_debug_text(text..":")
    print(list)
end

Madcap = { Funcs = { }, JokerLists = { } }
mfuncs 	= Madcap.Funcs
mjokers	= Madcap.JokerLists

-- enabled type stuff
local mod_path = "" .. SMODS.current_mod.path       -- save the mod path for future usage!
MadcapConfig = SMODS.current_mod.config          	-- loading configuration
Madcap.enabled = copy_table(MadcapConfig)      		-- what is enabled?

Madcap.Orders = {
	Blind		= 0,
	Booster		= 0,
	Consumable	= 0,
	Deck		= 0,
	Edition		= 0,
	Enhancement = 0,
	Joker		= 0,
	Seal		= 0,
	Sleeve		= 0,
	Tag			= 0,
	Voucher		= 0,
}

Madcap.Lists = {
	Roshambo = { 'm_stone', 'm_lucky', 'm_steel' },
	Moons = {
		Mult = {
			'vulcanoid',
			'zoozve',
			'luna',
			'phobos',
			'europa',
			'titan',
			'umbriel',
			'triton',
			'nix',
			'planet_nine',
			'pallas',
			'dysnomia',
			'paper_weywot',
			'paper_namaka',
			'paper_ilmare',
			'paper_salacia',
		},
		Chips = {
			'phaethon',
			'2013_nd15',
			'kamooalewa',
			'deimos',
			'callisto',
			'iapetus',
			'oberon',
			'proteus',
			'charon',
			'nibiru',
			'2000_eu16',
			'kuiper',
			'paper_ixion',
			'paper_hiiaka',
			'paper_varda',
			'paper_mk2',
		}
	}
}
Madcap.Data = {
	seed		= 'rgmc', 	-- primary seed for random stuff
	devmode 	= true, 	-- When true, enables all the debug text and unfinished content.
	colors		= {
		-- seal colors
		PATINA			= HEX('49ab9a'),
		BRONZE			= HEX('754d42'),
		JADE			= HEX('226f4c'),
		CREAM			= HEX('ebe8bd'),
		UMBER			= HEX('b56622'),

		STONE 			= HEX('7A8087'),
		FERROUS 		= HEX('F5EAEA'),
		WOLFRAM 		= HEX('5C5C73'),
		LUSTROUS 		= HEX('7DD75A'),

		-- other
		HOT_PINK 		= HEX('FF0080'),		-- Madcap hot pink
	},
	enhancement_lists = {
		bonus = {
			'bonus',
			'stone',
			'rgmc_wolfram'
		},
		mult = {
			'mult',
			'lucky',
			'rgmc_wolfram'
		},
		x_mult = {
			'glass',
			'steel',
			'rgmc_lustrous'
		},
		money = {
			'gold',
			'lucky'
		},
	},
}

-- rarities are handled here because why not
SMODS.Rarity{ -- Unusual: not quite Epic Jokers, but not quite Legendary.
    key = "unusual",
    badge_colour = G.C.RGMC_UNUSUAL,
    polls = { ["Joker"] = { rate = 0 } },
}

SMODS.Rarity{ -- Unusual: not quite Epic Jokers, but not quite Legendary.
    key = "chaotic",
    badge_colour = G.C.RGMC_CHAOTIC,
    polls = { ["Joker"] = { rate = 0 } },
}

SMODS.Rarity{ -- Gimmick: used for Jokers not normally obtainable in regular decks.
    key = "gimmick",
    badge_colour = G.C.RGMC_GIMMICK,
    polls = { ["Joker"] = { rate = 0.5 } },
}

-- more flexible key path function
SMODS.load_file('lib/main.lua')()     		-- main functions\

function Madcap.Funcs.run_start()
    -- start of run
    tell('Run Start')


    --print('Ice Cream')
    --print(G.P_CENTERS['j_ice_cream'])
    --print('Caramel')
    --print(G.P_CENTERS['j_cry_caramel'])

    G.GAME.subhands = {}
    G.GAME.temp = {}

    for _,v in pairs(SubHands) do
        local k = v.name
        G.GAME.subhands[k] = {}
        G.GAME.subhands[k].level    	= 1
        G.GAME.subhands[k].mult     	= v.x_mult
        G.GAME.subhands[k].chips    	= v.x_chips
        G.GAME.subhands[k].l_mult   	= v.l_mult or 0.1
        G.GAME.subhands[k].l_chips  	= v.l_chips or 0.1
        G.GAME.subhands[k].enabled  	= false
        G.GAME.subhands[k].empowered  	= 0
    end

    G.GAME.MADCAP = {
        blinds_skipped      = 0,        -- number of blinds skipped
        boss_blinds         = 0,        -- number of boss blinds defeated
        showdown_blinds     = 0,        -- number of showdown blinds defeated
        x_value             = 10,       -- value of x cards (linked to wisteria chimes)
        temporary_hands     = 0,        -- hands you get when you run out
        temporary_discards  = 0,        -- discards you get when you run out
        last_enhancement    = nil,      -- used for chrome edition and ??? enhancement
        punisher_mode       = false,
        rank_dist           = nil,      -- used to see which
        force_poker_hand    = nil,      -- in case cryptid isnt here.
        pick_5              = nil,
        best_hand           = {
            score   = 0,
            hand    = {},   -- held in hand
            play    = {},   -- highlighted and played
            ante    = 0
        }
    }

    G.GAME.Mayhem 			= G.GAME.Mayhem or 0
    G.GAME.MayhemState 		= 0
    G.GAME.max_mayhem 		= G.GAME.max_mayhem or 10
    G.GAME.luxury_points 	= G.GAME.luxury_points or 0

    G.GAME.dead_jokers		= {}
    G.GAME.missed_jokers	= {}

    Madcap.Funcs.set_mayhem(G.GAME.Mayhem,true,true)

    G.GAME.Exotic = G.GAME.Exotic or false -- Used for exotic suits and ranks?

    Madcap.Funcs.ante_start() -- Since the game starts at the first ante...?
end

-- Upon selecting the blind...
function Madcap.Funcs.blind_start()
    -- start of blind
    tell('Blind Start')

	print(MadLib.SuitTypes.Light)
	print(MadLib.SuitTypes.Dark)
    G.GAME.MADCAP.rank_dist = MadLib.get_ranks_from_cards(G.playing_cards)

    local patina_cards, bronze_cards, normal_cards = {}, {}, {}
    local new_deck = {}

    -- Categorize the cards
    for i, card in ipairs(G.deck.cards) do

        if card.seal == 'rgmc_patina' then
            table.insert(patina_cards, { card = card, index = i })
        elseif card.seal == 'rgmc_bronze' then
            table.insert(bronze_cards, { card = card, index = i })
        else
            table.insert(normal_cards, { card = card, index = i })
        end
    end

    tell('Testing - we got ' .. tostring(G.GAME.MADCAP.rank_dist["King"]) .. 'Kings.')

    if #bronze_cards > 0 then
        tell('Bronze seals in deck.')
        -- Bias the movement of Bronze cards toward the back
        for _, entry in ipairs(bronze_cards) do
            local bias = math.max(0, (entry.index - 1) / #G.deck.cards) -- Higher bias if farther back
            local chance = 0.7 + 0.3 * bias -- More likely to move if near the end
            if math.random() < chance then
                table.insert(new_deck, 1, entry.card) -- Push toward front
            else
                table.insert(new_deck, entry.card) -- Keep some dispersion
            end
        end
    end

    if (#patina_cards + #bronze_cards) > 0 then
        tell('Bronze and/or Patina seals in deck.')
        -- Insert Normal cards throughout
        for _, entry in ipairs(normal_cards) do
            local pos = math.random(1, #new_deck + 1)
            table.insert(new_deck, pos, entry.card)
        end
    end

    if #patina_cards > 0 then
        tell('Patina seals in deck.')
        -- Bias the movement of Patina cards toward the front
        for _, entry in ipairs(patina_cards) do
            local bias = math.max(0, (#G.deck.cards - entry.index) / #G.deck.cards) -- Higher bias if near front
            local chance = 0.7 + 0.3 * bias -- More likely to move if near the front
            if math.random() < chance then
                table.insert(new_deck, entry.card) -- Push toward back
            else
                table.insert(new_deck, 1, entry.card) -- Keep some dispersion
            end
        end
    end

    if (#new_deck) > 0 then
        G.deck.cards = new_deck
    end
end

-- Upon winning the blind...
function Madcap.Funcs.blind_end()

    -- end of blind
    tell('Blind End')
    if
        G.GAME.blind
        and G.GAME.blind.boss
    then
        G.GAME.MADCAP.boss_blinds = G.GAME.MADCAP.boss_blinds + 1
        if G.GAME.blind.showdown then G.GAME.MADCAP.showdown_blinds = G.GAME.MADCAP.showdown_blinds + 1 end
    end

    if G.GAME.MADCAP.punisher_mode then
        G.GAME.MADCAP.punisher_mode = false
    end

end

-- Upon starting an ante
function Madcap.Funcs.ante_start()
    -- start of ante
    tell('Ante Start')

	local blinds = {'Small', 'Big', 'Boss'}

	G.GAME.MADCAP.ante = {
		hands			= 0,	-- hands played
		discards		= 0,	-- discards played
		purchases		= 0,	-- shop purchases / booster items chosen
		hand_types 		= {}, 	-- hand types played
		suits 			= {}, 	-- suits scored
		ranks			= {}, 	-- ranks scored
		unique_suits    = 0,
		unique_ranks    = 0,
		blind_values	= {},
		faces_scored	= 0,	-- face cards scored
		first_hand_type	= nil	-- first hand type (for madcap mouth)]]
	}

	local x_card = G.playing_cards and pseudorandom_element(G.playing_cards, pseudoseed('rgmc_x_value')) or nil -- pick a card, any card...
	G.GAME.MADCAP.x_value = x_card and x_card.base.value or "10" -- The rank becomes the x's rank


	if G.GAME.modifiers.rgmc_pale then
        -- check if the force has been defeated

        if -- antes 9, 17, 25, etc.
            G.GAME.round_resets.ante > G.GAME.win_ante
            and G.GAME.round_resets.ante % G.GAME.win_ante == 1
        then -- set the force chance
            G.GAME.modifiers.rgmc_force_chance = G.GAME.win_ante - 1
        elseif
            G.GAME.modifiers.rgmc_force_chance > 0 -- if set to <1, don't even bother
            and (pseudorandom(pseudoseed("rgmc_pale_force")) < ((G.GAME.probabilities.normal) / G.GAME.modifiers.rgmc_force_chance))
        then -- force reroll into the force
			G.GAME.round_resets.blind_choices.Boss = get_new_boss()
        else -- increase force chance
            G.GAME.modifiers.rgmc_force_chance = G.GAME.modifiers.rgmc_force_chance - 1
        end
	end
end

-- Upon ending an ante?
function Madcap.Funcs.ante_finish()
    -- end of ante
    tell('Ante End')

end

-- Upon starting a shop
function Madcap.Funcs.shop_start()
    -- start of shop
    tell('Shop Start')

end

-- Upon recording a singular card?
function Madcap.Funcs.record_card(card)
    -- recording card
    tell('Record Card')
end

-- Upon playing a hand...
function Madcap.Funcs.play_hand(hand)
    -- recording hand
    tell('Play Hand')
    G.GAME.MADCAP.ante.hands = G.GAME.MADCAP.ante.hands + 1
end

-- Upon discarding a hand...
function Madcap.Funcs.discard_hand(hand, chips, text)
    -- recording hand
    tell('Discard Hand')
    G.GAME.MADCAP.ante.discards = G.GAME.MADCAP.ante.discards + 1
end

-- Start of an Ante (function for the blinds)
function Blind:rgmc_ante_start()
	if not self.disabled then
		local obj = self.config.blind
		if obj.rgmc_ante_start and type(obj.rgmc_ante_start) == "function" then
            tell("Activate Ante Start")
			return obj:rgmc_ante_start()
		end
	end
end

-- When the player skips the blind on the UI
function Madcap.Funcs.blind_skip()
    -- start of blind
    tell('Blind Skip')
    G.GAME.MADCAP.blinds_skipped = G.GAME.MADCAP.blinds_skipped and G.GAME.MADCAP.blinds_skipped + 1 or 0
end

-- Record hand
function Madcap.Funcs.record_hand(hand, chips, text)

    local hand_type = G.GAME.MADCAP.ante.hand_types[text]
    tell(text)

    SMODS.calculate_context({ rgmc_total_score = chips })

    if not hand then return false end

    for i=1,#hand do
        local card = hand[i]

        -- rank type stuff
        if G.GAME.MADCAP.ante.ranks[card.base.value] == 0 then
            G.GAME.MADCAP.ante.unique_ranks = G.GAME.MADCAP.ante.unique_ranks + 1
        end

        -- suit type stuff
        if G.GAME.MADCAP.ante.suits[card.base.suit] == 0 then
            G.GAME.MADCAP.ante.unique_suits = G.GAME.MADCAP.ante.unique_suits + 1
        end

        G.GAME.MADCAP.ante.ranks[card.base.value]   = (G.GAME.MADCAP.ante.ranks[card.base.value] or 0) + 1
        G.GAME.MADCAP.ante.suits[card.base.suit]    = (G.GAME.MADCAP.ante.suits[card.base.suit] or 0) + 1
        G.GAME.MADCAP.ante.faces_scored = (G.GAME.MADCAP.ante.faces_scored or 0) + (card:is_face(true) and 1 or 0)

        if card.config.center ~= G.P_CENTERS.c_base then -- Last Enhancement played
            G.GAME.MADCAP.last_enhancement = card.config.center
        end
    end

    local current_score, high_score = to_big(chips), to_big(G.GAME.MADCAP.best_hand.score)

    if high_score < current_score then -- Update high score information
        G.GAME.MADCAP.best_hand = {
            score   = chips,
            hand    = MadLib.get_hand_info(G.hand.cards),
            play    = MadLib.get_hand_info(G.play.cards),
            ante    = G.GAME.round_resets.ante
        }
    end

    G.GAME.MADCAP.ante.hand_types[text] = G.GAME.MADCAP.ante.hand_types[text] or 0
    G.GAME.MADCAP.ante.hand_types[text] = G.GAME.MADCAP.ante.hand_types[text] + 1

    return true
end




-- Checks if it's time for EXOTICS (Goblets and Towers) - like in Bunco
function Madcap.Funcs.exotic_in_pool(suit)
    if G.GAME and G.GAME.Exotic then return true end

    --In case a Spectrum somehow gets played without enabling exotics, check directly:
    local spectrum_played = false
    if not (G and G.GAME and G.GAME.hands) then return false end

    for k, v in pairs(G.GAME.hands) do
        if string.find(k, "Spectrum", nil, true) then
            if G.GAME.hands[k].played > 0 then
                spectrum_played = true
                break
            end
        end
    end

    return spectrum_played
end

-- Used strictly by SMODS.calculate_main_scoring
function Madcap.Funcs.alter_score_order(card,scoring_hand,context,in_scoring)

    -- CONTINUUM: Scored 8s repeat all cards before it
    if
        #scoring_hand > 1               -- more than 1 card
        and card:get_id() == 8          -- scoring card is an 8
        and #SMODS.find_card('j_rgmc_continuum') > 0
    then -- 1 or more continuums

        local repeats = #SMODS.find_card('j_rgmc_continuum')
        local index, selection, cutoff = 1, nil, nil

        -- Score cards again until the original card is reached

        SMODS.score_card(card, context)

        for i=1, repeats do
            index = 1 -- go to start
            cutoff = #scoring_hand
            while
                index <= #scoring_hand   -- haven't gone through the whole thing
            do
                selection = scoring_hand[index]
                if selection == card and i == repeats then
                    break -- we're done here
                end
                SMODS.score_card(selection, context)
                index = (selection == card) and (#scoring_hand + 1) or (index + 1)
            end
        end
    end -- continuum ends

end

-- Hexa & Binary Joker yoink.
local get_id_use = false

-- Returns the rank for Rio.
function Madcap.Funcs.get_rio_rank()
    if not (G.GAME and G.GAME.MADCAP and G.GAME.MADCAP.rank_dist) then -- this should work, G.GAME.MADCAP is made on start
        return "Ace"
    end
    local minimum, selection = #G.deck.cards, nil
    local rank_values = { "Queen", "King", "Ace" }
    -- which is the lowest? if tie, prioritize by order
    for i=1, #rank_values do
        local thing, amt = rank_values[i], G.GAME.MADCAP.rank_dist[rank_values[i]] --tell("There are " .. tostring(amt) .. " of " .. tostring(thing) .. ".")
        if amt <= minimum then --tell("That is enough.")
            minimum = amt
            selection = rank_values[i]
        end
    end
    return selection --tell("Rio's really feeling like a "..selection)
end

local card_get_id_ref = Card.get_id
function Card:get_id()
	if not get_id_use then
		get_id_use = true

		local id = card_get_id_ref(self) or self.base.id

		if id == "rgmc_x" then -- x cards equal
            id = SMODS.Ranks[G.GAME.MADCAP.x_value].id
		end

		if -- Rio (legendary)
            next(SMODS.find_card('j_rgmc_legend_rio'))
            and id == 14
        then
            -- counts as either queen, king, or ace depending on which has fewest cards
            -- at start of blind (using G.GAME.MADCAP.rank_dist)
            id = SMODS.Ranks[Madcap.Funcs.get_rio_rank()].id
        end

        -- Sigma Joker
        if id == "rgmc_sum" then -- equals number cards in playing hand
            local _, _2, _3, scoring = G.FUNCS.get_poker_hand_info(G.play.cards)
            if next(SMODS.find_card('j_splash')) then scoring  = G.play.cards end
            id = Madcap.Funcs.get_hand_sigma(scoring)
		end

		get_id_use = false
		return id
	else
		get_id_use = false
		return card_get_id_ref(self)
	end

end

-- Simple way to get a random element from list.
function Madcap.Funcs.get_random_from_list(list, seed)
    return pseudorandom_element(list, pseudoseed(seed or Madcap.seed))
end

-- Returns the number of cards in a group that have a specified suit.
function Madcap.Funcs.count_suit(group,target)
	local number = 0
	for i = 1, #group do
		if group[i]:is_suit(target) and not group[i]:nosuit() then number = number + 1 end
	end
	return number
end

-- TODO: deprecate.
function Madcap.Funcs.count_total_suits(group)
	local number, list = 0, {}
	for i = 1, #group do
        local suit = group[i].base.suit
        if not list[suit] then
            list[suit] = true
            number = number + 1
        end
	end
	return number
end

-- Takes a card and returns whether the card's rank id falls within the list of rank ids.
function Madcap.Funcs.card_rank_in_list(card,list)
	for i=1, #list do
		if
			list[i] == card.base.value
			and not card:norank()
		then
			return true
		end
	end
	return false
end

-- Takes a card and returns whether the card's suit id falls within the list of suit ids.
function Madcap.Funcs.card_suit_in_list(card,list)
	for i=1, #list do
		if
			list[i] == card.base.suit
			and not card:nosuit()
		then
			return true
		end
	end
	return false
end

-- Used for new deck music.
function Madcap.Funcs.is_playing_blind()
    return G.STATE == G.STATES.SELECTING_HAND
    or G.STATE == G.STATES.DRAW_TO_HAND
    or G.STATE == G.STATES.HAND_PLAYED
    or G.STATE == G.STATES.PLAY_TAROT
    or G.STATE == G.STATES.GAME_OVER
    or G.STATE == G.STATES.BLIND_SELECT
    or G.STATE == G.STATES.ROUND_EVAL
    or G.STATE == G.STATES.MENU
    or G.STATE ==  G.STATES.NEW_ROUND
end

-- Is choosing a card. (Used for music!)
function Madcap.Funcs.is_choosing_card()
    return G.STATE == G.STATES.TAROT_PACK
        or G.STATE == G.STATES.PLANET_PACK
        or G.STATE == G.STATES.SPECTRAL_PACK
        or G.STATE == G.STATES.STANDARD_PACK
        or G.STATE == G.STATES.BUFFOON_PACK
        or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
end

-- Is choosing a Celestial / Spectral pack. (Used for music!)
function Madcap.Funcs.is_choosing_celestial()
    return G.STATE == G.STATES.PLANET_PACK
        or G.STATE == G.STATES.SPECTRAL_PACK
end

function Madcap.Funcs.get_boss_status()
    return
        not (G.GAME.blind
        and G.GAME.blind.boss)
    and 0 or
        Madcap.Funcs.is_finisher_ante()
    and 2 or 1
end

function Madcap.Funcs.is_finisher_ante()
	return G.GAME.round_resets.ante % G.GAME.win_ante == 0
end

-- From Cryptid
Madcap.Funcs.safe_get = MadLib.safe_get


Madcap.Funcs.generate_special_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)


    if not card or not card.ability then return end

    --[[
    if card.ability.subtitle then
        if #card.ability.subtitle > 1 then
            local _subtitle_string = ""

            for i = 1, #card.ability.subtitle do
                if i == 1 then
                    _subtitle_string = _subtitle_string .. card.ability.subtitle[i]
                else

                    _subtitle_string = _subtitle_string .. ", " .. card.ability.subtitle[i]
                end
            end
        end
    end]]



    full_UI_table.name = {
        {
            n = G.UIT.C,
            config = { align = "cm", padding = 0.05 },
            nodes = {
                {
                    n = G.UIT.R,
                    config = { align = "cm" },
                    nodes = full_UI_table.name
                },
            }
        }
    }

    local place = full_UI_table.name[1].nodes

    if card.config.center.long_title then
        for i=1,#card.config.center.long_title do
            local line = tostring(card.config.center.long_title[i])
            place[#place+1] =
            {
                n = G.UIT.R,
                config = { align = 'cm'},
                nodes = Madcap.Funcs.make_long_title_line(line)
            }
        end
    end
end

-- used to make fake titles that are absurdly long
Madcap.Funcs.make_long_title_line = function(text)
    local _full_text = text or "NULL"
    local _scale_base = 1.0
    return {{
        n = G.UIT.O,
        config = {
            object = DynaText({
                    string      = { _full_text },
                    colours     = { G.C.WHITE },
                    bump        = true,
                    silent      = true,
                    pop_in      = 0,
                    pop_in_rate = 4,
                    maxw        = 5,
                    shadow      = true,
                    y_offset    = 0,
                    spacing     = math.max(0, 0.32 * (17 - #_full_text)),
                    scale       = (0.4 - 0.004* #_full_text) * _scale_base
            })
        }
    }}
end

function Madcap.Funcs.get_mayhem()
	return G.GAME and G.GAME.Mayhem or 0
end

function Madcap.Funcs.get_max_mayhem()
	return G.GAME and G.GAME.max_mayhem or 10
end

function Madcap.Funcs.get_mayhem_state()
	return G.GAME and G.GAME.MayhemState or 0
end

function Madcap.Funcs.ease_mayhem(_mod, _check, _silent, _instant)
    MadLib.simple_event(function()
        local round_UI = G.HUD:get_UIE_by_ID('mayhem_UI_count')
        local add_mayhem, lose_mayhem = to_big(mod) > to_big(0), to_big(mod) < to_big(0)
        local text  = add_mayhem and '+' or ''
        local col   = (add_mayhem and G.C.RGMC_MAYHEM) or (lose_mayhem and G.C.RED) or G.C.FILTER

        _mod = _mod or 0
		local _old = G.GAME.Mayhem
        G.GAME.Mayhem = (G.GAME.Mayhem or 0) + _mod
        if G.GAME.Mayhem + _mod > G.GAME.max_mayhem then _mod = G.GAME.max_mayhem - (G.GAME.Mayhem + _mod) end

        if round_UI then
            G.HUD:recalculate()
            if not Talisman.config_file.disable_anims then
                attention_text({
                    text            = text .. tostring(math.abs(_mod)),
                    scale           = 1,
                    hold            = 0.7,
                    cover           = round_UI.parent,
                    cover_colour    = col,
                    align           = 'cm',
                })
            end
        end

		local _new = (_old + mod)
		local mayhem_state = (_new > 9 and 3)
			or (_new > 6 and 2)
			or (_new > 3 and 1)
			or 0

		if mayhem_state ~= G.GAME.MayhemState then
			G.GAME.MayhemState = mayhem_state
		end

        --Play a SPOOKY noise sound
        if (not Talisman.config_file.disable_anims) and (not _silent) then
            if lose_mayhem then
                play_sound('rgmc_mayhem_down', 0.8)
                play_sound('timpani')
			elseif add_mayhem then
				if mayhem_state ~= nil then
					play_sound('rgmc_mayhem_t' .. tostring(state_up), 0.8)
					delay(2.0)
				else
					play_sound('timpani')
					play_sound('rgmc_mayhem_up', 0.8)
				end
            end
        end

        SMODS.calculate_context({ mayhem_changed = G.GAME.Mayhem })
        if _check then Madcap.Funcs.read_mayhem() end -- does post-setting calculations (if requested)
        return true
    end, 0.5, 'immediate')
    return true
end

function Madcap.Funcs.get_end_of_round(context)
    return context and context.end_of_round
        and not context.blueprint
        and not context.individual
        and not context.repetition
        and not context.retrigger_joker
end

function Madcap.Funcs.set_mayhem(_mod, _check, _silent,_instant)
    local _diff = (_mod or G.GAME.Mayhem) - G.GAME.Mayhem
    return Madcap.Funcs.ease_mayhem(_diff, _check, _silent, _instant)
end

-- Add Remove Joker to contexts
local sd = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
    if G.GAME.MADCAP then
        SMODS.calculate_context({ remove_joker = self })
    end
    return sd(self,a,b,c,d)
end


-- General function for setting temporary stickers (which Madcap incorporates a lot of!)
function Card:set_temp_sticker(id,bool,tally)
    self.ability[id]                = bool
    self.ability[id .. '_tally']    = tally or 1
	SMODS.Stickers[id]:apply(self,bool)
end

function Card:set_rgmc_engraved(bool,tally)
    self:set_temp_sticker('rgmc_engraved',bool,tally or 3)
end

function Card:set_rgmc_shielded(bool,tally)
    self:set_temp_sticker('rgmc_shielded',bool,tally or 3)
end

function Card:set_rgmc_twinkling(bool,tally)
    self:set_temp_sticker('rgmc_twinkling',bool,tally or 1)
end

function Card:set_rgmc_painted(_painted,tally)
    self:set_temp_sticker('rgmc_painted',bool,tally or 1)
end

-- A handy little sticker
local function handle_sticker_calculation(self,id,eval)
    local name      = id
    local tally     = name .. '_tally'

    if
        self.ability[name]
        and self.ability[tally] > 0
    then
        if -- if the tally is about to go to 0
            self.ability[tally] <= 1
        then
            self.ability[tally] = 0
            -- if in hand, show the sticker coming off
            for i=1, #G.hand.cards do
                if
                    G.hand.cards[i] == self
                then -- show it coming off
                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = localize('k_' .. (eval or 'removed_ex')),
                        colour = G.C.FILTER,
                        delay = 0.45
                    })
                    break -- we are done
                end
            end
            self.ability[name] = false
            SMODS.Stickers[name]:apply(self,false)
        else
            self.ability[tally] = self.ability[tally] - 1
            for i=1, #G.hand.cards do
                if
                    G.hand.cards[i] == self
                then -- show the countdown
                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = localize {
                            type    = 'variable',
                            key     = 'a_remaining',
                            vars    = { self.ability[tally] }
                        },
                        colour = G.C.FILTER,
                        delay = 0.45
                    })
                    break
                end
            end
        end
    end
end

function Card:calculate_rgmc_engraved()
    handle_sticker_calculation(
        self,
        'rgmc_engraved',
        'rgmc_enabled_ex'
    )
end

function Card:calculate_rgmc_shielded()
    handle_sticker_calculation(
        self,
        'rgmc_shielded',
        'rgmc_shield_removed_ex'
    )
end

-- TODO: maybe make it so it can be twinkling more than 1 round?
function Card:calculate_rgmc_twinkling()
    handle_sticker_calculation(
        self,
        'rgmc_twinkling'
    )
    self:set_edition(nil,true,true)
end

function Card:calculate_rgmc_painted()
    handle_sticker_calculation(
        self,
        'rgmc_painted'
    )
    self:set_ability(G.P_CENTERS.c_base)
end


local start_run_ref = Game.start_run

function Game:start_run(args)
    start_run_ref(self, args)

end



Madcap.CardReturnList = {
	{ id = 'coil',
		to 		= hand,
		dir 	= 'down',
		sort 	= true,
	},
	{ id = 'jade',
		to 		= G.deck,
		dir 	= 'down',
		sort 	= true,
	}
}

local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)

	-- Check if the card has any configs altering the card drawing
	local _id = nil
	for i=1, #Madcap.CardReturnList do
		if card and card.ability['rgmc_' .. Madcap.CardReturnList[i].id] then
			_id = Madcap.CardReturnList[i]
			break
		end
	end

	if _rvals then
		to 		= _rvals.to or to
		dir 	= _rvals.dir or dir
		sort 	= _rvals.sort or sort
		card.ability['rgmc_'.._rvals.id] = nil
    end

    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

function Madcap.Funcs.do_tables_match(a,b)
	return table.concat(a) == table.concat(b)
end

Madcap.CheckJokerOrder = false
local node_stop_drag_ref = Node.stop_drag
function Node:stop_drag()
	node_stop_drag_ref(self)
end

function Madcap.Funcs.handle_glass_card_scoring(card)

    local dead = not card.debuff and pseudorandom('glass') < G.GAME.probabilities.normal/card.ability.extra

    if
        find_joker("rgmc_glass_michel")
        and self.ability.glass_michel
    then
        tell('Glass Michel Time')
        -- Tells you if the card would've otherwise been killed
        if dead then
            card_eval_status_text(self,'extra',nil,nil,nil,{
                message = localize('k_safe_ex')
            })
            return false
        end
    end

    return dead -- if the card would be dead, then let the game know
end

-- Enables/disables special suits (cups/shields)
function Madcap.Funcs.set_special_suits(x)
    if G.GAME then G.GAME.Exotic = (x or false) end
    tell('Triggered Exotic System enabling.')
end

function Madcap.Funcs.get_default_attention_hold(text)
    return G.SETTINGS.GAMESPEED * (#text * 0.02 + 1.3)
end
-- Returns a random rank within the nominal values listed - if no values are set, any rank can be returned.
function Madcap.Funcs.get_random_rank(a,b)
	local chosen, tries = false, 0
	local rank = nil
	local min_nominal, max_nominal = a or -100, b or 100
	while not chosen and tries < 100 do
        rank = pseudorandom_element(SMODS.Ranks, pseudoseed('random_rank'))
		tries = tries + 1
		local nominal = rank.nominal
		if nominal >= min_nominal and nominal <= max_nominal then
			chosen = true
		end
	end
	return rank
end

function Madcap.Funcs.get_random_rank_in_group(deck)
    local pick_card = pseudorandom_element(deck, pseudorandom('rgmc'))
    return SMODS.Ranks[pick_card.base.value]
end

function Madcap.Funcs.get_randomest_rank()
    return pseudorandom_element(SMODS.Rank, pseudorandom('rgmc'))
end


function Madcap.Funcs.add_booster_to_shop(key, params)

    local p = params or {}

    if key then assert(G.P_CENTERS[key], "Invalid booster key: "..key) else key = get_pack('shop_pack').key end

    local card = Card(
        G.shop_booster.T.x + G.shop_booster.T.w/2,
        G.shop_booster.T.y,
        G.CARD_W*1.27, G.CARD_H*1.27,
        G.P_CARDS.empty,
        G.P_CENTERS[key],
        {bypass_discovery_center = true, bypass_discovery_ui = true}
    )

    create_shop_card_ui(card, 'Booster', G.shop_booster)

    card.ability.booster_pos = #G.shop_booster.cards + 1

    card.ability.choose = math.random(p.choose_min or 1, p.choose_max or 2)
    card.ability.extra = math.random(p.extra_min or 0, p.extra_max or 1)

    card.cost = 0	-- always free... you earned it queen

    card:start_materialize()

    G.shop_booster:emplace(card)
    return card
end


function Madcap.Funcs.get_common_jokers(r)
    if not G.jokers or not G.jokers.cards then
        return 0
    end
    local count = 0
    for i, jok in ipairs(G.jokers.cards) do
        if jok.config.center.rarity == (r or 1) then
            count = count + 1
        end
    end
    return count
end

local ease_dollars_ref = ease_dollars
function ease_dollars(mod, instant)
	tell('Easing moment')
	if
		G.GAME.modifiers.bankrupt_kill
        and (G.GAME.dollars + mod) <= G.GAME.bankrupt_at
	then
		MadLib.event({
			func = function()
				tell('You are now bankrupt.')
				play_area_status_text("BANKRUPT!")
			return true
			end,
			delay 	= 5.0,
			trigger = 'immediate',
		})
		MadLib.event({
			func = function()
				if G.STAGE == G.STAGES.RUN then
					G.STATE = G.STATES.GAME_OVER
					G.STATE_COMPLETE = false
				end
			return true
			end,
			delay 	= 1.0,
			trigger = 'after',
		})
	end

	return ease_dollars_ref(mod, instant)
end

-- APPLY SEAL TO RANDOM
-- Applies a seal to a random card from a specified card area # times
function Madcap.Funcs.apply_seal_to_random(seal, times, context, cardarea)
    local temp_hand = {}

    -- Add to temporary hand (to shuffle)
    for i = 1, #cardarea.cards do temp_hand[#temp_hand + 1] = cardarea.cards[i] end

    for i = 1, times do
        pseudoshuffle(temp_hand, pseudoseed('rgmc_random_seal'))
        for i = 1, #temp_hand do
            if
                temp_hand[i] ~= context.other_card
                and temp_hand[i].seal == nil
            then
                temp_hand[i]:set_seal(seal, true, true)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        temp_hand[i]:juice_up(0.5, 0.7)
                    return true end
                }))
                break
            end
        end
    end
end

-- CARD IS RANKLESS SUITLESS
-- Used for rankless/suitless cards such as Stone, Abstract, and Bismuth
function Madcap.Funcs.card_is_rankless_suitless(card)
    return SMODS.has_no_suit(card)
    or SMODS.has_enhancement(card, "m_cry_abstract") -- abstract card
end


-- GET BLINDS PER ANTE
-- used to determine whether we are at the last blind of the ante?
function Madcap.Funcs.get_blinds_per_ante()
	return 3
end






-- From JenLib - used to determine whether the card has no suit.
function Card:nosuit()
    return SMODS.has_enhancement(self, "m_stone")
		or SMODS.has_enhancement(self, "m_rgmc_bismuth")
		or self.config.center.no_suit
end




-- Gets the nominal ranks of all regular ranks in the group (usually G.hand.cards).
-- Used for the Sum rank.
function Madcap.Funcs.get_hand_sigma(group)
	local total = 0
    for _, v in ipairs(group) do
        if not (SMODS.has_no_rank(v) or v:rank_in_list(MadLib.RankTypes.Irregular))  then
            local rank = SMODS.Ranks[v.base.value]
            total = total + rank.nominal
        end
    end
	return total
end

-- Get the "hand sum" for cards such as All-Star Joker
function MadLib.get_hand_sum(hand, count_irregulars)
	local total = 0
    for _, v in ipairs(hand) do
        if
			not SMODS.has_no_rank(v)
			and not ((not count_irregulars) and v:rank_in_list(MadLib.RankTypes.Irregular))
		then
			local rank = SMODS.Ranks[v.base.value]
			total = total + rank.nominal
		elseif v:get_id() == 'rgmc_x' then -- X rank gives a random value
			total = total + G.GAME.MADCAP.x_value
		elseif count_irregulars then
			if v:get_id() == 'rgmc_sum' then -- sum gives sum of deck sans irregulars
				total = Madcap.Funcs.get_hand_sigma(hand) -- do not count irregulars
			end
        end
    end
	return total
end

function Madcap.Funcs.less_than(a,b,equals)
    if equals then
        return to_big(a) <= to_big(b)
    else
        return to_big(a) < to_big(b)
    end
end

function Madcap.Funcs.greater_than(a,b,equals)
    if equals then
        return to_big(a) >= to_big(b)
    else
        return to_big(a) > to_big(b)
    end
end

-- Target Deck: create a reward tag.
function Madcap.Funcs.create_target_deck_reward(list,id)
    local boosty = list[math.random(1, #list)]

    local t = Tag(id, nil)
    add_tag(t)

    G.GAME.tags[#G.GAME.tags].config.extra.booster_type = boosty
end

-- Decks: Initializes base values.
function Madcap.Funcs.init_deck(id,params)
    G.GAME.modifiers.rgmc_deck = {}
    G.GAME.modifiers.rgmc_deck[id] = true

    if params then
        for k,v in pairs(G.GAME.modifiers.rgmc_deck) do G.GAME.modifiers.rgmc_deck[k] = v end
    end
end

--SMODS.load_file('lib/overrides.lua')()     	-- overrides


--Init stuff at the start of the game
local gigo = Game.init_game_object
function Game:init_game_object()
	local G = gigo(self)
	-- Add initial dropshot and number blocks card
	G.current_round.rgmc_barbershop = { suit = "Spades" }
	G.current_round.rgmc_edwin_card = { rank = "5", suit = "Hearts" }

	-- Create G.GAME.events when starting a run, so there's no errors
	G.events = {}
	G.jokers_sold = {}
	return G
end

-- Calculate individual effect fixing
if SMODS and SMODS.calculate_individual_effect then
	local cie = SMODS.calculate_individual_effect
	function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		if
			( key == "x_mult"
				or key == "xmult"
				or key == "Xmult"
				or key == "x_mult_mod"
				or key == "xmult_mod"
				or key == "Xmult_mod")
			and amount ~= 1
		then

			-- Squeezy Cheeze
			local list = SMODS.find_card('j_rgmc_squeezy_cheeze')

			for _, v in pairs(list)do
				--tell("SQUEEZY CHEEZE ACTIVATED - "..tostring(amount))
				-- adds the mult to the joker

				v.ability.extra.xmult_store = lenient_bignum(to_big(v.ability.extra.xmult_store) + to_big(amount))

				if v.ability.extra.xmult_store > 1 then
				tell("New xmult_store is "..lenient_bignum(v.ability.extra.xmult_store))
					local m = 0
					while (v.ability.extra.xmult_store - 1) > 0 do
						v.ability.extra.xmult_store = v.ability.extra.xmult_store - 1 -- go down bith
						-- uhhh
						m = m + 1
					end

					local xm = 1 + v.ability.extra.xchip_mod * m
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound("tarot2")
							v:juice_up()
							return true
						end
					}))

					card_eval_status_text(v, "extra", nil, nil, nil, {
						message = localize({
							type = "variable",
								key = "a_xchips",
								vars = { number_format(xm) },
							}),
						colour = G.C.CHIPS,
					})

					--hand_chips = mod_chips(to_big(hand_chips) * to_big(xm)) -- stupid way of doing x1.5 chips
					tell(to_big(hand_chips))
				end
			end
		end

		local ret = cie(effect, scored_card, key, amount, from_edition)
		if ret then return ret end
	end
end


-- reset_castle_card hook for things like Dropshot and Number Blocks
-- Also exclude specific ranks/suits (such as abstract cards)
-- taken from cryptid, it's a really solid way of doing start of round shit
local rcc = reset_castle_card
function reset_castle_card()
	rcc()

	-- neighborhood watch
	G.GAME.current_round.rgmc_edwin_card = { rank = "5", suit = "Hearts" }
	G.GAME.current_round.rgmc_wizard_card = { rank = "9", suit = "Spades", rank_discovered = false, suit_discovered = false }

	-- barbershop joker
	G.GAME.current_round.rgmc_barbershop = { suit = nil, order = {} }

	local valid_castle_cards = {}
    for k, v in ipairs(G.playing_cards) do
		if not Madcap.Funcs.card_is_rankless_suitless(v) then valid_castle_cards[#valid_castle_cards + 1] = v end
	end

	if valid_castle_cards[1] then -- there are cards with ranks and suits
		-- Neighborhood Watch (Edwin)
		local castle_card = pseudorandom_element(valid_castle_cards, pseudoseed("rgmc_neighborhood_watch" .. G.GAME.round_resets.ante))
		if not G.GAME.current_round.rgmc_edwin_card then G.GAME.current_round.rgmc_edwin_card = {} end
		G.GAME.current_round.rgmc_edwin_card.suit  = castle_card.base.suit
		G.GAME.current_round.rgmc_edwin_card.rank  = castle_card.base.value
		G.GAME.current_round.rgmc_edwin_card.id    = castle_card.base.id

		-- make this end of ante later
		local castle_card2 = pseudorandom_element(valid_castle_cards, pseudoseed("rgmc_conspiracy_wizard" .. G.GAME.round_resets.ante))
		if not G.GAME.current_round.rgmc_edwin_card then G.GAME.current_round.rgmc_edwin_card = {} end
		G.GAME.current_round.rgmc_edwin_card.suit  = castle_card.base.suit
		G.GAME.current_round.rgmc_edwin_card.rank  = castle_card.base.value
		G.GAME.current_round.rgmc_edwin_card.id    = castle_card.base.id
	end

	-- This is for the Barbershop Joker
	G.GAME.current_round.rgmc_barbershop.changed = false
    G.GAME.current_round.rgmc_barbershop.index = G.GAME.current_round.rgmc_barbershop.index or 1

    local suit_set = {}
    for _, v in ipairs(G.playing_cards) do
        if not v:nosuit() then
            suit_set[v.base.suit] = true
        end
    end

    local suits = {}
    for suit, _ in pairs(suit_set) do
        table.insert(suits, suit)
    end

    -- Sort to ensure a defined order before shuffling (optional)
    table.sort(suits)

    -- Ensuring a structured shuffle (rotated shuffle approach)
    local seed = pseudoseed('rgmc_barbershop_joker'..tostring(G.GAME.round_resets.ante)..tostring(G.GAME.round_resets.ante))

    -- Assign the shuffled order
    pseudoshuffle(suits,seed)
    G.GAME.current_round.rgmc_barbershop.order = suits

    -- Ensure rgmc_barbershop.index is valid before accessing suits
    local index = G.GAME.current_round.rgmc_barbershop.index or 1
    if index < 1 or index > #suits then index = 1 end  -- Default to 1 if out of bounds

    G.GAME.current_round.rgmc_barbershop.suit = G.GAME.current_round.rgmc_barbershop.order[index]

end

-- Glass Michel better work.
local crdsht = Card.shatter
function Card:shatter()
	-- if sticker prevents it?
	if find_joker("rgmc_glass_michel") then
		return { message = localize("k_safe_ex") }
	else -- not safe!
		crdsht()
	end
end

-- temporary discard addition
local ease_discard_ref = ease_discard
function ease_discard(mod, instant, silent)
	ease_discard_ref(mod,instant,silent)
	tell_stat('discards',G.GAME.current_round.discards_left)
    if
        G.GAME.current_round.discards_left + mod == 0
        and G.GAME.MADCAP.temporary_discards > 0
    then
        ease_discard(1, instant, silent)
        G.GAME.MADCAP.temporary_discards = G.GAME.MADCAP.temporary_discards - 1
		local words = localize("rgmc_temp_discard_minus_ex")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = Madcap.Funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
    end
end

-- temporary hand addition
local ease_hands_played_ref = ease_hands_played
function ease_hands_played(mod, instant)
	ease_hands_played_ref(mod,instant)
	tell_stat('hands',G.GAME.current_round.hands_left)
    if
        G.GAME.current_round.hands_left + mod == 0
        and G.GAME.MADCAP.temporary_hands > 0
    then
        ease_hands_played(1, instant, silent)
        G.GAME.MADCAP.temporary_hands = G.GAME.MADCAP.temporary_hands - 1
		local words = localize("rgmc_temp_hand_minus_ex")
		attention_text({
			scale = 0.7,
			text = words,
			maxw = 12,
			hold = Madcap.Funcs.get_default_attention_hold(words),
			align = 'cm',
			offset = {x = 0, y = -1},
			major = G.play
		})
    end
end

-- Setting the cost of the card, likely for the shop?
local card_set_cost_ref = Card.set_cost
function Card:set_cost()
    local ret = card_set_cost_ref(self)

    if self.ability.rgmc_engraved then
        self.sell_cost = -1 -- bad luck!
    end

    if self.ability.rgmc_shielded then
        self.sell_cost = math.floor(self.sell_cost / 2) -- stickers reduce sell value regardless
    end

    return ret
end

local get_new_boss_ref = get_new_boss
function get_new_boss()
	-- Some Madcap decks have set finishers
	if
		G.GAME.MADCAP
		and G.GAME.MADCAP.deck_finishers 		-- has a deck finisher list
		and G.GAME.round_resets.ante > 0	-- dont do it ante 0 or earlier :(
		and G.GAME.round_resets.ante % G.GAME.win_ante == 0
	then
		local yes_please = G.GAME.round_resets.ante <= G.GAME.win_ante

		if not yes_please then -- past ante 8
			if MadLib.calculate_roll({
				seed 	= 'rgmc_finisher',	-- finisher seed
				numer 	= 1,	-- hardcoded 1 in 3, as to avoid stupidity
				denom 	= 3
			}) then
				yes_please = true -- 1 in 3 chance to do the thing
			end
		end

		if yes_please then
			local eligible_bosses = {}

			for _, v in pairs(G.GAME.MADCAP.deck_finishers) do -- might be more than one
				eligible_bosses[v] = true
			end

			local _, boss = Madcap.Funcs.get_random_from_list(eligible_bosses)
			return boss or "bl_final_vessel" -- evil
		end
	end

	-- Pale Deck: The Force appears more often.
	if G.GAME.modifiers.rgmc_pale then
		if G.GAME.modifiers.rgmc_force_awakened then -- Force chance activated
			return "bl_rgmc_force"
		end
	end

	-- Punisher Tag: rerolls boss blind into finisher blind.
	if G.GAME.MADCAP.force_finisher_blind then
		G.GAME.MADCAP.force_finisher_blind = nil -- dont need this anymore

		local blind, is_showdown = G.P_BLINDS[G.GAME.round_resets.blind_choices["Boss"]], false
		if blind.boss and blind.boss.showdown then is_showdown = true end -- if showdown blind
		local eligible_bosses = {}

		for k, v in pairs(G.P_BLINDS) do
			if v.boss and v.boss.showdown then eligible_bosses[k] = true end
		end

		for k, v in pairs(G.GAME.banned_keys) do
			if eligible_bosses[k] then eligible_bosses[k] = nil end
		end

		-- TODO: showdowns reroll into specific superbosses or DX blinds?
		return new_boss
	end

	-- if not punishing, just carry on as usual!
	return get_new_boss_ref()
end


-- Used for Sangria Deck
local deck_apply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(self)
    deck_apply_to_run_ref(self)

    if
        self.effect.config.starting_suits
        and not self.effect.config.starting_ranks 	-- No starting ranks, only affects suits
    then
        local size = #self.effect.config.starting_suits -- number of suits
        local suits = self.effect.config.starting_suits -- the list of suits
        local doubles = self.effect.config.starting_suits_doubles or false

        local ranks = 13                -- number of starting ranks available (usually 13)
        local deck_size = ranks * size  -- deck size

        if doubles then
            for i = #suits, 1, -1 do
                suits[#suits+1] = suits[i]
            end
            table.sort(suits, cmp)
            deck_size = deck_size * 2 -- double that shit
        end

        -- do the suit shit i guess
        G.E_MANAGER:add_event(Event({
            func = function()

                -- modify existing cards
                for i = #G.playing_cards, 1, -1 do
                    if i > deck_size then
                        G.playing_cards[i]:start_dissolve(nil, true)
                    else
                        local m = math.ceil(i/ranks)
                        --tell_stat('SUIT',suits[m])
                        G.playing_cards[i]:change_suit(suits[m])
                    end
                end

                if #G.playing_cards < deck_size then
                    local difference = (#G.playing_cards - deck_size)

                    for i = difference, 1, -1 do
                        local m = math.ceil(#G.playing_cards/ranks)

                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local _card = copy_card(G.playing_cards[i])
                        --tell_stat('SUIT',suits[m])
                        G.playing_cards[i]:change_suit(suits[m])

                        _card:add_to_deck()
                    end
                end

                return true
            end
        }))
    elseif
        self.effect.config.starting_suits		-- Specified starting suits and ranks
        and self.effect.config.starting_ranks
    then
        local suit_size = #self.effect.config.starting_suits -- number of suits
        local suit_list = self.effect.config.starting_suits -- the list of suits

        local rank_size = #self.effect.config.starting_ranks -- number of ranks
        local rank_list = self.effect.config.starting_ranks -- the list of ranks

        local deck_size = suit_size * rank_size

        local rank_index 	= 1
        local suit_index 	= 1
        local total 		= 0

        local suit_index, rank_index, total = 1, 1, 0
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1,#G.playing_cards do
                    local _rank = rank_list[rank_index]
                    local _suit = suit_list[suit_index]
                    assert(SMODS.change_base(G.playing_cards[i], _suit, _rank))

					suit_index 	= suit_index + 1
					total 		= total + 1

					if suit_index > suit_size then
						suit_index	= 1
						rank_index	= rank_index + 1
					end

					if rank_index > rank_size then break end
                end


                for i = 1, (deck_size - total) do
                    local _rank = rank_list[rank_index]
                    local _suit = suit_list[suit_index]

					local _card = copy_card(G.playing_cards[1])
					_card:add_to_deck()
                    assert(SMODS.change_base(_card, _suit, _rank))
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)

					suit_index 	= suit_index + 1
					total 		= total + 1

					if suit_index > suit_size then
						suit_index	= 1
						rank_index	= rank_index + 1
					end

					if rank_index > rank_size then break end
                end

                return true
            end
        }))
    end
end

-- Levelling up hands shenanigans
local level_up_hand_ref = level_up_hand
function level_up_hand(card, hand, instant, amount, context)

	if
		to_big(amount) > to_big(0)
	then -- actually levelling up the hand

		if  -- Rocket Keychain: using specific Planet card levels up most played hand as well!
			#SMODS.find_card('j_rgmc_rocket_keychain') > 0
		then
			-- loop thru
			for k, v in ipairs(G.jokers.cards) do
				if
					v.config.center.key == 'j_rgmc_rocket_keychain'
				then
					if hand == v.ability.extra.target_hand then
						level_up_hand_ref(card, MadLib.get_most_played_hand(), instant, v.ability.extra.level_ups)
					end
				end
			end
		end
	end

	level_up_hand_ref(card, hand, instant, amount)
end

-- Some stickers prevent debuffs
local set_debuff_ref = Card.set_debuff
function Card:set_debuff(should_debuff)
    if
		(self.edition and self.edition.rgmc_flipped and next(find_joker("rgmc_streemerz"))) -- Streemerz
		and not self.ability.shielded 			-- shielded cannot be debuffed
		and not self.ability.engraved       -- this would be too easy
		and not self.ability.painted 		-- painted cannot be debuffed because paint is cool
	then
		return
	end
	set_debuff_ref(self, should_debuff)
end


-- Some stickers prevent death
local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(...)
    if
		(self.edition and self.edition.rgmc_flipped and next(find_joker("rgmc_streemerz"))) -- Streemerz
	 	or (self.ability.shielded 			-- shielded cannot be killed
		or self.ability.twinkling) 		-- twinkling cannot be killed, because plot armor
	then
		print("Piss off")
        return
    end

    return start_dissolve_ref(self, ...)
end

local function animate_deck_sprite(atlas_id,deck_id)
	for k, v in pairs(G.I.CARD) do
		if v.children.back and v.children.back.atlas.name == "rgmc_deck_lunacy" then
			v.children.back:set_sprite_pos(G.P_CENTERS['b_rgmc_lunacy'].pos or G.P_CENTERS['b_red'].pos)
		end
	end
end

AnimatedJokers = {
	j_rgmc_spam = {
		atlas 	= 'spam',
		width 	= 4,
		height 	= 5,
		end_x	= 3,
		end_y	= 4,
		delta_speed = 1,
		delta_time 	= 0
	},
	b_rgmc_lunacy = {
		atlas 	= 'rgmc_deck_lunacy',
		width 	= 8,
		height 	= 4,
		end_x	= 7,
		end_y	= 3,
		delta_speed = 1,
		delta_time 	= 0,
		func = function(self)
			animate_deck_sprite(self.atlas,self.name)
			return true
		end
	},
	c_rgmc_lunacy = {
		atlas 	= 'morefluff_colours_lunacy',
		width 	= 4,
		height 	= 8,
		end_x	= 3,
		end_y	= 7,
		delta_speed = 1,
		delta_time 	= 0
	}
}

local function update_sprite_delta(spr,dt)
	local anim = AnimatedJokers[spr]
	if
		anim
		and G.P_CENTERS[spr]
	then
		if anim.delta_time > 0.1 then
			local obj = G.P_CENTERS[spr]
			anim.delta_time = 0
			if
				obj.pos.x 		== anim.end_x
				and obj.pos.y 	== anim.end_y
			then
				obj.pos.x = 0
				obj.pos.y = 0
			elseif obj.pos.x+1 < anim.width then
				obj.pos.x = obj.pos.x + 1
				--print("X")
			elseif obj.pos.y < anim.height then
				obj.pos.x = 0
				obj.pos.y = obj.pos.y + 1
				--print("Y")
			end
		else
			anim.delta_time = anim.delta_time + dt * anim.delta_speed
		end
		if anim.func then
			anim.func(anim)
		end
	end
	return anim
end

local upd = Game.update
local enable_animations = true
rgmc_spam_dt = 0

G.C.RGMC_MAYHEM 			= {0, 0, 0, 0}
G.C.RGMC_UNUSUAL 			= {0, 0, 0, 0}
G.C.RGMC_GIMMICK 			= {0, 0, 0, 0}
G.C.RGMC_CHAOTIC 			= {0, 0, 0, 0}
G.C.RGMC_ECHIPS 			= {0, 0, 0, 0}
G.C.RGMC_EMULT 				= {0, 0, 0, 0}
G.C.RGMC_ESCORE 			= {0, 0, 0, 0}
G.C.RGMC_EVIL 				= {0, 0, 0, 0}
G.C.RGMC_ANTISPECTRAL 		= {0, 0, 0, 0}


Madcap.C = {
	MAYHEM			= {HEX('75188F'), HEX('3A188F')},
	UNUSUAL 		= {HEX('9C87F6'), HEX('F6879B')},
	CHAOTIC			= {HEX('F25B3A'), HEX('3Af2BF')},
	--CHAOTIC			= {HEX('32CD32'), HEX('CD32CD')},
	ECHIPS	 		= {HEX('000994'), HEX('9a00ff')}, 	-- i like this color :)
	EMULT 			= {HEX('a41818'), HEX('9a00ff')},
	ESCORE 			= {HEX('9a00ff'), HEX('00ff9a')},
	GIMMICK 		= {HEX('FF8b60'), HEX('9494FF')},
	EVIL 			= {HEX('D53600'), HEX('700E01')},
	LIGHT			= {HEX('FF6361'), HEX('FFD380')}, 	-- HEX('FF8531')
	DARK			= {HEX('BC5090'), HEX('00202E')},	-- HEX('2C4875')
	ANTISPECTRAL	= {HEX('78322A'), HEX('677F93')},
}

function Game:update(dt)
	upd(self, dt)

	if enable_animations then
		for k,v in pairs(AnimatedJokers) do
			update_sprite_delta(k,dt)
		end
	end
	--Gradients based on Balatrostuck code
	local anim_timer = self.TIMERS.REAL * 1.5
	local p = 0.5 * (math.sin(anim_timer) + 1)
	for k, c in pairs(Madcap.C) do
		if not G.C["RGMC_" .. k] then G.C["RGMC_" .. k] = { 0, 0, 0, 0 } end
		for i = 1, 4 do
			G.C["RGMC_" .. k][i] = c[1][i] * p + c[2][i] * (1 - p)
		end
	end
end

local add_to_deckref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    if
		self.ability.set == "Joker"
		and not from_debuff
	then
		if -- SPAM!
			self.config.center.key == 'j_rgmc_spam'
		then
			Madcap.Funcs.play_sound_event('rgmc_spam_enter', 1, 1)
		elseif -- lobster thermidor!
			self.config.center.key == 'j_rgmc_lobster_thermidor'
		then
			MadLib.simple_event(function()
				Madcap.Funcs.play_sound_event('rgmc_lobster_thermidor', 1, 1)
				jl.a("Lobster Thermidor A Crevette", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
				delay(2.5)
				jl.a("With A Mornay Sauce", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
				delay(2.5)
				jl.a("Garnished With Truffle Pâté", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
				delay(2.5)
				jl.a("Brandy and a Fried Egg On Top!", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
				delay(2.5)
				return true
			end)
		end
	end
    add_to_deckref(self, from_debuff)
end

local remove_from_deckref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
    if
		self.ability.set == "Joker"
		and not from_debuff
	then
		if -- SPAM!
			self.config.center.key == 'j_rgmc_spam'
		then
			local sound_effect = math.random(1, 3)
			play_sound('rgmc_spam_remove'..tostring(sound_effect))
		end
    end
    remove_from_deckref(self, from_debuff)
end


local uibox_ref = create_UIBox_HUD
function create_UIBox_HUD()
	local orig = uibox_ref()
		--if not Entropy.DeckOrSleeve("doc") then return orig end
    local scale = 0.4
    local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)

    local contents = {}

    local spacing = 0.13
    local temp_col = G.C.DYN_UI.BOSS_MAIN
    local temp_col2 = G.C.DYN_UI.BOSS_DARK

    contents.buttons = {
		{
			n = G.UIT.C,
			config = {
				align = "cm",
				r = 0.1,
				colour = G.C.CLEAR,
				shadow = true,
				id = 'button_area',
				padding=0.33
			},
			nodes = {
				--node[1]
				{
					n = G.UIT.R,
					config = {
						id = 'run_info_button',
						align = "cm",
						minh = 1,
						minw = 1.5,
						padding = 0.05,
						r = 0.1,
						hover = true,
						colour = G.C.RED,
						button = "run_info",
						shadow = true
					},
					nodes = {
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								padding = 0,
								maxw = 2
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize('b_run_info_1'),
										scale = 1.2 * scale,
										colour = G.C.UI.TEXT_LIGHT,
										shadow = true
									}
								}
							}
						},
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								padding = 0,
								maxw = 2
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize('b_run_info_2'),
										scale = 1*scale,
										colour = G.C.UI.TEXT_LIGHT,
										shadow = true,
										focus_args = {
											button = G.F_GUIDE and 'guide' or 'back',
											orientation = 'bm'
										},
										func = 'set_button_pip'
									}
								}
							}
						}
					}
				},
				--node[2]
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						minh = 1,
						minw = 2,
						padding = 0.05,
						r = 0.1,
						hover = true,
						colour = G.C.ORANGE,
						button = "options",
						shadow = true
					},
					nodes = {
						{
							n = G.UIT.C,
							config = {
								align = "cm",
								maxw = 1.4,
								focus_args = {
									button = 'start',
									orientation = 'bm'
								},
								func = 'set_button_pip'
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize('b_options'),
										scale = scale,
										colour = G.C.UI.TEXT_LIGHT,
										shadow = true
									}
								}
							}
						},
					}
				},
				-- node[3]
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						minh = 1,
						minw = 2,
						padding = 0.05,
						r = 0.1,
						hover = true,
						colour = G.C.DYN_UI.BOSS_MAIN,
						emboss=0.05
					},
					nodes = {
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								maxw = 1.35
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize('rgmc_mayhem'),
										minh = 0.33,
										scale = 0.85 * scale,
										colour = G.C.UI.TEXT_LIGHT,
										shadow = true
									}
								},
							}
						},
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								r = 0.1,
								minw = 1.8,
								colour = temp_col2,
								id = 'row_mayhem_text'
							},
							nodes = {
								{ n = G.UIT.O,
									config = {
										object = DynaText({
											string = { { ref_table = G.GAME, ref_value = 'Mayhem'} },
											colours = {G.C.RGMC_UNUSUAL},
											shadow = true,
											scale = 2*scale
										}),
										id = 'mayhem_UI_count'
									}
								},
							}
						}
					}
				}
			}
		}
    }

	orig.nodes[1].nodes[1].nodes[5].nodes[1].nodes = contents.buttons
    return orig
end

--[[
-- fixing
local eval_play_ref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(e)
	eval_play_ref(e)

    --local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
	--Madcap.Funcs.record_hand(scoring_hand,math.floor(hand_chips * mult),text)
end]]

local eval_card_ref = eval_card
function eval_card(card, context)
	if
		context.scoring_hand
		and context.joker_main
	then
		context.subhands = MadLib.get_subhands(context.scoring_hand)
	end

	local ret, post_trig = eval_card_ref(card, context)
	return ret, post_trig
end

-- sum is decided here. haha
local get_nominal_ref = Card.get_nominal
function Card:get_nominal(mod)
    if self.base.value == 'rgmc_sum' then
        tell('Sum Card found?! Wowie!')
        return Madcap.Funcs.get_hand_sigma(G.play.cards) -- returns sum of hand cards
    else -- carry on!
        return get_nominal_ref(self,mod)
    end
end

-- final_scoring_step

local cce = Card.calculate_enhancement
function Card:calculate_enhancement(context)
	local ret = cce(self, context)

	return ret
end


--[[ Used to mess around with poker hand stuff (e.g. Waveworx)
local evaluate_poker_hand_ref = evaluate_poker_hand
function evaluate_poker_hand(hand)
    local results = evaluate_poker_hand_ref(hand)

    -- force poker hand.
    if G.GAME.MADCAP.force_poker_hand then
        if not results[G.GAME.MADCAP.force_poker_hand][1] then
            for _, v in ipairs(G.handlist) do
                if results[v][1] then
                    results[G.GAME.MADCAP.force_poker_hand] = results[v]
                    break
                end
            end
        end
    end

    return results
]]

SMODS.load_file('lib/subhands.lua')()     	-- changes to the scoring system
SMODS.load_file('lib/scoring.lua')()     	-- changes to the scoring system


--[[
 sync = setmetatable({
 	['somemusic1'] = false,
 	['somemusic2'] = false,
 	['somemusic3'] = false,
 }, { __index = function() return true end })
  sync = {
 	['mymusic1'] = true,
 	['mymusic2'] = true,
 }

]]

function Madcap.Funcs.GetMusic(_k, _select, _vol, _sync)
    return {
		object_type = "Sound",
		key = _k,
		path = _k..'.ogg',
		volume = _vol or 0.8,
		select_music_track = _select,
		sync = _sync or true
	}
end

function Madcap.Funcs.LoadCoords(w, i, width)
	return (w.atlas and w.atlas ~= 'placeholder' and MLIB.coords(i-1, width))
		or MLIB.coords(0,0)
end

function Madcap.Funcs.LoadCoordsVertical(w, i)
	return Madcap.Funcs.LoadCoords(w, i, 1, w.atlas)
end

function Madcap.Funcs.CheckLoadTables(_f,_t)
	return type(_f) == 'table' 
		and type(_t) == 'table'
end

function Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args)
	return Madcap.Funcs.CheckLoadTables(_f,_t)
		and type(_atlas) == 'string'
		and (not _args or type(_args) == 'table')
end

function Madcap.Funcs.LoadJokers(_f,_t,_atlas,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	-- should have key, rarity, and some sort of vars/calculation.
	MadLib.loop_func_list(_f,function(w,i)
		w.pos         		= w.pos or Madcap.Funcs.LoadCoords(w, i, (w.args and w.args.width or 0))
		w.order     		= (w.order or Madcap.Orders['Joker']) + (w.args and w.args.priority or 0)
		w.cost				= w.cost or 3 -- default price is $3
		w.unlocked			= w.unlocked or true
		w.discovered		= w.discovered or true
		-- sticker compat defaults to true unless stated otherwise
		w.eternal_compat	= w.eternal_compat or true
		w.perishable_compat = w.perishable_compat or true
		w.blueprint_compat 	= w.blueprint_compat or true
		w.demicoloncompat	= w.demicoloncompat or false -- must state demicolon compat!
		table.insert(_t,w)
	end)
end

function Madcap.Funcs.LoadBlind(_f,_t,_atlas,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		Madcap.Orders['Blind'] = Madcap.Orders['Blind'] + 1
		w.object_type     	= "Blind"
		w.order           	= w.order or Madcap.Orders['Blind'] + (args and args.priority or 0)
		w.mult 			    = w.mult or 2
		w.discovered 		= w.discovered or true
		w.atlas           	= w.atlas or _atlas or 'blinds'
		w.pos             	= w.pos or Madcap.Funcs.LoadCoordsVertical(w, i)
        if w.key:find("final_") then -- showdown
			w.dollars           = w.dollars or 8
            w.boss = { showdown = true, min = w.min_ante or 0, max = 999 }
            w.order = w.order + 1000 -- prioritize at end of list
        else
			w.dollars           = w.dollars or 5
            w.boss = { min = w.min_ante or 0, max = 999 }
        end
        w.min_ante = nil -- don't need it now
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
	end)
end

function Madcap.Funcs.LoadConsumables(_f,_s,_t,_atlas,_w,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		Madcap.Orders['Consumable'] = Madcap.Orders['Consumable'] + 1
		w.object_type     	= "Consumable"
		w.set 			  	= w.set or _s
		w.order           	= w.order or Madcap.Orders['Consumable']
		w.unlocked 			= w.unlocked or true
		w.discovered 		= w.discovered or true
		w.atlas           	= w.atlas or (_atlas or 'placeholder')
		w.pos             	= w.pos or Madcap.Funcs.LoadCoords(w, i, _w or 4)
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
	end)
end

function Madcap.Funcs.LoadEnhancements(_f,_t,_atlas,_w,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		Madcap.Orders['Enhancement'] = Madcap.Orders['Enhancement'] + 1
		w.object_type	= "Enhancement"
		w.order      	= w.order or Madcap.Orders['Enhancement']
		w.atlas      	= w.atlas or (_atlas or 'placeholder')
		w.pos        	= w.pos or Madcap.Funcs.LoadCoords(w, i, _w or 4)
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
    end)
end

function Madcap.Funcs.LoadBoosters(_f,_t,_atlas,_w,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		Madcap.Orders['Booster'] = Madcap.Orders['Booster'] + 1
		w.object_type	= "Booster"
		w.order     	= w.order or Madcap.Orders['Booster']
		w.atlas      	= w.atlas or (_atlas or 'placeholder')
		w.pos         	= w.pos or Madcap.Funcs.LoadCoords(w, i, _w or 4)
		w.weight 		= w.weight or 0.5
		w.in_pool		= w.in_pool or true
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
    end)
end

function Madcap.Funcs.LoadVouchers(_f,_t,_atlas,_w,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		Madcap.Orders['Voucher'] = Madcap.Orders['Voucher'] + 1
		w.object_type	= "Voucher"
		w.order     	= w.order or Madcap.Orders['Voucher']
		w.atlas      	= w.atlas or (_atlas or 'placeholder')
		w.pos         	= w.pos or Madcap.Funcs.LoadCoords(w, i, _w or 4)
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
    end)
end

function Madcap.Funcs.LoadDecks(_f,_t,_atlas,_w,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		Madcap.Orders['Deck'] = Madcap.Orders['Deck'] + 1
		w.object_type	= "Back"
		w.order      	= w.order or Madcap.Orders['Deck']
		w.atlas     	= w.atlas or (_atlas or 'placeholder')
		w.pos        	= w.pos or Madcap.Funcs.LoadCoords(w, i, _w or 5)
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
    end)
end

function Madcap.Funcs.LoadSounds(_f,_t)
	if not Madcap.Funcs.CheckLoadTables(_f,_t) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		if w.list then
			MadLib.loop_func_list(_f,function(v,i)
				v.object_type = "Sound"
				_t[#_t+1] = v
			end)
		else
			w.object_type = "Sound"
			_t[#_t+1] = w
		end
    end)
end

function Madcap.Funcs.LoadSleeves(_f,_t,_atlas,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		Madcap.Orders['Sleeve'] = Madcap.Orders['Sleeve'] + 1
		w.unlocked 			= w.unlocked or true
		w.discovered 		= w.discovered or true
		w.atlas 			= w.atlas or (_atlas or 'placeholder')
		w.order           	= w.order or Madcap.Orders['Sleeve']
		w.pos             	= w.pos or Madcap.Funcs.LoadCoords(w, i, _w or 5)
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
	end)
end

function Madcap.Funcs.LoadTags(_f,_t,_atlas,_w,_args)
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then return false end
	MadLib.loop_func_list(_f,function(w,i)
		if not w then return false end
		Madcap.Orders['Tag'] = Madcap.Orders['Tag'] + 1
		w.object_type	= "Tag"
		w.order     	= w.order or Madcap.Orders['Tag']
		w.atlas      	= w.atlas or (_atlas or 'placeholder')
		w.pos         	= w.pos or Madcap.Funcs.LoadCoords(w, i, _w or 8 + (_args and _args.offset or 0))
		if _args then MadLib.loop_func_table(_args, function(k,v) w[k] = v end) end
		_t[#_t+1] = _f[i]
		return true
    end)
end

-- File loading based on Cryptid mod lmao
local errors = {}
Madcap.object_buffer = {}

local function load_folder(folder)
	local files = NFS.getDirectoryItems(mod_path .. folder)
	for _, file in ipairs(files) do
		tell("Loading file "..file)
		local f, err = SMODS.load_file(folder .. "/" .. file)
		if err then
			errors[file] = err
		else
			local curr_obj = f()
			local namey = curr_obj.name
			if curr_obj.name == "HTTPS Module" and Madcap[curr_obj.name] == nil then
				MadcapConfig[curr_obj.name] = false
			end
			if MadcapConfig[curr_obj.name] == nil then
				MadcapConfig[curr_obj.name] = true
				Madcap.enabled[curr_obj.name] = true
				tell("Loading current object "..namey)
			end
			if MadcapConfig[curr_obj.name] then
				tell("Succesfully loaded " .. namey)
				if curr_obj.init then
					curr_obj:init()
				end
				if not curr_obj.items then
					tell("Warning: " .. namey .. " has no items")
				else
					for _, item in ipairs(curr_obj.items) do
						if not item.order then
							item.order = 0
						end
						if curr_obj.order then
							item.order = item.order + curr_obj.order
						end
						if SMODS[item.object_type] then
							if not Madcap.object_buffer[item.object_type] then
								Madcap.object_buffer[item.object_type] = {}
							end
							--tell("Added item to obj_buffer of "..namey)
							Madcap.object_buffer[item.object_type][#Madcap.object_buffer[item.object_type] + 1] = item
						else
							tell("Error loading item "..namey .." :(")
						end
					end
				end
			end
		end
	end
end

--[[
	MAYHEM
]]

-- When values are "mayhemized". they follow certain rules.
-- Some values are multiplied at a lesser [factor].
-- Some values are only manipulated at a minimum [level].
-- Some values are [round]ed for the sake of simplicity.
-- Some values activate functions based on their [type].
Madcap.MayhemValues = {
	['AddMult'] 		= { factor = 1, round = true },
	['AddChips'] 		= { factor = 1, round = true },
	['AddScore'] 		= { factor = 1, round = true },
	['MultiMult'] 		= { factor = 1, level = 1, multiply = true },
	['MultiChips'] 		= { factor = 0.8, level = 1, multiply = true },
	['MultiScore'] 		= { factor = 0.8, level = 1, multiply = true },
	['ExpMult'] 		= { factor = 0.5, level = 2, multiply = true },
	['ExpChips'] 		= { factor = 0.5, level = 2, multiply = true },
	['ExpScore'] 		= { factor = 0.5, level = 2, multiply = true },
	['AddMoney'] 		= { factor = 1, round = true },
	['HandSize']		= { factor = 0.5, level = 1, round = true, type = 'hand_size'},
	['PlayHands']		= { factor = 0.5, round = true },
	['PlayDiscards'] 	= { factor = 0.5, round = true },
	['Retriggers'] 		= { factor = 0.5, round = true },
	['JokerSlots']		= { factor = 0.5, level = 1, round = true, type = 'joker_slots' },
	['VoucherLimit']	= { factor = 0.5, level = 2, round = true, type = 'voucher_limit' },
	['BoosterLimit']	= { factor = 0.5, level = 2, round = true, type = 'booster_limit' },
	['MaxMayhem']		= { factor = 1, level = 1, round = true, type = 'max_mayhem' },
	['Mayhem']			= { factor = 1, level = 1, type = 'add_mayhem' },
	['Probability']		= { factor = 1, },
	['Misc']			= { factor = 1, }
}
local mlibmv = Madcap.MayhemValues

Madcap.MayhemConversions = {
	['cry_prob']		= mlibmv['Probability'],
	['odds']			= mlibmv['Probability'],
	['dollars']			= mlibmv['AddMoney'],
	['h_size']			= mlibmv['HandSize'],
	['h_mod']			= mlibmv['HandSize'],
	['handsize']		= mlibmv['HandSize'],
	['hand']			= mlibmv['PlayHands'],
	['hands']			= mlibmv['PlayHands'],
	['hand_mod']		= mlibmv['PlayHands'],
	['adds_hands']		= mlibmv['PlayHands'], -- UnStable?
	['discard']			= mlibmv['PlayDiscards'],
	['discards']		= mlibmv['PlayDiscards'],
	['discard_mod']		= mlibmv['PlayDiscards'],
	['discard_size']	= mlibmv['PlayDiscards'], -- UnStable?
	['extra']			= mlibmv['Misc'],
	['jokerslots']		= mlibmv['JokerSlots'],
	['joker_slots']		= mlibmv['JokerSlots'],
	['voucher_limit']	= mlibmv['VoucherLimit'],
	['booster_limit']	= mlibmv['BoosterLimit'],
	['extra_choices']	= mlibmv['ExtraChoices'],
	['max_mayhem']		= mlibmv['MaxMayhem'],
	['add_mayhem']		= mlibmv['Mayhem'],
	['retriggers']		= mlibmv['Retriggers'],
	['repetitions']		= mlibmv['Retriggers'],
}

-- 
local function loop_keys_add(list, target, value)
	MadLib.loop_func(list, function(k) target[k] = value end)
end
loop_keys_add({ 'mult', 'mult_mod', 'perma_mult', 'perma_h_mult', 's_mult', 't_mult' },
	Madcap.MayhemConversions,  mlibmv['AddMult'])
loop_keys_add({ 'chips', 'chip_mod', 'perma_bonus', 'perma_h_chips' },
	Madcap.MayhemConversions,  mlibmv['AddChips'])
loop_keys_add({ 'score', 'score_mod', 'perma_score', 'perma_h_score' },
	Madcap.MayhemConversions,  mlibmv['AddScore'])
loop_keys_add({ 'dollars', 'h_dollars', 'p_dollars', 'perma_p_dollars', 'perma_h_dollars' },
	Madcap.MayhemConversions,  mlibmv['AddMoney'])
loop_keys_add({ 'h_size', 'h_mod', 'handsize', 'hand_size', },
	Madcap.MayhemConversions,  mlibmv['HandSize'])
loop_keys_add({ 'd_size', 'discard_size', 'discards', 'discard', 'discard_mod' },
	Madcap.MayhemConversions,  mlibmv['PlayDiscards'])
loop_keys_add({ 'hands', 'hand_mod', 'hand' },
	Madcap.MayhemConversions,  mlibmv['PlayHands'])

-- Handle the mult, chips, and score stuff
MadLib.loop_func({ 'x', 'e', 'ee', 'eee', 'hyper' }, function(v)
	local _cat = (v ~= 'x') and 'Exp' or 'Multi'
	local v1 = string.upper(v)
	
	loop_keys_add({ v..'mult', v..'mult_mod', v..'_mult', v1..'mult', v1..'mult_mod', 'h_'..v..'_mult',
		'perma_'..v..'_mult', 'perma_h_'..v..'_mult', },
		Madcap.MayhemConversions,  mlibmv[_cat..'Mult'])

	loop_keys_add({ 
		v..'chips', v..'_chips', v..'chip_mod', v..'chips_mod', 
		v1..'chips', v1..'chip_mod', v1..'chips_mod', 'h_'..v..'_chips',
		'perma_'..v..'_chips', 'perma_h_'..v..'_chips' },
		Madcap.MayhemConversions,  mlibmv[_cat..'Chips'])

	loop_keys_add({ v..'score', v..'score_mod', v..'_score', v1..'score', v1..'score_mod', 'h_'..v..'_score',
		'perma_'..v..'_score', 'perma_h_'..v..'_score' },
		Madcap.MayhemConversions,  mlibmv[_cat..'Score'])
end)

Madcap.MayhemBlacklist = {
	id 		= false,
	qty 	= false,
	colour 	= false,
	immutable = false,
	h_x_chips = false,
	suit_nominal 	= false,
	base_nominal 	= false,
	face_nominal 	= false,
	times_played 	= false,
	selected_d6_face 	= false,
	cry_hook_id			= false,
	suit_nominal_original 	= false,
}

function Madcap.Funcs.get_mayhem_multiplier(mayhem)
    local t = MadLib.clamp(mayhem / 10, 0, 1)
    -- Use an easing function to skew the curve toward the high end
    local eased = t ^ 2.2  -- You can adjust this exponent for fine-tuning
	local min_mult = 1 / (8 ^ eased)
    local max_mult = 8 ^ eased
    -- Random multiplier within that range
    return math.random() * (max_mult - min_mult) + min_mult
end

-- used to define what extra means for the vanilla jokers (which work differently?)
-- also works with any joker that has undefined variables.
Madcap.DefineExtras = {
	['j_loyalty_card'] 		= { ['every'] = mlibmv['Misc'] }, -- every ? rounds
	['j_8_ball'] 			= { ['extra'] = mlibmv['Probability'] }, -- 1 in ? chance
	['j_misprint'] 			= { ['max'] = mlibmv['AddMult'], ['min'] = mlibmv['AddMult'] }, -- min and max mult
	['j_chaos'] 			= { ['extra'] = mlibmv['Misc'] }, -- reroll
	['j_fibonacci'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_steel_joker'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_scary_face'] 		= { ['extra'] = mlibmv['AddChips'] },
	['j_abstract'] 			= { ['extra'] = mlibmv['AddChips'] },
	['j_delayed_grat'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_hack'] 				= { ['extra'] = mlibmv['Retriggers'] },
	['j_even_steven'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_odd_todd'] 			= { ['extra'] = mlibmv['AddChips'] },
	['j_business'] 			= { ['extra'] = mlibmv['Probability'] },
	['j_egg'] 				= { ['extra'] = mlibmv['AddMoney'] },
	['j_burglar'] 			= { ['extra'] = mlibmv['PlayHands'] },
	['j_blackboard'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_supernova'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_ride_the_bus'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_space'] 			= { ['extra'] = mlibmv['Probability'] },
	['j_blue_joker']	 	= { ['extra'] = mlibmv['AddChips'] },
	['j_constellation']		= { ['extra'] = mlibmv['AddChips'] },
	['j_red_card']			= { ['extra'] = mlibmv['AddMult'] },
	['j_madness']			= { ['extra'] = mlibmv['MultiMult'] },
	['j_riff_raff']			= { ['extra'] = mlibmv['JokerSlots'] },
	['j_vagabond'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_baron'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_cloud_9'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_obelisk'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_photograph'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_gift'] 				= { ['extra'] = mlibmv['AddMoney'] },
	['j_erosion'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_mail'] 				= { ['extra'] = mlibmv['AddMoney'] },
	['j_to_the_moon'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_hallucination'] 	= { ['extra'] = mlibmv['Probability'] },
	['j_fortune_teller'] 	= { ['extra'] = mlibmv['AddMult'] },
	['j_stone'] 			= { ['extra'] = mlibmv['AddChips'] },
	['j_golden'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_lucky_cat'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_baseball'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_bull'] 				= { ['extra'] = mlibmv['AddChips'] },
	['j_trading'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_flash'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_popcorn'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_trousers'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_ancient'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_ramen'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_seltzer'] 			= { ['extra'] = mlibmv['Retriggers'] },
	['j_smiley'] 			= { ['extra'] = mlibmv['AddMult'] },
	['j_campfire'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_ticket'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_acrobat'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_sock_and_buskin'] 	= { ['extra'] = mlibmv['Retriggers'] },
	['j_throwback'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_hanging_chad'] 		= { ['extra'] = mlibmv['Retriggers'] },
	['j_rough_gem'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_arrowhead'] 		= { ['extra'] = mlibmv['AddChips'] },
	['j_onyx_agate'] 		= { ['extra'] = mlibmv['AddMult'] },
	['j_glass'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_flower_pot'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_idol'] 				= { ['extra'] = mlibmv['MultiMult'] },
	['j_seeing_double'] 	= { ['extra'] = mlibmv['MultiMult'] },
	['j_matador'] 			= { ['extra'] = mlibmv['AddMoney'] },
	['j_hit_the_road'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_invisible'] 		= { ['extra'] = mlibmv['Misc'] }, -- rounds
	['j_satellite'] 		= { ['extra'] = mlibmv['AddMoney'] },
	['j_shoot_the_moon'] 	= { ['extra'] = mlibmv['AddMult'] },
	['j_drivers_license'] 	= { ['extra'] = mlibmv['MultiMult'] },
	['j_caino'] 			= { ['extra'] = mlibmv['MultiMult'] },
	['j_triboulet'] 		= { ['extra'] = mlibmv['MultiMult'] },
	['j_cry_soccer'] 		= { ['holygrail'] = mlibmv['Misc'] }, -- One For All
}

function Madcap.Funcs.change_hand_size(_old,_new)
	if _new == _old then return false end
	G.hand:change_size(_new - _old)
	return true
end

function Madcap.Funcs.change_extra_choices(_old,_new)
	if _new == _old then return false end
	G.GAME.extra_choices = (G.GAME.extra_choices or 0) + (_new - _old)
	return true
end

function Madcap.Funcs.change_consumable_limit(_old,_new)
	if _new == _old then return false end
	G.consumeables.config.card_limit = G.consumeables.config.card_limit + (_new - _old)
	return true
end

function Madcap.Funcs.change_voucher_limit(_old,_new)
	if _new == _old then return false end
	SMODS.change_voucher_limit(_new - _old)
	return true
end

function Madcap.Funcs.change_booster_limit(_old,_new)
	if _new == _old then return false end
	SMODS.change_booster_limit(_new - _old)
	return true
end

function Madcap.Funcs.change_joker_slots(_old,_new)
	if _new == _old then return false end
	G.jokers.config.card_limit = G.jokers.config.card_limit + (_new - _old)
	return true
end

local mayhemize_funcs = {
	['joker_slots'] 	= mfuncs.change_joker_slots,
	['booster_limit'] 	= mfuncs.change_booster_limit,
	['voucher_limit'] 	= mfuncs.change_voucher_limit,
	['extra_choices'] 	= mfuncs.change_extra_choices,
	['max_mayhem'] 		= function(_old,_new)
		if _new == _old then return false end
		G.GAME.max_mayhem = (G.GAME.max_mayhem or 10) + (_new - _old)
		return true
	end,
	['add_mayhem'] = function(_old,_new)
		if _new == _old then return false end
		Madcap.Funcs.ease_mayhem(_new - _old)
		return true
	end,
	['rift_limit'] 		= function(_old,_new)
		if _new == _old then return false end
		G.GAME.rift_limit = (G.GAME.rift_limit or 10) + (_new - _old)
		return true
	end,
	['hand_size'] 		= mfuncs.change_hand_size,
	['handsize'] 		= mfuncs.change_hand_size,
	['h_size'] 			= mfuncs.change_hand_size,
	['h_mod']			= mfuncs.change_hand_size,
	['consumable_limit'] = mfuncs.change_consumable_limit,
	['holygrail']		= function(_old,_new)
		mfuncs.change_hand_size(_old,_new)
		mfuncs.change_consumable_limit(_old,_new)
		mfuncs.change_booster_limit(_old,_new)
	end
}

function Madcap.Funcs.can_mayhemize_value(_level,_type)
	local level_check = _level <= mfuncs.get_mayhem_state()

	return level_check
end

function Madcap.Funcs.mayhemize_table(_card, _table, _args)
	-- loop through the table
	MadLib.loop_table(_table, function(k,v)
		-- is this a blacklisted term?
		if Madcap.MayhemBlacklist[k] == nil then -- not blacklisted
			if type(v) == 'table' then -- we must go deeper
				Madcap.Funcs.mayhemize_table(_card, v, _args)
			elseif type(v) == 'number' then -- do the number
				local _key = k ~= 'extra' and k
				local _data = k and Madcap.MayhemConversions[_key]
				if Madcap.DefineExtras[_card.config.center.key] then
					tell('Finding extra value...')
					_data = Madcap.DefineExtras[_card.config.center.key][k]
				end
				local _xval = _data and _data.multiply

				if 
					not _data -- no data
					or (not _xval and v == 0) -- additive value at 0.00
					or (_xval and v == 1) -- multiplying value at 1.00 (or 0.00)
				then
					return false 
				end -- don't bother if multiplying value and not set
				tell('Key ' .. k .. ' explored!')

				local factor = (_data and _data.factor) or 1
				local must_round = (_data and _data.round or false)
				local nu_min, nu_max = MadLib.deep_copy(_args.min), MadLib.deep_copy(_args.max)
				local center, half_range = (nu_min + nu_max) / 2, math.abs(nu_max - nu_min) / 2 * factor
				nu_min, nu_max = center - half_range, center + half_range
				
				local _mult = MadLib.random_between(nu_min,nu_max, 2)

				--if _xval then tell('This is an multiplying value!') end
				
				local _base = v - (_xval and 1 or 0)
				_table[k] = MadLib.round((_base * _mult) + (_xval and 1 or 0), must_round and 0 or 2)
				
				if _data and _data.type and mayhemize_funcs[_data.type] then
					mayhemize_funcs[_data.type](v,_table[k])
				end

				--tell(tostring(k)..' is now '..tostring(_table[k])..' ('..tostring(v)..').')
			end -- don't mess with bools and strings.
		end
	end)
end

-- Messes up the values of the targeted cards based on 
function Madcap.Funcs.mayhemize(_card, _args, _silent)
	local low_mult 		= (_args and _args.min_mult) or (1/2)
	local high_mult		= (_args and _args.max_mult) or 2
	local mayhem_state	= mfuncs.get_mayhem_state()
	local arguments 	= { min	= low_mult, max	= high_mult }

	if not (_args and _args.force_values) then
		if mayhem_state < 1 then
			low_mult	= low_mult * 1.5
			high_mult	= high_mult / 1.5
		elseif mayhem_state < 2 then
			low_mult	= low_mult / 1.5
			high_mult	= high_mult * 1.5
		elseif mayhem_state < 3 then
			low_mult	= low_mult / 2
			high_mult	= high_mult * 2
		else
			low_mult	= low_mult / 3
			high_mult	= high_mult * 3
		end
	end

	Madcap.Funcs.mayhemize_table(_card, _card.ability, arguments)
	-- loop through each

	-- max mayhem (10 has between x1/8 and x8 mult)
	-- 0 mayhem is x1 mult
	if not _silent then
		MadLib.simple_event(function()
        	_card:juice_up(0.3, 0.4)
        	play_sound("rgmc_mayhemize")
			return true
		end, 0.0, 'immediate')
	end
end

function Madcap.Funcs.flip_and_mayhemize(_cards,_args)
	MadLib.flip_cards(_cards, function(v)
		Madcap.Funcs.mayhemize(v, _args, true)
	end, nil, function(v)
        card:juice_up(0.3, 0.4)
        play_sound("rgmc_mayhemize")
	end)
end

load_folder('items') -- load the items folder
load_folder('compat') -- load the items folder

for set, objs in pairs(Madcap.object_buffer) do
	table.sort(objs, function(a, b)
		return a.order < b.order
	end)
	for i = 1, #objs do
		if objs[i].post_process and type(objs[i].post_process) == "function" then
			objs[i]:post_process()
		end
		SMODS[set](objs[i])
	end
end

-- File loading ended!

print(errors)
for f, e in ipairs(errors) do
    tell_stat("Error loading file",e)
end

-- Easier way to handle the removal of descaling Jokers
function MadLib.goodbye_card(card)
    MadLib.simple_event(function()
        play_sound("tarot1")
        card.T.r = -0.2
        card:juice_up(0.3, 0.4)
        card.states.drag.is = true
        card.children.center.pinch.x = true
        MadLib.simple_event(function()
            card:remove()
            return true
        end, 0.3, 'after', false)
    end,0.0)
end

-- Easier way to handle the descaling Joker Logic?
local function handle_descaling_joker_logic(trigger,card,v1,v2,type)
    if trigger() and context.main_eval and not context.blueprint then
        if card.ability.extra[v1] - card.ability.extra[v2]<= 0 then
            MadLib.goodbye_card(card)
        else
            MadLib.calculate_food_loss(card, type, card.ability.extra[v2])
            card.ability.extra[v1] = card.ability[v1] - card.ability.extra[v2]
            return MadLib.get_simple_downgrade_data(type, card, card.ability.extra[v2])
        end
    end
end

--[[
    if context.after and context.main_eval and not context.blueprint then
        if card.ability.extra.chips - card.ability.extra.chip_mod <= 0 then
            goodbye_card(card)
        else
            MadLib.calculate_food_loss(card, MadLib.ScoreKeys.AddChips, card.ability.extra.chip_mod)
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
            return MadLib.get_simple_downgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
        end
    end
]]

-- Fixing the functions for the vanilla Jokers!
local VanillaFixing = {
    ['j_ice_cream'] = function(self, card, context)
        -- After every hand
        handle_descaling_joker_logic(function()
            return context.after
        end, 'chips', 'chip_mod', MadLib.ScoreKeys.AddChips)

        -- Joker main
        if context.joker_main then return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips) end
    end,
    ['j_popcorn'] = function(self, card, context)
        -- After every hand
        handle_descaling_joker_logic(function()
            return context.end_of_round and context.game_over == false
        end, 'mult', 'mult_loss', MadLib.ScoreKeys.AddMult)

        if context.joker_main then return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult_mod) end
    end,
    ['j_ramen'] = function(self, card, context)
        -- After every hand
        handle_descaling_joker_logic(function()
            return context.discard and card.ability.special.flag
        end, 'Xmult', 'Xmult_loss', MadLib.ScoreKeys.MultiMult)

        if context.joker_main then return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.mult_mod) end
    end,
}

-- Add the new code
for k,v in pairs(VanillaFixing) do
    if
        G.P_CENTERS[k]
        and not G.P_CENTERS[k].calculate
    then
        --print('Adding support for ' .. k)
        G.P_CENTERS[k].calculate = v
        --print(G.P_CENTERS[k].calculate and "Calculated!" or "...?!")
    end
end

if not Cryptid then

	--Calculate events on cash out
	local gfco = G.FUNCS.cash_out
	G.FUNCS.cash_out = function(e)
		local ret = gfco(e)
		SMODS.calculate_context({ cash_out = true })
		return ret
	end

end

local card_stop_drag_ref = Card.stop_drag
function Card:stop_drag()
    local c = card_stop_drag_ref(self)

	if (self.area == G.hand or self.area == G.play) then
		--tell("CARD RELEASED!!!!")
		--tell('Center is ' .. tostring(self.config.center.key))
	end

	local fancy_cards = {}
    if self.area and (self.area == G.hand or self.area == G.play) then
		for i=1, #self.area.cards do
			local _card = self.area.cards[i]
			if _card.config.center.key == 'm_rgmc_lazurite' then
				tell('Added to fancy cards')
				table.insert(fancy_cards, {index = i, type = _card.config.center.key}) -- add lazurite index
			end
		end
	end

	-- lazurite cards copy the rank and suit of the card to their right
	for i = #fancy_cards, 1, -1 do
		local _index 	= fancy_cards[i].index
		local _card 	= self.area.cards[_index]
		local _type 	= fancy_cards[i].type
		local _target, _rank, _suit

		print(fancy_cards[i])
		if _type == 'm_rgmc_lazurite' then
			local changed
			local copy_rank = _index < #self.area.cards
			if copy_rank then
				changed 	= _card.base.value ~= _rank or _card.base.suit ~= _suit
				_target 	= self.area.cards[_index+1]
				_rank 	= _target.base.value -- get the true value
				_suit		= _target.base.suit
				assert(SMODS.change_base(_card, _suit, _rank))
			end
			changed = changed or (_card.config.center.no_rank == copy_rank)
			_card.config.center.no_rank 			= not copy_rank
			_card.config.center.no_suit 			= not copy_rank
			_card.config.center.replace_base_card 	= not copy_rank
			if changed then
				_card:juice_up(0.5, 0.7)
				delay(1.0)
			end
		end
	end
    -- if G.deck and self.area and self.area == G.jokers and self.config.center_key == "j_akyrs_hibana" then
    --    G.deck:shuffle()
    -- end
    return c
end

local card_open_ref = Card.open

Madcap.JokerLists.ExtraChoices = {
	'jeff'
}

function Card:open()
	local orig = self.ability.extra or 1
	-- checks if there are any +booster slot jokers
	local _helpers = 0
	if _helpers > 0 then
		for k, v in pairs(_helpers) do
			if v.ability.extra and v.ability.extra.extra_choices then
				orig = orig + v.ability.extra.extra_choices
			end
		end
		self.config.choose = math.floor(orig)
		self.ability.extra = math.floor(orig)
	end
	-- commence regular opening
	card_open_ref(self)
	G.E_MANAGER:add_event(Event({delay = 0.5, timer = 'REAL', func = function()
		if _helpers > 0 then G.GAME.pack_choices = math.floor(self.ability.extra) end
		return true
	end }))
end


Madcap.CustomCashouts = {
	['capitalism_boss'] = {
		check = function()
			return G.GAME.last_blind
		end,
		get_money = function(d)
			return 99
		end,
	}

}

----------------------------------------------
------------MOD CODE END----------------------
