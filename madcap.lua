
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
tell_stat = function(text,stat)
    print_debug_text(text..": "..tostring(stat))
end

-- Prints out a MADCAP list.
tell_list = function (text,list)
    print_debug_text(text..":")
    print(list)
end

Madcap = {
	Funcs 		= { },
	JokerLists 	= { },
	DeckFuncs 	= { }, -- deck functions
	Orders = {
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
	},
	Lists = {
		AnTags = {},
		AnTagConversions = {
			['boomerang'] = 'anti_boomerang',
		},
		RoshamboKeys = {
			'm_stone',
			'm_lucky',
			'm_steel'
		},
		RoshamboValues = {
			['bonus'] 		= { 50.0, 0.0 }, 	-- rock
			['mult'] 		= { 20.0, 0.0 }, 	-- paper
			['p_dollars'] 	= { 20.0, 0.0 }, 	-- paper
			['h_x_mult'] 	= { 1.5, 1.0 },	-- scissors
		},
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
		},
		Enhancements = {
			Chips = {
				'bonus',
				'stone',
				'rgmc_wolfram'
			},
			Mult = {
				'mult',
				'lucky',
				'rgmc_wolfram'
			},
			XMult = {
				'glass',
				'steel',
				'rgmc_lustrous'
			},
			Money = {
				'gold',
				'lucky'
			},
		},
	},
	Data = {
		seed		= 'rgmc', 	-- primary seed for random stuff
		devmode 	= true, 	-- When true, enables all the debug text and unfinished content.
	},
}

-- Quick fix for colors. TODO: Bring back working gradients!!!
G.C.RGMC_UNUSUAL 	= HEX('FFC0CB')
G.C.RGMC_CHAOTIC 	= HEX('003F34')
G.C.RGMC_GIMMICK 	= HEX('F69600')
G.C.RGMC_LUXURY 	= HEX('D34B08')

-- Rarities
SMODS.Rarity{ -- Unusual: not quite Epic Jokers, but not quite Legendary.
    key = "unusual",
    badge_colour = G.C.RGMC_UNUSUAL,
	badge_text_colour = HEX('1E2729'),
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

-- easier way of saying
mfuncs 	= Madcap.Funcs
mjokers	= Madcap.JokerLists

-- enabled type stuff
local mod_path = "" .. SMODS.current_mod.path       -- save the mod path for future usage!
MadcapConfig = SMODS.current_mod.config          	-- loading configuration
Madcap.enabled = copy_table(MadcapConfig)      		-- what is enabled?

function SMODS.current_mod.process_loc_text()
    G.localization.misc.v_text.ch_c_rgmc_rule_rio = {
        "{C:attention}Aces{}, {C:attention}Kings{}, and {C:attention}Queens{} are {C:attention}3X{} more likely to appear{}"
    }
    G.localization.misc.v_text.ch_c_rgmc_rule_waveworx = {
        "{C:attention}All{} hands (except {C:attention}Straight{}) are {C:rgmc_evil}downgraded{} to Level {C:attention}0{}"
    }
    G.localization.misc.v_text.ch_c_bankrupt_kill = {
        "Going {C:attention}bankrupt{} results in an {C:rgmc_evil}automatic loss{}!"
    }
    G.localization.misc.v_text.ch_c_rgmc_rule_halved_interest = {
        "Base {C:attention}interest{} and interest {C:attention}cap{} are {C:rgmc_evil}reduced{} by {C:rgmc_evil}X0.5{}"
    }
end

-- Injected into start of run, regardless if Madcap is playing or not.
function Madcap.Funcs.run_start()
    tell('Run Start')

    G.GAME.subhands = {}
    G.GAME.subhand_minimum = (G.GAME.subhand_minimum or 5)
	G.GAME.dead_jokers = {}
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
        G.GAME.subhands[k].empower		= 0
        G.GAME.subhands[k].evolve		= 0
    end

    local madcap_vals = {
		mayhem				= 0,
		mayhem_state		= 0,
		max_mayhem			= G.GAME.starting_params.add_max_mayhem or 10,
		rgmc_luxury_pts		= G.GAME.starting_params.rgmc_luxury_pts or 0,
		dead_jokers			= {},
		missed_jokers		= {},
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
        pick_5              = nil,		-- TODO: readd pick 5 shit
        best_hand           = {
            score   = 0,
            hand    = {},   -- held in hand
            play    = {},   -- highlighted and played
            ante    = 0
        }
    }
	MadLib.loop_table(madcap_vals, function(k,v) G.GAME[k] = v end)

	-- Silently add mayhem if deck starts with more mayhem
	if G.GAME.starting_params.add_mayhem then
		Madcap.Funcs.ease_mayhem(G.GAME.starting_params.add_mayhem, true, false, true)
		Madcap.Funcs.read_mayhem()
	end

	-- Borrowed from Bunco
    G.GAME.Exotic = G.GAME.Exotic or false -- Used for exotic suits and ranks?

    -- Challenge rules.
    if G.GAME.modifiers['rgmc_rule_waveworx'] then -- Reduce all hands but Straight to Level 0
		MadLib.loop_table(G.GAME.hands, function(k,v)
			if k ~= 'Straight' then
				v.level = 0
				v.chips = math.floor(v.chips/2)
				v.mult 	= math.floor(v.mult/2)
				v.hidden = true
			else
				v.level = 2
				v.chips = v.chips + v.l_chips
				v.mult 	= v.mult + v.l_mult
			end
		end)
	elseif G.GAME.modifiers['rgmc_rule_halved_interest'] then
		G.GAME.interest_amount = MadLib.round(G.GAME.interest_amount/2, 1)
	end
end

-- Upon selecting the blind...
function Madcap.Funcs.blind_start()
    -- start of blind
    tell('Blind Start')

	G.GAME.rank_dist = MadLib.get_ranks_from_cards(G.playing_cards)

	G.GAME.blind_stats = {
		suits = {},
		ranks = {}
	}

    local patina_cards, bronze_cards, normal_cards = {}, {}, {}
    local new_deck = {}
end

-- Upon winning the blind...
function Madcap.Funcs.blind_end()

    -- end of blind
    tell('Blind End')

	-- Remove round
	if G.GAME.rgmc_sinister then
		MadLib.loop_table(G.GAME.rgmc_sinister, function(k,v)
			v.rounds = v.rounds - 1
			-- cash out
			if v.rounds <= 0 then
				if v.money then ease_dollars(v.money or 5) end
				if v.consumeable then G.consumables:change_size(v.consumeable or 1) end
				MadLib.simple_event(function()
					play_sound('timpani',1.2)
					return true
				end, 0.1, 'after')
				G.GAME.rgmc_sinister[k] = nil -- we are done
				return true
			end
		end)
	end

	-- Do a mayhem check
	if G.GAME.mayhem and G.GAME.mayhem > 0 then
		Madcap.Funcs.blind_end_mayhem_check() -- done in case others want to edit this function
	end

    if
        G.GAME.blind
        and G.GAME.blind.boss
    then
        G.GAME.boss_blinds = G.GAME.boss_blinds + 1
        if G.GAME.blind.boss and Madcap.Funcs.is_finisher_ante() then G.GAME.showdown_blinds = G.GAME.showdown_blinds + 1 end
    end

    if G.GAME.punisher_mode then
        G.GAME.punisher_mode = false
    end

end

-- Upon starting an ante
function Madcap.Funcs.ante_start()
    -- start of ante
    tell('Ante Start')

	local blinds = {'Small', 'Big', 'Boss'}

	G.GAME.ante = {
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
		first_hand_type	= nil	-- first hand type (for madcap mouth)
	}

	local x_card = G.playing_cards and pseudorandom_element(G.playing_cards, pseudoseed('rgmc_x_value')) or nil -- pick a card, any card...
	G.GAME.x_value = x_card and x_card.base.value or "10" -- The rank becomes the x's rank

	-- Pale Deck
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


	G.GAME.pick_5 = {}
	--[[
	local pick_5_cards = MadLib.shuffle_sort_list(G.deck.cards, 5, function(v)
        return (v ~= nil) and not SMODS.has_no_rank(v)
    end)

	tell('Pick 5:')
	MadLib.loop_func(pick_5_cards, function(v)
		table.insert(G.GAME.pick_5, {
			rank 	= v.base.value,
			suit 	= v.base.suit
		})
		print(G.GAME.pick_5[#G.GAME.pick_5])
	end)]]
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
    --tell('Play Hand')
    G.GAME.ante.hands = G.GAME.ante.hands + 1
	MadLib.loop_func(G.discard.cards, function(v)
		if v and v.seal == 'rgmc_cherry' then
			tell('Cherry active is'..tostring(v.cherry_active))
			if v.cherry_active then
				G.discard:remove_card(v)
				G.play:emplace(v)
				delay(0.2)
			end
		end
	end)
end

local always_scores_ref = SMODS.always_scores
function SMODS.always_scores(card)
    if always_scores_ref(card) then return true end

	-- cherry comes back and scores :)
	if card.cherry_active then
		card.cherry_active = nil -- get that shit OUTTA HERE
		return true
	end

	return false
end

-- Upon discarding a hand...
function Madcap.Funcs.discard_hand(hand, chips, text)
    -- recording hand
    tell('Discard Hand')
    G.GAME.ante.discards = G.GAME.ante.discards + 1
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
    G.GAME.blinds_skipped = G.GAME.blinds_skipped and G.GAME.blinds_skipped + 1 or 0
end

-- Record hand

function Madcap.Funcs.record_hand_before(scoring_hand,text)
    local hand_type = G.GAME.ante.hand_types[text]

	G.GAME.ante.ranks = G.GAME.ante.ranks or {}
	tell('Jeff time!')
	print(G.GAME.ante.ranks)
	tell(#G.GAME.ante.ranks .. ' ranks recorded.')

	MadLib.loop_func(scoring_hand, function(v)
		local _rank, _suit = v:get_id(), v.base.suit

		G.GAME.ante.ranks[_rank] = G.GAME.ante.ranks[_rank] or 0
		G.GAME.ante.ranks[_suit] = G.GAME.ante.ranks[_suit] or 0

		print(_rank .. ':' .. G.GAME.ante.ranks[_rank])
		print(_suit .. ':' .. G.GAME.ante.ranks[_suit]) -- rank type stuff

        if G.GAME.ante.ranks[_rank] == 0 then
            G.GAME.ante.unique_ranks = G.GAME.ante.unique_ranks + 1
			tell('There are now ' .. tostring(G.GAME.ante.unique_ranks) .. ' unique ranks recorded.')
        end

        -- suit type stuff
        if G.GAME.ante.suits[_suit] == 0 then
            G.GAME.ante.unique_suits = G.GAME.ante.unique_suits + 1
			tell('There are now ' .. tostring(G.GAME.ante.unique_suits) .. ' unique suits recorded.')
        end

        G.GAME.ante.ranks[_rank]	= (G.GAME.ante.ranks[_rank] or 0) + 1
        G.GAME.ante.suits[_suit]	= (G.GAME.ante.suits[_suit] or 0) + 1
        G.GAME.ante.faces_scored = (G.GAME.ante.faces_scored or 0) + (v:is_face(true) and 1 or 0)

    	G.GAME.ante.hand_types[text] = G.GAME.ante.hand_types[text] or 0
    	G.GAME.ante.hand_types[text] = G.GAME.ante.hand_types[text] + 1

        if v.config.center ~= G.P_CENTERS.c_base then G.GAME.last_enhancement = v.config.center end
	end)
end

function Madcap.Funcs.record_hand_after(_chips, _mult, _pow)
	local total_chips = to_big(_chips) ^ (_pow or 1) * to_big(_mult)
    local current_score, high_score = to_big(total_chips), to_big(G.GAME.best_hand.score)

    if high_score < current_score then -- Update high score information
        G.GAME.best_hand = {
            score   = total_chips,
            hand    = MadLib.get_hand_info(G.hand.cards),
            play    = MadLib.get_hand_info(G.play.cards),
            ante    = G.GAME.round_resets.ante
        }
    	SMODS.calculate_context({ rgmc_high_score = total_chips })
		tell('New High Score! (' .. tostring(total_chips) .. ')')
    end
    SMODS.calculate_context({ rgmc_total_score = total_chips })
    return true
end

function Madcap.Funcs.show_tag_effect_text(text)
	attention_text({ scale = 1.25, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7}, major = G.play })
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
    if not (G.GAME and G.GAME.MADCAP and G.GAME.rank_dist) then -- this should work, G.GAME.MADCAP is made on start
        return "Ace"
    end
    local minimum, selection = #G.deck.cards, nil
    local rank_values = { "Queen", "King", "Ace" }
    -- which is the lowest? if tie, prioritize by order
    for i=1, #rank_values do
        local thing, amt = rank_values[i], G.GAME.rank_dist[rank_values[i]] --tell("There are " .. tostring(amt) .. " of " .. tostring(thing) .. ".")
        if amt <= minimum then --tell("That is enough.")
            minimum = amt
            selection = rank_values[i]
        end
    end
    return selection --tell("Rio's really feeling like a "..selection)
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
    return G.GAME
end

-- Is choosing a card. (Used for music!)
function Madcap.Funcs.is_choosing_card()
    return G.booster_pack
end

-- Is choosing a Celestial / Spectral pack. (Used for music!)
function Madcap.Funcs.is_choosing_celestial()
    return G.booster_pack_meteors
end

function Madcap.Funcs.get_boss_status()
	if not (G.GAME and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.defeated) then
		return 0
	elseif not Madcap.Funcs.is_finisher_ante() then
		return 1
	else
		return 2
	end
end

function Madcap.Funcs.is_finisher_ante()
	return G.GAME.round_resets.ante > 0 and G.GAME.round_resets.ante % G.GAME.win_ante == 0
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
	return G.GAME and G.GAME.mayhem or 0
end

function Madcap.Funcs.get_max_mayhem()
	return G.GAME and G.GAME.max_mayhem or 10
end

function Madcap.Funcs.get_mayhem_state()
	local mayhem = (G.GAME.mayhem or 0)

	local mayhem_state = 0
	if mayhem > 9 then
		mayhem_state = 3
	elseif mayhem >= 6 then
		mayhem_state = 2
	elseif mayhem >= 3 then
		mayhem_state = 1
	end

	return mayhem_state
end

function Madcap.Funcs.read_mayhem()
	tell('Mayhem is now ' .. tostring(G.GAME.mayhem) .. ' / ' .. tostring(G.GAME.max_mayhem) .. '.')
	tell('Mayhem State is now ' .. tostring(Madcap.Funcs.get_mayhem_state()) .. '.')
end

function MadLib.compare_numbers(a,b,and_equals)
	local v1 = type(a) == 'number' and to_big(a) or a
	local v2 = type(b) == 'number' and to_big(b) or b
	return (and_equals and v1 >= v2) or (v1 > v2)
end

function Madcap.Funcs.ease_mayhem(_mod, _check, _silent, _instant)
	_mod = _mod or 0
    MadLib.simple_event(function()
        local round_UI = G.HUD:get_UIE_by_ID('mayhem_UI_count')
        local add_mayhem, lose_mayhem = to_big(_mod) > to_big(0), to_big(_mod) < to_big(0)
        local text  = add_mayhem and '+' or ''
        local col   = (add_mayhem and G.C.RGMC_MAYHEM) or (lose_mayhem and G.C.RED) or G.C.FILTER

		local _old = (G.GAME.mayhem or 0)
        G.GAME.mayhem = _old + _mod
        if MadLib.compare_numbers(G.GAME.mayhem, G.GAME.max_mayhem) then
			_mod = G.GAME.max_mayhem - (G.GAME.mayhem + _mod)
		end

        if round_UI then
            G.HUD:recalculate()
            if MadLib.is_animation_enabled() then
                attention_text({
                    text            = text .. tostring(math.abs(_mod)),
                    scale           = 1,
                    hold            = _instant and 0 or 0.7,
                    cover           = round_UI.parent,
                    cover_colour    = col,
                    align           = 'cm',
                })
            end
        end

		local _new = lenient_bignum(_old + _mod)

		local mayhem_state 		= Madcap.Funcs.get_mayhem_state(recalculate)
		local sound 			= 'rgmc_mayhem_t' .. tostring(math.max(1,math.min(3,mayhem_state)))

        --Play a SPOOKY noise sound
        if MadLib.is_animation_enabled() and not _silent then
            if lose_mayhem then
                play_sound('rgmc_mayhem_down', 0.8)
                play_sound('timpani')
			elseif add_mayhem then
				if mayhem_state > G.GAME.mayhem_state then
					play_sound(sound)
					delay(2.0)
				else
					play_sound('timpani')
					play_sound('rgmc_mayhem_up', 0.8)
				end
            end
        end

		if mayhem_state ~= G.GAME.mayhem_state then
			G.GAME.mayhem_state = mayhem_state
		end


        SMODS.calculate_context({ mayhem_changed = G.GAME.mayhem })
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
    local _diff = (_mod or G.GAME.mayhem) - G.GAME.mayhem
	if _diff < -G.GAME.mayhem then _diff = -G.GAME.mayhem end
    return Madcap.Funcs.ease_mayhem(_diff, _check, _silent, _instant)
end

-- Add Remove Joker to contexts
local sd = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
    --[[if G.GAME.MADCAP then
        SMODS.calculate_context({ remove_joker = self })
    end]]
    return sd(self,a,b,c,d)
end

-- General function for setting temporary stickers (which Madcap incorporates a lot of!)
function Card:set_temp_sticker(id,bool,tally)
    self.ability[id]                = bool
    self.ability[id .. '_tally']    = tally or 1
	SMODS.Stickers[id]:apply(self,bool)
end

function Card:set_rgmc_immutable(bool)
    self.ability['rgmc_immutable'] = bool or (self.ability['rgmc_immutable'] and not self.ability['rgmc_immutable']) or true
end

-- A handy little sticker
function Madcap.Funcs.handle_sticker_calculation(self,id,eval)
    local tally = id .. '_tally'
    if self.ability[id] and self.ability[tally] > 0 then
        if self.ability[tally] <= 1 then
            self.ability[tally] = 0
            -- if in hand, show the sticker coming off
            for i=1, #G.hand.cards do
                if G.hand.cards[i] == self then -- show it coming off
                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = localize('k_removed_ex'),
                        colour = G.C.FILTER,
                        delay = 0.45
                    })
                    break -- we are done
                end
            end
            self.ability[id] = false
            SMODS.Stickers[id]:apply(self,false)
        else
            self.ability[tally] = self.ability[tally] - 1
            for i=1, #G.hand.cards do
                if G.hand.cards[i] == self then -- show the countdown
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
		if card and card.ability[Madcap.CardReturnList[i].id..'_active'] then
			_id = Madcap.CardReturnList[i]
			break
		end
	end

	if _rvals then
		to 		= _rvals.to or to
		dir 	= _rvals.dir or dir
		sort 	= _rvals.sort or sort
		card.ability[_rvals.id..'_active'] = nil
		tell('Wow! Got a ' .. _rvals.id)
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
	--print('Glass card is ' .. (dead and 'dead' or 'alive') .. '.')
    return dead -- if the card would be dead, then let the game know
end

-- At end of round, check on Sinister Card timers
local end_round_ref = end_round
function end_round()
	-- sinister card round tickers
	if G.GAME.rgmc_sinister then
		MadLib.loop_table(G.GAME.rgmc_sinister, function(k,v)
			MadLib.simple_event(function()
				local sin_table = G.GAME.rgmc_sinister[k]
				sin_table.rounds = (G.GAME.rgmc_sinister.rounds or 1) - 1
				if sin_table.rounds == 0 then -- rounds ended
					if sin_table.money ~= nil then -- gain money
						ease_dollars(sin_table.money)
					elseif sin_table.consumeable ~= nil then -- gain consumeable slots
						G.consumeables.config.card_limit = lenient_bignum(G.consumeables.config.card_limit + (sin_table.consume_slots or 1))
					elseif sin_table.h_size ~= nil then -- gain consumeable slots
						G.hand.config.card_limit = lenient_bignum(G.hand.config.card_limit + (sin_table.consume_slots or 1))
					end
					G.GAME.rgmc_sinister[k] = nil
				end
			end)
			delay(2.0)
		end)
	end
	end_round_ref() -- continue as usual
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
	--tell('Easing moment')
	if
		G.GAME.modifiers.bankrupt_kill
        and (to_big(G.GAME.dollars) + to_big(mod)) <= to_big(G.GAME.bankrupt_at)
	then
		MadLib.event({
			func = function()
				tell('You are now bankrupt.')
				play_area_status_text("BANKRUPT!")
			return true
			end,
			delay 	= 5.0,
			trigger = 'after',
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

function table_loopy(table)
	for k,v in pairs(table) do
		if type(v) ~= 'table' then
			print(tostring(k) .. ': ' .. tostring(v))
		end
	end
end

function Madcap.Funcs.is_void(card)
	return card.base.suit == 'rgmc_voids'
end

function Madcap.Funcs.is_lantern(card)
	return card.base.suit == 'rgmc_lanterns'
end

function Madcap.Funcs.get_void_mayhem()
	return 0.1
end

function Madcap.Funcs.get_lantern_mayhem()
	return -0.1
end


function Madcap.Funcs.check_eval_card(card,i)
	--G.GAME.blind_stats = G.GAME.blind_stats or {}
	if not SMODS.has_no_suit(card) then -- has a suit
		table.insert(G.GAME.blind_stats.suits, card.base.suit)
	end
	if not SMODS.has_no_rank(card) then -- has a rank
		table.insert(G.GAME.blind_stats.ranks, card.base.value)
	end

	-- handle mayhem stuff
	if Madcap.Funcs.is_void(card) then
		table_loopy(card.ability)
		local mayhem_gain = 0.1
		local eval = {
			message = '+' .. tostring(mayhem_gain) .. ' M!',
			colour = G.C.RED,
			func = function()
				Madcap.Funcs.ease_mayhem(mayhem_gain)
			end
		}
		card_eval_status_text(card, "extra", nil, nil, nil, eval)
	elseif Madcap.Funcs.is_lantern(card) then
		local mayhem_loss = -0.1
		local eval = {
			message = tostring(mayhem_loss) .. ' M!',
			colour = G.C.RED,
			func = function()
				Madcap.Funcs.ease_mayhem(mayhem_loss)
			end
		}
		card_eval_status_text(card, "extra", nil, nil, nil, eval)
	end
end

function Madcap.Funcs.clamp_mayhem(m)
	local mod = m + 0
	local mayhem, max_mayhem = G.GAME.mayhem or 0, G.GAME.max_mayhem or 10
	return (mayhem + mod > 0 and mayhem + mod <= max_mayhem) and m or (mod < 0) and -mayhem or (max_mayhem - mayhem)
end

function Madcap.Funcs.calculate_mayhem_decay(max_mult)
	-- Mayhem decay
	local mayhem = G.GAME.mayhem or 0
	local max_mayhem_mult = max_mult or 1.10
	local mayhem_mult = MadLib.clamp(G.GAME.mayhem_decay or 0.85, 0.5, max_mayhem_mult)

	local voids, lanterns, modded_suits, base_suits,enhancements,editions,seals = 0,0,0,0,0,0,0
	local suits = {}

	MadLib.loop_func(G.playing_cards, function(v)
		-- Voids add more Mayhem than other suits.
		suits[v.base.suit] = true
		suits[v.base.suit] = true
		local check_modded = true
		if v:is_suit('rgmc_voids') then
			voids = voids + 1
			check_modded = false
		end
		-- Lanterns reduce mayhem despite being a modded suit.
		if v:is_suit('rgmc_lanterns') then
			lanterns = lanterns + 1
			check_modded = false
		end
		-- Modded suits add Mayhem, Base suits reduce it
		if check_modded and not MadLib.list_matches_one(MadLib.SuitTypes.Base, function(s)
			return v:is_suit(s)
		end) then
			modded_suits = modded_suits + 1 -- goblets/towers/blooms/daggers/etc.
		else
			base_suits = base_suits + 1 -- hearts/diamonds/spades/clubs
		end
		if v.config.center.key ~= 'c_base' then -- has an enhancement
			enhancements = enhancements + 1
		end
		if v.edition then -- has an edition
			editions = editions + 1
		end
		if v.seal then -- has a seal
			seals = seals + 1
		end
	end)

	local starting_cards = 52 -- TODO: modify for decks that start out with fewer cards

	local sc_deviation = math.abs(#G.playing_cards - starting_cards)
	--mayhem_mult = mayhem_mult * 0.9 * (1.01 ^ sc_deviation)

	local exponentials = {
		{n1 = 1.050, n2 = voids },
		{n1 = 0.925, n2 = lanterns },
		{n1 = 1.025, n2 = modded_suits },
		{n1 = 1.020, n2 = base_suits },
		{n1 = 1.025, n2 = editions },
		{n1 = 1.015, n2 = enhancements },
		{n1 = 1.005, n2 = seals },
		{n1 = 1.005, n2 = sc_deviation },
	}

	MadLib.loop_func(exponentials, function(v)
		local result = mayhem_mult * (v.n1 ^ v.n2)
		tell(tostring(mayhem_mult) .. " * " .. "( " .. tostring(v.n1) .. " ^ " .. tostring(v.n2) .. " ) = " .. tostring(result))
		mayhem_mult = result
	end)

	local mayhem_product = MadLib.round(math.max(0.5, math.min(mayhem_mult, max_mayhem_mult)), 2)
	tell('Final Mayhem product is ' .. tostring(mayhem_product) .. '.')

	return MadLib.round(mayhem - math.min(mayhem - (mayhem * mayhem_product), mayhem), 2)
end

function Madcap.Funcs.blind_end_mayhem_check()

	local mayhem_add = Madcap.Funcs.calculate_mayhem_decay()
	Madcap.Funcs.set_mayhem(mayhem_add, true, false)
	local mayhem_state = G.GAME.mayhem_state or 0
	Madcap.Funcs.read_mayhem()

	local args

	-- state 1: randomize values
	if mayhem_state > 0 then
		MadLib.loop_func(G.playing_cards, function(v,i)
			Madcap.Funcs.mayhemize(v, args, true)
		end)

		MadLib.loop_func(G.jokers.cards, function(v,i)
			Madcap.Funcs.mayhemize(v, args)
		end)
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
	if type(group) ~= 'table' then return -1 end
	local total = 0
	MadLib.loop_func(group or G.hand.cards, function(v)
		local irregular = v:rank_in_list(MadLib.RankTypes.Irregular)
		local no_rank = SMODS.has_no_rank(v)

		--tell('Irregular: ' .. tostring(irregular) .. ', ' .. 'No Rank: ' .. tostring(no_rank))

		if not (irregular or no_rank) then
			total = total + SMODS.Ranks[v.base.value].nominal
		elseif v:get_id() == 'rgmc_X' then -- X rank gives a random value
			total = total + (G.GAME.x_value or 0)
		end
	end)
	--tell('Counted ' .. tostring(#group) .. ' cards for a total of ' .. tostring(total) .. '.')
	return total
end

Madcap.Funcs.get_sigma_value = Madcap.Funcs.get_hand_sigma

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
		elseif v:get_id() == 'rgmc_X' then -- X rank gives a random value
			total = total + G.GAME.x_value
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

table.insert(SMODS.calculation_keys, "rgmc_luxury_pts")
if SMODS.other_calculation_keys then
    table.insert(SMODS.other_calculation_keys, "rgmc_luxury_pts")
end

-- Calculate individual effect fixing
if SMODS and SMODS.calculate_individual_effect then
	local cie = SMODS.calculate_individual_effect
	function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		local ret = cie(effect, scored_card, key, amount, from_edition)

		if -- squeezy cheese detection
			MadLib.list_matches_one({'x_mult', 'xmult', 'x_mult_mod', 'xmult_mod'}, function(v)
				return v == string.lower(key)
			end) and amount ~= 1
		then
			MadLib.loop_func(SMODS.find_card('j_rgmc_squeezy_cheeze'), function(v)
				v.ability.extra.xmult_store = lenient_bignum(to_big(v.ability.extra.xmult_store) + to_big(amount))

				if v.ability.extra.xmult_store > 1 then
				tell("New xmult_store is "..lenient_bignum(v.ability.extra.xmult_store))
					local m = 0
					while (v.ability.extra.xmult_store - 1) > 0 do
						v.ability.extra.xmult_store = v.ability.extra.xmult_store - 1 -- go down bith
						m = m + 1
					end
					local xm = 1 + v.ability.extra.xchip_mod * m
					MadLib.simple_event(function()
						play_sound("tarot2")
						v:juice_up()
						return true
					end)
					card_eval_status_text(v, "extra", nil, nil, nil, {
						message = localize({
							type = "variable",
							key = "a_xchips",
							vars = { number_format(xm) },
						}),
						colour = G.C.CHIPS,
					})
					hand_chips = mod_chips(to_big(hand_chips) * to_big(xm)) -- stupid way of doing x1.5 chips
				end
			end)
		end
		-- luxury points
		if key == "rgmc_luxury_pts" then
			amount = math.max(amount,0)
			G.GAME.rgmc_luxury_pts = G.GAME.rgmc_luxury_pts + amount
			text = "+£"..number_format(amount)
			if from_edition then
				card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = text, colour = G.C.RGMC_LUXURY, sound = 'rgmc_kaching', edition = true})
			else
				card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, {message = text, colour = { 0.8, 0.45, 0.85, 1 }, sound = 'rgmc_kaching', edition = true})
			end
			return true
		end

		if -- Squeezy (Partner)
			MadLib.list_matches_one({'chips', 'chip_mod', 'chips_mod'}, function(v)
				return key == string.lower(v)
			end) and amount ~= 1
		then
			-- Squeezy (Partner)
			if Partner_API then
				if Madcap.Funcs.get_partner_key() == 'pnr_rgmc_squeezy' then
					local _partner = G.GAME.selected_partner_card
					_partner.ability.immutable.before_score = _partner.ability.immutable.before_score + amount
					tell('+chips is now ' ..string(_partner.ability.immutable.before_score))
				end
			end
		end
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

function Card:glass_michel_save()
	tell('Glass Michel saved!')
	self.ability.glass_michel = nil -- no longer needed
	MadLib.simple_event(function()
        play_sound('rgmc_glass_save', 1, 0.5)
		G.play:remove_card(card)
		G.discard:emplace(self)
		return true
	end, 1.5, 'after')
end

-- Glass Michel better work.
local shatter_ref = Card.shatter
function Card:shatter()
	if self.ability.glass_michel then
		self:glass_michel_save()
	else
		print('shatter')
		shatter_ref(self)
	end
end

-- temporary discard addition
local ease_discard_ref = ease_discard
function ease_discard(mod, instant, silent)
	ease_discard_ref(mod,instant,silent)
	--tell_stat('discards',G.GAME.current_round.discards_left)
    if
        G.GAME.current_round.discards_left + mod == 0
        and G.GAME.temporary_discards > 0
    then
        ease_discard(1, instant, silent)
        G.GAME.temporary_discards = G.GAME.temporary_discards - 1
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
	--tell_stat('hands',G.GAME.current_round.hands_left)
    if
        G.GAME.current_round.hands_left + mod == 0
        and G.GAME.temporary_hands > 0
    then
        ease_hands_played(1, instant, silent)
        G.GAME.temporary_hands = G.GAME.temporary_hands - 1
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
		and G.GAME.deck_finishers 		-- has a deck finisher list
		and G.GAME.round_resets.ante > 0	-- dont do it ante 0 or earlier :(
		and G.GAME.round_resets.ante % G.GAME.win_ante == 0
	then
		local yes_please = G.GAME.round_resets.ante <= G.GAME.win_ante

		if not yes_please then -- past ante 8
			if SMODS.pseudorandom_probability(nil, 'finisher_blind', 1, 3) then
				yes_please = true -- 1 in 3 chance to do the thing
			end
		end

		if yes_please then
			local eligible_bosses = {}

			for _, v in pairs(G.GAME.deck_finishers) do -- might be more than one
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
	if G.GAME.force_finisher_blind then
		G.GAME.force_finisher_blind = nil -- dont need this anymore

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
						G.playing_cards[i]:remove()
                    else
                        local m = math.ceil(i/ranks)
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

                    if i > deck_size then
                        G.playing_cards[i]:remove()
					else
						assert(SMODS.change_base(G.playing_cards[i], _suit, _rank))
						suit_index 	= suit_index + 1
						total 		= total + 1
						if suit_index > suit_size then
							suit_index	= 1
							rank_index	= rank_index + 1
						end
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

	if to_big(amount or 1) > to_big(0) then -- actually levelling up the hand
		if  -- Rocket Keychain: using specific Planet card levels up most played hand as well!
			#SMODS.find_card('j_rgmc_rocket_keychain') > 0
		then
			-- loop thru
			MadLib.loop_func(G.jokers.cards, function(v)
				if
					v.config.center.key == 'j_rgmc_rocket_keychain'
					and hand == v.ability.extra.target_hand
				then
					level_up_hand_ref(card, MadLib.get_most_played_hand(), instant, v.ability.extra.level_ups)
				end
			end)
		end
	end
	level_up_hand_ref(card, hand, instant, amount)
end

function Madcap.Funcs.level_up_subhand(card, hand, instant, amount, context)
	amount = amount or 1
	local basic_func = true
    G.GAME.subhands[hand].level = math.max(0, G.GAME.subhands[hand].level + amount)

	-- CRYPTID: Universum also applies to sub-hands?!
    if next(find_joker('cry-Universum')) then
        universum_mod = 1
        local effects = {}
        SMODS.calculate_context({cry_universum = true}, effects)
        for i = 1, #effects do
            universum_mod = universum_mod * (effects[i] and effects[i].jokers and effects[i].jokers.mod or 1)
        end
        G.GAME.subhands[hand].mult 	= G.GAME.subhands[hand].mult 	* (universum_mod)^amount
        G.GAME.subhands[hand].chips = G.GAME.subhands[hand].chips 	* (universum_mod)^amount
		basic_func = false
	end

	if basic_func then
    	G.GAME.subhands[hand].mult 	= G.GAME.subhands[hand].mult 	+ G.GAME.subhands[hand].l_mult*amount
    	G.GAME.subhands[hand].chips = G.GAME.subhands[hand].chips 	+ G.GAME.subhands[hand].l_chips*amount
	end

    if not instant and MadLib.is_animation_enabled() then
        MadLib.event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.6, 0.35) end
            G.TAROT_INTERRUPT_PULSE = true
            return true end })
        update_hand_text({delay = 0}, {mult = MadLib.calculate_mult(G.GAME.subhands[hand].mult), StatusText = true})
        MadLib.event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.6, 0.35) end
            return true end })
        update_hand_text({delay = 0}, {chips = MadLib.calculate_chips(G.GAME.subhands[hand].chips), StatusText = true})
        MadLib.event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            if card and card.juice_up then card:juice_up(0.6, 0.35) end
            G.TAROT_INTERRUPT_PULSE = nil
            return true end })
        update_hand_text({sound = 'rgmc_pop', volume = 0.7, pitch = 1.0, delay = 0}, {level = G.GAME.subhands[hand].level})
        delay(2.0)
    end
end

function Madcap.Funcs.pulse_flame(duration, intensity) -- duration is in seconds
	G.rgmc_flame_override 				= G.rgmc_flame_override or {}
	G.rgmc_flame_override["duration"] 	= duration or 0.01
	G.rgmc_flame_override["intensity"] 	= intensity or 2
end

function Madcap.Funcs.calculate_empower_bonus(hand)
	if not G.GAME.subhands or G.GAME.subhands[hand] then return 0 end

	local level 	= G.GAME.subhands[hand].level
	local emplvl 	= (G.GAME.subhands[hand].empower or 0)
	local chips 	= G.GAME.subhands[hand].chips 	^ (1 + level * 0.002) ^ (1 + emplvl * 0.005)
	local mult 		= G.GAME.subhands[hand].mult 	^ (1 + level * 0.002) ^ (1 + emplvl * 0.005)

	return math.ceil(chips), math.ceil(mult)
end

function Madcap.Funcs.evolve_subhand(card, hand, instant, amount, context)
	amount = amount or 1
	local basic_func = true
	local evolve_level = (G.GAME.subhands[hand].evolve or 0)

	if basic_func then
    	evolve_level = math.max(0, evolve_level + amount)
	end
    if not instant then
        -- update the UI before setting the new values
		update_hand_text({
            sound = 'button', volume = 0.7, pitch = 0.8, delay = 1.0
        }, {
            handname = localize('ml_sh_'..hand),
            level    = G.GAME.subhands['ml_sh_'..hand].level,
            chips    = '...',
            mult     = '...'
        })

		if MadLib.is_animation_enabled()  then
			local nu_chips, nu_mult = mfuncs.calculate_empower_bonus(hand)

			update_hand_text({ sound = 'rgmc_empower', volume = 0.7, pitch = 0.8, delay = 2.5 }, {
				handname = localize(hand),
				level    = lenient_bignum(evolve_level),
				chips    = number_format(nu_chips),
				mult     = number_format(nu_mult)
			})
			MadLib.simple_event(function()
				ease_colour(G.C.UI_CHIPS, copy_table(G.C.RGMC_EVIL), 0.1)
				ease_colour(G.C.UI_MULT, copy_table(G.C.RGMC_EVIL), 0.1)
				Madcap.Funcs.pulse_flame(0.01, evolve_level)
				MadLib.event({
					trigger = "after",
					blockable = false,
					blocking = false,
					delay = 2.5,
					func = function()
					ease_colour(G.C.UI_CHIPS, G.C.BLUE, 1)
					ease_colour(G.C.UI_MULT, G.C.RED, 1)
					return true
					end,
				})
				return true
			end, 2.5, 'after')
		end
	end

	update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = to_big(empower_level) })
	delay(2.6)
    G.GAME.subhands[hand].empower = empower_level
	MadLib.clear_hand_text()
end

function Madcap.Funcs.empower_subhand(card, hand, instant, amount, context)
	amount = amount or 1
	local basic_func = true
	local empower_level = (G.GAME.subhands[hand].empower or 0)

	if basic_func then
    	empower_level = math.max(0, empower_level + amount)
	end
    if not instant then
        -- update the UI before setting the new values
		update_hand_text({
            sound = 'button', volume = 0.7, pitch = 0.8, delay = 1.0
        }, {
            handname = localize(hand),
            level    = G.GAME.subhands[hand].level,
            chips    = G.GAME.subhands[hand].chips,
            mult     = G.GAME.subhands[hand].mult
        })

		if MadLib.is_animation_enabled()  then
			local nu_chips, nu_mult = mfuncs.calculate_empower_bonus(hand)
			update_hand_text({ sound = 'rgmc_empower', volume = 0.7, pitch = 0.8, delay = 2.0 }, {
				handname = localize(hand),
				level    = lenient_bignum(empower_level),
				chips    = lenient_bignum(nu_chips),
				mult     = lenient_bignum(nu_mult)
			})
			MadLib.simple_event(function()
				ease_colour(G.C.UI_CHIPS, copy_table(G.C.RGMC_UNUSUAL), 0.1)
				ease_colour(G.C.UI_MULT, copy_table(G.C.RGMC_UNUSUAL), 0.1)
				Madcap.Funcs.pulse_flame(0.01, empower_level)
				MadLib.event({
					trigger = "after",
					blockable = false,
					blocking = false,
					delay = 2.5,
					func = function()
					ease_colour(G.C.UI_CHIPS, G.C.BLUE, 1)
					ease_colour(G.C.UI_MULT, G.C.RED, 1)
					return true
					end,
				})
				return true
			end, 2.5, 'after')
		end
	end
	update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 2.0 }, { level = to_big(empower_level) })
	delay(2.6)
    G.GAME.subhands[hand].empower = empower_level
	MadLib.clear_hand_text()
end

function Madcap.Funcs.use_spatia_card(card)
	MadLib.loop_func(card.ability.subhands, function(v)
		Madcap.Funcs.card_level_subhand(card,v)
	end)
	MadLib.loop_func(card.ability.hands, function(v)
		Madcap.Funcs.card_level_hand(card,v)
	end)
end

function Madcap.Funcs.card_level_hand(card, hand_type)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {
		handname 	= localize(hand_type, 'poker_hands'),
		chips 		= G.GAME.hands[hand_type].chips,
		mult 		= G.GAME.hands[hand_type].mult,
		level		= G.GAME.hands[hand_type].level
	})
    level_up_hand(card, hand_type)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    if G.GAME.current_round.current_hand.handname ~= "" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.hand:parse_highlighted()
                return true
            end
        }))
    end
end

function Madcap.Funcs.use_potentia_card(card)
	local subhand = SubHands[card.ability.subhand or 'Balanced'].name
	Madcap.Funcs.empower_subhand(card, subhand, false, card.ability.levels or 1)
end

function Madcap.Funcs.get_planet_vars(id)
    return {
        vars = {
            localize(id),
            G.GAME.hands[id].level,
            G.GAME.hands[id].l_mult,
            G.GAME.hands[id].l_chips,
			colours = {(to_big(G.GAME.hands[id].level) == to_big(1) and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands[id].level))])},
        },
    }
end

function Madcap.Funcs.get_spatia_vars(hand_list, subhand_list)
	local all_vars     = { }
	local all_colours  = { }

	MadLib.loop_func(hand_list, function(ha)
		local hand = G.GAME.hands and G.GAME.hands[ha]
		table.insert(all_vars, hand and hand.level or 1)
		table.insert(all_vars, localize(ha,'poker_hands') or "???")
		table.insert(all_vars, hand and hand.l_mult or 0)
		table.insert(all_vars, hand and hand.l_chips or 0)
		table.insert(all_colours,(
			to_big(hand and hand.level or 1) == to_big(1) and G.C.UI.TEXT_DARK
			or G.C.HAND_LEVELS[to_number(math.min(7, hand and hand.level or 1))]
		))
	end)

	MadLib.loop_func(subhand_list, function(sh)
		local subhand = G.GAME.subhands and G.GAME.subhands[SubHands[sh].name]
		table.insert(all_vars, subhand and subhand and subhand.level or 1)
		table.insert(all_vars, localize(SubHands[sh].name))
		table.insert(all_vars, (subhand and subhand.l_mult 
			or SubHands[sh].l_mult) + 1)
		table.insert(all_vars, (subhand and subhand.l_chips 
			or SubHands[sh].l_chips) + 1)
		table.insert(all_colours,(
			to_big(subhand and subhand.level or 1) == to_big(1) and G.C.UI.TEXT_DARK
			or G.C.HAND_LEVELS[to_number(math.min(7, subhand and subhand.level or 1))]
		))
	end)
	all_vars['colours'] = all_colours
	return { vars = all_vars }
end

function Madcap.Funcs.get_moon_card_vars(sh,levels)
	local subhand 	= G.GAME.subhands and G.GAME.subhands[SubHands[sh].name]
	local current_level = subhand and subhand.level or 1
    return {
        vars = {
            current_level,
            localize(SubHands[sh].name),
            (subhand and subhand.l_mult
				or SubHands[sh].l_mult) + 1,
            (subhand and subhand.l_chips
				or SubHands[sh].l_chips) + 1,
			colours = { ( to_big(subhand and subhand.level or 1) == to_big(1) and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[to_number(math.min(7, subhand and subhand.level or 1))]), }
        }
    }
end

function Madcap.Funcs.get_special_card_vars(set,xchips,xmult)
    return {
        vars = {
			localize(MadLib.get_most_played_hand(), 'poker_hands'),
			xchips or 0,
			xmult or 0,
			MadLib.get_consumeable_usage(set) * (xchips or 0) + 1,
			MadLib.get_consumeable_usage(set) * (xmult or 0) + 1,
			colours = { G.C.RGMC_MAYHEM }
        }
    }
end

function Madcap.Funcs.get_potentia_vars(sh,lvl)
	local subhand 	= G.GAME.subhands and G.GAME.subhands[SubHands[sh].name]
	local current_level = subhand and subhand.level 	or 1
	local empower_level = subhand and subhand.empower 	or 0
    return {
        vars = {
            current_level,
            (empower_level > 0) and (" + " .. empower_level .."") or "",
            localize(SubHands[sh].name),
            lvl,
			colours = {
				to_big(current_level) < to_big(2) and G.C.BLACK or G.C.HAND_LEVELS[to_number(math.min(7, current_level))]
			}
        },
    }
end

function Madcap.Funcs.use_consumable_specific_special_card(card)

end

function Madcap.Funcs.add_anti_tag(t)
	add_tag(Tag('tag_rgmc_anti_'..t))
	return G.GAME.tags[#G.GAME.tags]
end

function Madcap.Funcs.handle_edition_tag_logic(self,tag,context)
	if not context then
		return false
	elseif context.type == self.config.type then
		local _applied = nil
		if (Cryptid and Cryptid.forced_edition()) then
			tag:nope()
		end
		if not (context.card.edition or context.card.temp_edition) and context.card.ability.set == "Joker" then
			local lock = tag.ID
			G.CONTROLLER.locks[lock] = true
			context.card.temp_edition = true
			tag:yep("+", G.C.DARK_EDITION, function()
				context.card:set_edition('e_'..card.ability.edition, true)
				context.card.ability.couponed = true
				context.card:set_cost()
				context.card.temp_edition = nil
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			_applied = true
			tag.triggered = true
			return true
		end
	end
end

function Madcap.Funcs.booster_ease_bg(obj,color1,color2,cont)
	ease_background_colour_blind({ new_colour = color1, special_colour = color2, contrast = (cont or 2) })
end

function Madcap.Funcs.booster_create_card(_set,args)
	local _card
        _card = {
			set = _set,
            area = G.pack_cards,
            skip_materialize = (args.skip_materialize) or true,
            soulable = (args and args.soulable) or false,
            key_append = "madcap"
        }
	return _card
end

function Madcap.Funcs.activate_edition(self, tag, context)
	if context.type == self.config.type then
		local applied = nil
		if context.card and not (context.card.edition or context.card.temp_edition) and context.card.ability.set == 'Joker' then
			local lock = tag.ID
			G.CONTROLLER.locks[lock] = true
			context.card.temp_edition = true
			tag:yep('+', G.C.DARK_EDITION, function()
				context.card:set_edition(self.config.edition or 'e_foil', true)
				context.card.ability.couponed = true
				context.card:set_cost()
				context.card.temp_edition = nil
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			applied = true
			tag.triggered = true
		end
		return applied
	end
end

local function get_compatible_jokers(_list, _area)
	return MadLib.get_list_matches(_list,function(w)
		return MadLib.list_matches_one(_area, function(v)
			return v.config.center.key == w
		end)
	end)
end

function Madcap.Funcs.create_joker_from_mod(mod, area) -- TODO: add weights and legendary restrictions
    if not MadLib.JokerLists.Mods[mod] then return nil end
	local _temp = {
		set 	= "Joker",
		area 	= area or G.jokers,
		key 	= pseudorandom_element(MadLib.JokerLists.Mods[mod], pseudoseed('rgmc')),
	}
	local _card = SMODS.create_card(_temp)
	return _card

end

function Madcap.Funcs.digital_hallucinations_compat(type, text, color)

end

function Madcap.Funcs.digihal_prepare(_card,_area)
	_card:set_edition({ negative = true }, true)
	_card:add_to_deck()
	_area:emplace(_card)
end
function Madcap.Funcs.get_simple_edition_locvar(self, info_queue, tag)
	info_queue[#info_queue + 1] = G.P_CENTERS[self.config.edition]
	return Madcap.BlankVar
end

function Madcap.Funcs.open_booster_quick(key)
	local card = Card(
		G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
		G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
		G.CARD_W * 1.27,
		G.CARD_H * 1.27,
		G.P_CARDS.empty,
		G.P_CENTERS[key],
		{ bypass_discovery_center = true, bypass_discovery_ui = true }
	)
	card.cost = 0
	card.from_tag = true
	G.FUNCS.use_card({config = { ref_table = card } })
	card:start_materialize()
	G.CONTROLLER.locks[lock] = nil
	return true
end

function Madcap.Funcs.do_rarity_tag(self, tag, context, params)
	if not context then
		return false
	elseif context.type == "store_joker_create" then
		local posession = { 0 }
		for k, v in ipairs(G.jokers.cards) do
			if
				v.config.center.rarity == self.config.extra
				and not posession[v.config.center.key]
			then
				posession[1] = rares_in_posession[1] + 1
				posession[v.config.center.key] = true
			end
		end

		local card = nil
		if #G.P_JOKER_RARITY_POOLS[self.config.extra] > posession[1] then
			card = create_card("Joker", context.area, nil, tag.abillity.extra, nil, nil, nil, "rgmc")
			create_shop_card_ui(card, "Joker", context.area)
			card.states.visible = false
			tag:yep("+", G.C.RARITY[self.config.extra], function()
				card:start_materialize()
				card.misprint_cost_fac = (params and params.cost_fac) or 0
				card:set_cost()
				return true
			end)
		else
			tag:nope()
		end

		tag.triggered = true
		return card
	end
end

Madcap.BlankVar = { vars = {} }

-- Edition decks
if Cryptid and Cryptid.edeck_sprites then
    local cryptid_atlas = "rgmc_cryptid_decks"
    Cryptid.edeck_sprites.enhancement.m_rgmc_ferrous = { atlas = cryptid_atlas, pos = { x = 0, y = 0} }
    Cryptid.edeck_sprites.enhancement.m_rgmc_wolfram = { atlas = cryptid_atlas, pos = { x = 1, y = 0} }
    Cryptid.edeck_sprites.enhancement.m_rgmc_lustrous = { atlas = cryptid_atlas, pos = { x = 2, y = 0} }
    Cryptid.edeck_sprites.seal.rgmc_patina = { atlas = cryptid_atlas, pos = { x = 0, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_bronze = { atlas = cryptid_atlas, pos = { x = 1, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_jade = { atlas = cryptid_atlas, pos = { x = 2, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_cream = { atlas = cryptid_atlas, pos = { x = 3, y = 2} }
    Cryptid.edeck_sprites.seal.rgmc_umber = { atlas = cryptid_atlas, pos = { x = 4, y = 2} }
    Cryptid.edeck_sprites.edition.rgmc_iridescent = { atlas = cryptid_atlas, pos = { x = 1, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_infernal = { atlas = cryptid_atlas, pos = { x = 0, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_chrome = { atlas = cryptid_atlas, pos = { x = 3, y = 1} }
    Cryptid.edeck_sprites.edition.rgmc_disco = { atlas = cryptid_atlas, pos = { x = 2, y = 1} }
    Cryptid.edeck_sprites.suit.rgmc_goblets = { atlas = cryptid_atlas, pos = { x = 3, y = 0} }
    Cryptid.edeck_sprites.suit.rgmc_towers = { atlas = cryptid_atlas, pos = { x = 4, y = 0} }
end

-- Quick way of determining whether the context involves editions
-- (usually trigger if a Joker or scoring card has one)
function Madcap.Funcs.edition_in_play(context, card)
	return (
		context.edition
		and context.cardarea == G.jokers
		and card.config.trigger
	) or (
		context.main_scoring
		and context.cardarea == G.play
	)
end

function Madcap.Funcs.get_potentia_card_vars(sh,lvl)
	local subhand 		= G.GAME.subhands and G.GAME.subhands[SubHands[sh].name]
	local current_level = subhand and subhand.level 	or 1
	local empower_level = subhand and subhand.empower 	or 0
    return {
        vars = {
            current_level,
            (empower_level > 0) and (" + " .. empower_level .."") or "",
            localize(SubHands[sh].name),
            lvl,
			colours = { to_big(current_level) < to_big(2) and G.C.BLACK or G.C.HAND_LEVELS[to_number(math.min(7, current_level))] }
        },
    }
end

function Madcap.Funcs.use_moon_card(card)
	MadLib.loop_func(card.ability.subhands, function(v) Madcap.Funcs.card_level_subhand(card,v) end)
end

function Madcap.Funcs.card_level_subhand(card, sh)
	local subhand = SubHands[sh].name
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 2.0}, {
		handname	= localize(subhand),
		chips 		= G.GAME.subhands[subhand].chips,
		mult 		= G.GAME.subhands[subhand].mult,
		level 		= G.GAME.subhands[subhand].level
	})
    Madcap.Funcs.level_up_subhand(card, subhand)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 2.0}, {mult = 0, chips = 0, handname = '', level = ''})
    if G.GAME.current_round.current_hand.handname ~= "" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.hand:parse_highlighted()
                return true
            end
        }))
    end
end

function Madcap.Funcs.get_flame_intensity_override(_F,flame)

	if
		G.cry_flame_override
		and G.cry_flame_override['duration'] > 0
	then
		return (_F.real_intensity + G.cry_flame_override['intensity']) / 2
	elseif
		G.rgmc_flame_override
		and G.rgmc_flame_override['duration'] > 0
	then
		return (_F.real_intensity + G.rgmc_flame_override['intensity']) / 2
	end

	return flame
end

function Madcap.Funcs.banana_context(context)
	return context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint
end

function Madcap.Funcs.get_flame_change_override(_F,flame)

	if
		G.cry_flame_override
		and G.cry_flame_override['duration'] > 0
	then
		return (_F.change + G.cry_flame_override['intensity']) / 2
	elseif
		G.rgmc_flame_override
		and G.rgmc_flame_override['duration'] > 0
	then
		return (_F.change + G.rgmc_flame_override['intensity']) / 2
	end

	return flame
end

G.FUNCS.flame_handler = function(e)
  	G.C.UI_CHIPLICK = G.C.UI_CHIPLICK or {1, 1, 1, 1}
  	G.C.UI_MULTLICK = G.C.UI_MULTLICK or {1, 1, 1, 1}

	for i=1, 3 do
    	G.C.UI_CHIPLICK[i] = math.min(math.max(((G.C.UI_CHIPS[i]*0.5+G.C.YELLOW[i]*0.5) + 0.1)^2, 0.1), 1)
    	G.C.UI_MULTLICK[i] = math.min(math.max(((G.C.UI_MULT[i]*0.5+G.C.YELLOW[i]*0.5) + 0.1)^2, 0.1), 1)
  	end

  	G.ARGS.flame_handler = G.ARGS.flame_handler or {
    	chips = {
      		id = 'flame_chips',
      		arg_tab = 'chip_flames',
      		colour = G.C.UI_CHIPS,
      		accent = G.C.UI_CHIPLICK
    	},
    	mult = {
      		id = 'flame_mult',
      		arg_tab = 'mult_flames',
      		colour = G.C.UI_MULT,
      		accent = G.C.UI_MULTLICK
    	}
  	}

  	for k, v in pairs(G.ARGS.flame_handler) do
    	if e.config.id == v.id then
			if not e.config.object:is(Sprite) or e.config.object.ID ~= v.ID then
				e.config.object:remove()
				e.config.object = Sprite(0, 0, 2.5, 2.5, G.ASSET_ATLAS["ui_1"], {x = 2, y = 0})
				v.ID = e.config.object.ID
				G.ARGS[v.arg_tab] = {
					intensity = 0,
					real_intensity = 0,
					intensity_vel = 0,
					colour_1 = v.colour,
					colour_2 = v.accent,
					timer = G.TIMERS.REAL
				}
				e.config.object:set_alignment({
					major = e.parent,
					type = 'bmi',
					offset = {x=0,y=0},
					xy_bond = 'Weak'
				})
				e.config.object:define_draw_steps({{
					shader = 'flame',
					send = {
						{name = 'time', ref_table = G.ARGS[v.arg_tab], ref_value = 'timer'},
						{name = 'amount', ref_table = G.ARGS[v.arg_tab], ref_value = 'real_intensity'},
						{name = 'image_details', ref_table = e.config.object, ref_value = 'image_dims'},
						{name = 'texture_details', ref_table = e.config.object.RETS, ref_value = 'get_pos_pixel'},
						{name = 'colour_1', ref_table =  G.ARGS[v.arg_tab], ref_value = 'colour_1'},
						{name = 'colour_2', ref_table =  G.ARGS[v.arg_tab], ref_value = 'colour_2'},
						{name = 'id', val =  e.config.object.ID},
					}
				}
			})
			e.config.object:get_pos_pixel()
		end

			local _F = G.ARGS[v.arg_tab]
			local exptime = math.exp(-0.4*G.real_dt)

			if
				to_big(G.ARGS.score_intensity.earned_score) >= to_big(G.ARGS.score_intensity.required_score)
				and to_big(G.ARGS.score_intensity.required_score) > to_big(0) then
				_F.intensity = ((G.pack_cards and not G.pack_cards.REMOVED) or (G.TAROT_INTERRUPT)) and 0 or math.max(0., math.log(G.ARGS.score_intensity.earned_score, 5)-2)
			else
				_F.intensity = 0
			end

			_F.timer = _F.timer + G.real_dt*(1 + _F.intensity*0.2)
			if _F.intensity_vel < 0 then
				_F.intensity_vel = _F.intensity_vel * (1 - 10 * G.real_dt)
			end
			_F.intensity_vel = (1 - exptime) * (_F.intensity - _F.real_intensity) * G.real_dt * 25 + exptime * _F.intensity_vel

			_F.real_intensity = math.max(0, _F.real_intensity + _F.intensity_vel)
			_F.real_intensity = Madcap.Funcs.get_flame_change_override(_F,_F.real_intensity)

			_F.change = (_F.change or 0) * (1 - 4. * G.real_dt) + ( 4. * G.real_dt) * (_F.real_intensity < _F.intensity - 0.0 and 1 or 0) * _F.real_intensity
			_F.change = Madcap.Funcs.get_flame_change_override(_F,_F.change)
		end
  	end
end

-- Some stickers prevent debuffs
local set_debuff_ref = Card.set_debuff
function Card:set_debuff(should_debuff)
    if
		(self.edition and self.edition.rgmc_flipped and next(find_joker("rgmc_streemerz"))) -- Streemerz
		and not self.ability.shielded 		-- shielded cannot be debuffed
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
		atlas 	= 'rgmc_mf_lunacy',
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

Madcap.Rainbow = {G.C.RED, G.C.ORANGE, G.C.GOLD, G.C.GREEN, G.C.BLUE, G.C.PURPLE}

-- Animated Colors
Madcap.C = {
	MAYHEM    	= { colours = { HEX('75188F'), HEX('3A188F') } },
	UNUSUAL   	= { colours = { HEX('9C87F6'), HEX('F6879B') } },
	CHAOTIC   	= { colours = { HEX('F25B3A'), HEX('3AF2BF') } },
	ECHIPS   	= { colours = { HEX('000994'), HEX('9A00FF') } },
	EMULT     	= { colours = { HEX('A41818'), HEX('9A00FF') } },
	XSCORE		= { colours = { HEX('8867A5'), HEX('9A00FF') } },
	ESCORE    	= { colours = { HEX('9A00FF'), HEX('00FF9A') } },
	GIMMICK   	= { colours = { HEX('FF8B60'), HEX('9494FF') } },
	EVIL      	= { colours = { HEX('D53600'), HEX('700E01') } },
	LUXURY    	= { colours = { HEX('D3AC2C'), HEX('B16C04') } },
	LIGHT     	= { colours = { HEX('FF6361'), HEX('FFD380') } },
	DARK      	= { colours = { HEX('BC5090'), HEX('00202E') } },
	SINISTER  	= { colours = { HEX('78322A'), HEX('677F93') } },
	BISMUTH  	= { colours = { G.C.RED, G.C.GOLD, G.C.GREEN, G.C.BLUE, G.C.PURPLE }, cycle = 0.5 },
}
MadLib.loop_table(Madcap.C, function(k,v)
	SMODS.Gradient{
		key 			= k,
		colours 		= v.colours,
		cycle 			= v.cycle and (1 / v.cycle) or 1,
		interpolation 	= v.interpolation or 'linear'
	}
end)

function Game:update(dt)
	upd(self, dt)

	if enable_animations then
		for k,v in pairs(AnimatedJokers) do
			update_sprite_delta(k,dt)
		end
	end
	--[[
		local anim_timer = self.TIMERS.REAL * 1.5
		local p = 0.5 * (math.sin(anim_timer) + 1)

		MadLib.loop_table(Madcap.C, function(k,c)
			if not G.C["RGMC_" .. k]
				then G.C["RGMC_" .. k] = { 0, 0, 0, 0 }
			end
			for i = 1, 4 do
				G.C["RGMC_" .. k][i] = c[1][i] * p + c[2][i] * (1 - p)
			end
		end,true)
	]]
end

Madcap.EnterNoises = {
	['j_rgmc_spam'] = { id = 'rgmc_spam_enter' },
	['j_rgmc_legend_bobby'] = { id = 'rgmc_bobby' },
}

Madcap.EnterFuncs = {
	['j_rgmc_lobster_thermidor'] = function()
		MadLib.simple_event(function()
			play_sound('rgmc_lobster_thermidor', 1, 1)
			--[[jl.a("Lobster Thermidor A Crevette", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
			delay(1.5)
			jl.a("With A Mornay Sauce", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
			delay(1.5)
			jl.a("Garnished With Truffle Pâté", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
			delay(1.5)
			jl.a("Brandy and a Fried Egg On Top!", G.SETTINGS.GAMESPEED*1.5, 1, G.C.RGMC_GIMMICK)
			delay(1.5)]]
			return true
		end)
	end
}

local add_to_deckref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    if
		self.ability.set == "Joker"
		and not from_debuff
	then
		if Madcap.EnterNoises[self.config.center.key] then
			local _sound = Madcap.EnterNoises[self.config.center.key]
			play_sound(_sound.id, _sound.pitch or 1, _sound.volume or 0.6)
		end
		if Madcap.EnterFuncs[self.config.center.key] then
			Madcap.EnterFuncs[self.config.center.key]()
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

local eval_card_ref = eval_card
function eval_card(card, context)
	if
		context.scoring_hand
		and context.joker_main
	then
		--tell('Calculate subhands')
		context.subhands = MadLib.get_subhands(context.scoring_hand)
		--print(context.subhands)
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

local smods_change_base = SMODS.change_base
function SMODS.change_base(card, suit, rank)
	if not card then return nil end
	-- immutable sticker
	if card.ability.rgmc_immutable then
		if suit ~= card.base.suit then
			return SMODS.change_base(card, suit, rank)
		else
			return nil
		end
	end
	local card = smods_change_base(card, suit, rank)
	-- put shit here i guess idk
    return card
end

--Used to mess around with poker hand stuff (e.g. Waveworx)
local evaluate_poker_hand_ref = evaluate_poker_hand
function evaluate_poker_hand(hand)
    local results = evaluate_poker_hand_ref(hand)

    -- force poker hand.
    if G.GAME.force_poker_hand then
        if not results[G.GAME.force_poker_hand][1] then
            for _, v in ipairs(G.handlist) do
                if results[v][1] then
                    results[G.GAME.force_poker_hand] = results[v]
                    break
                end
            end
        end
    end

    return results
end

SMODS.load_file('lib/subhands.lua')()
SMODS.load_file('lib/scoring.lua')()
SMODS.load_file('lib/hooks.lua')()
SMODS.load_file('lib/vanilla_override.lua')()
SMODS.load_file('lib/modded_override.lua')()


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

-- returns numerators and denominator, numerator cannot be greater than denominator
function Madcap.Funcs.fix_probabilities(numer, denom)
	return math.min(numer, denom), math.max(0.01,denom)
end

function Madcap.Funcs.GetMusic(_k, _select, _vol, _sync, _pitch)
    return {
		object_type = "Sound",
		key = _k,
		path = _k..'.ogg',
		volume = _vol or 0.8,
		select_music_track = _select,
		sync = _sync or true,
		pitch = _pitch,
	}
end

function Madcap.Funcs.LoadCoords(w, i, width)
	return (w.atlas and w.atlas ~= 'placeholder' and MadLib.coords(i-1, width))
		or { x = 0, y = 0}
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
	if not Madcap.Funcs.CheckLoadArguments(_f,_t,_atlas,_args) then
		tell('Uh oh at LoadJokers!')
		return false
	end
	-- should have key, rarity, and some sort of vars/calculation.
	MadLib.loop_func(_f,function(w,i)
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

function Madcap.Funcs.get_card_key(card, _id)
    return SMODS.Ranks[card.base.value].key == _id
end

function Madcap.Funcs.card_in_list(_card,_list)
    return MadLib.list_matches_one(_list, function(v)
        return v == _card
    end)
end

function Madcap.Funcs.get_simple_downgrade_data(t,card,val,bypass_safety)
    local final_val = not bypass_safety and
        (card.ability.extra[t.key] - val > 0 and val or card.ability.extra[t.key])
        or val

    if not bypass_safety and (card.ability.extra[t.key] - val) <= 0 then
        final_val = card.ability.extra[t.key]
    end

    card.ability.extra[t.key] = card.ability.extra[t.key] - final_val

    return {
        message = localize({
            type    = "variable",
            key     = t.key,
            colour      = t.colour,
            vars    = { number_format(final_val) },
            card    = card
        }),
    }
end

--[[
	MAYHEM
]]

get_pos = MLIB.coords

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
	['AddMoney'] 		= { factor = 1.5, round = true },
	['HandSize']		= { factor = 0.5, level = 1, round = true, type = 'hand_size'},
	['PlayHands']		= { factor = 0.5, round = true },
	['PlayDiscards'] 	= { factor = 0.5, round = true },
	['Retriggers'] 		= { factor = 0.25, round = true },
	['AddLuxury'] 		= { factor = 0.8, round = true },
	['AddCards'] 		= { factor = 0.8, level = 2, round = true },
	['JokerSlots']		= { factor = 0.5, level = 1, round = true, type = 'joker_slots' },
	['VoucherLimit']	= { factor = 0.5, level = 2, round = true, type = 'voucher_limit' },
	['BoosterLimit']	= { factor = 0.5, level = 2, round = true, type = 'booster_limit' },
	['MaxMayhem']		= { factor = 1, level = 1, round = true, type = 'max_mayhem' },
	['Mayhem']			= { factor = 1, level = 1, type = 'add_mayhem' },
	['Probability']		= { factor = 1, },
	['Choose']			= { factor = 0.5, round = true },
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
	['xmult']			= mlibmv['MultiMult'],
	['x_mult']			= mlibmv['MultiMult'],
	['h_x_mult']		= mlibmv['MultiMult'],
	['xchips']			= mlibmv['MultiChips'],
	['x_chips']			= mlibmv['MultiChips'],
	['h_x_chips']		= mlibmv['MultiChips'],
	['perma_x_mult']		= mlibmv['MultiMult'],
	['perma_h_x_mult']		= mlibmv['MultiMult'],
	['perma_x_chips']		= mlibmv['MultiChips'],
	['perma_h_x_chips']		= mlibmv['MultiChips'],
	['max_highlighted']	= mlibmv['Choose'],
	['choose']			= mlibmv['Choose'],
}

--
local function loop_keys_add(list, target, value)
	MadLib.loop_func(list, function(k) target[k] = value end)
end

loop_keys_add({ 'mult', 'mult_mod', 'perma_mult', 'perma_h_mult', 's_mult', 't_mult', 'h_mult' },
	Madcap.MayhemConversions,  mlibmv['AddMult'])
loop_keys_add({ 'chips', 'chip_mod', 'perma_bonus', 'perma_h_chips', 't_chips', 'h_chips', 'bonus' },
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
loop_keys_add({ 'extra_value', 'hands_played_at_create' },
	Madcap.MayhemConversions,  mlibmv['Misc'])

if next(SMODS.find_mod("Pacdam")) or next(SMODS.find_mod("pacdam")) then
	tell('Pacdam loaded!')
	Madcap.MayhemValues['AddPow'] = { factor = 0.8, level = 2, multiply = true }
	loop_keys_add({ 'pow', 'pow_mod', 'perma_pow' },
		Madcap.MayhemConversions,  mlibmv['AddPow'])
end

if AKYRS then
	loop_keys_add({ 'akyrs_perma_h_score', 'akyrs_perma_score',  },
		Madcap.MayhemConversions,  mlibmv['AddScore'])
end

Madcap.MayhemBlacklist = {
	id 						= false,
	order					= false,
	qty 					= false,
	colour 					= false,
	immutable 				= false,
	suit_nominal 			= false,
	base_nominal 			= false,
	face_nominal 			= false,
	times_played 			= false,
	selected_d6_face 		= false,
	cry_hook_id				= false,
	suit_nominal_original 	= false,
	cry_prob				= false,
	entr_times_played		= false
}

-- Blacklisted because there would be no effect
Madcap.MayhemJokersBlacklist = {
	'j_four_fingers',
	'j_splash',
	'j_pareidolia',
	'j_riff_raff',
	'j_diet_cola',
	'j_luchador',
	'j_shortcut',
	'j_mr_bones',
	'j_chicot',
	'j_blueprint',
	'j_brainstorm',
	'j_smeared',
	'j_midas_mask',
	'j_ring_master'
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

-- Adds Cherry Seals to hand
function Madcap.Funcs.modify_scoring_hand(scoring_hand)
	return scoring_hand
end

function MadLib.swap(list, i, j)
    if not (list and list[i] and list[j]) then return end
    list[i], list[j] = list[j], list[i]
end

function Madcap.Funcs.shuffle_deck(cards)
	MadLib.loop_func(cards, function(v,i)
		local pos = i
		if v.seal == 'rgmc_patina' then
			for n=1, v.ability.seal_rolls do
				if pos >= #cards then -- front
					break
				elseif SMODS.pseudorandom_probability(card, 'patina_seal', 1, v.ability.seal_odds) then
					pos = pos + 1
					MadLib.swap(cards[i], cards[i+1])
					tell('go forwards')
				end
			end
		elseif v.seal == 'rgmc_bronze' then
			for n=1, v.ability.seal_rolls do
				if pos <= 1 then -- back
					break
				elseif SMODS.pseudorandom_probability(card, 'bronze_seal', 1, v.ability.seal_odds) then
					pos = pos - 1
					MadLib.swap(cards[i], cards[i-1])
					tell('go backwards')
				end
			end
		end
	end)
	return cards
end

-- Used for managing the future Toy Piano Joker
Madcap.ToyPiano = {
	Positions = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace' },
	BigSteps = { 12, 9, 7, 4, 6, 7, 5, 9, 6, 4, 1, 3, 4, 2, 6, 7, 5, 9, 10, 8, 12, 13, 11, 14, 12, 12 }
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
	local success = false
	MadLib.loop_table(_table, function(k,v)
		-- is this a blacklisted term?
		if Madcap.MayhemBlacklist[k] == nil then -- not blacklisted
			if type(v) == 'table' then -- we must go deeper
				Madcap.Funcs.mayhemize_table(_card, v, _args)

			elseif type(v) == 'number' then -- do the number
				local _prefix = string.sub(_card.config.center.key,1,2)
				local _type = (_prefix == 'j_') and 'joker'
					or (_card.config.center.key == 'c_base' or _prefix == 'm_') and 'card'
				local _xval

				local _key = k ~= 'extra' and k and string.lower(k)
				local _data

				if Madcap.DefineExtras[_card.config.center.key] then
					tell('Finding extra value...')
					_data = Madcap.DefineExtras[_card.config.center.key][k]
				else
					_data = Madcap.MayhemConversions[_key]
				end
				_xval = (_data and _data.multiply)

				if
					not _data -- no data
					or (not _xval and v == 0) 			-- additive value at 0.00
					or (_xval and v == 1 or v == 0)		-- multiplying value at 1.00 (or 0.00)
				then
					return false
				end -- don't bother if multiplying value and not set
				--tell('Key ' .. k .. ' explored!')

				local factor = (_data and _data.factor) or 1
				local must_round = (_data and _data.round or false)
				local nu_min, nu_max = MadLib.deep_copy(_args.min), MadLib.deep_copy(_args.max)
				local center, half_range = (nu_min + nu_max) / 2, math.abs(nu_max - nu_min) / 2 * factor
				nu_min, nu_max = center - half_range, center + half_range

				local _mult = MadLib.random_between(nu_min, nu_max, 2)
				--if _xval then tell('This is an multiplying value!') end

				local _base = v - (_xval and 1 or 0)
				_table[k] = MadLib.round((_base * _mult) + (_xval and 1 or 0), must_round and 0 or 2)

				if _data and _data.type and mayhemize_funcs[_data.type] then
					mayhemize_funcs[_data.type](v,_table[k])
				end
				success = true

				--tell(tostring(k)..' is now '..tostring(_table[k])..' ('..tostring(v)..').')
			end -- don't mess with bools and strings.
		end
	end)
	return success
end

-- Messes up the values of the targeted cards based on
function Madcap.Funcs.mayhemize(_card, _args, _silent)
	local low_mult 		= (_args and _args.min_mult) or (1/2)
	local high_mult		= (_args and _args.max_mult) or 2
	local mayhem_state	= mfuncs.get_mayhem_state()
	local arguments 	= { min	= low_mult, max	= high_mult }

	if not (_args and _args.force_values) then
		local limits = (mayhem_state < 1 and 2)
			or (mayhem_state < 2 and 4)
			or (mayhem_state < 3 and 8)
			or 12
		--tell('Limit is ' .. tostring(limits))
		low_mult	= low_mult * limits
		high_mult	= high_mult / limits
	end

	local success = Madcap.Funcs.mayhemize_table(_card, _card.ability, arguments)
	-- loop through each
	-- max mayhem (10 has between x1/8 and x8 mult)
	-- 0 mayhem is x1 mult
	if not _silent then
		MadLib.simple_event(function()
        	_card:juice_up(0.3, 0.4)
        	play_sound("rgmc_mayhemize")
			return true
		end, 0.1, 'after')
	end
	return _card
end


local old_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local card = old_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

	if G.GAME.mayhem then
		local mayhem_state	= mfuncs.get_mayhem_state()
		if mayhem_state > 0 then
			card = Madcap.Funcs.mayhemize(card)
		end
	end
	return card
end

function Madcap.Funcs.set_edition_flipped(target)
    local success = (not target.edition) or target.edition.rgmc_flipped
    MadLib.simple_event(function()
        if success then
            local flip = not (target.edition and target.edition.rgmc_flipped)
            target:set_edition({ rgmc_flipped = flip }, true)
            target:juice_up(0.5, 0.7)
            play_sound('tarot2', 0.76, 0.4)
        end
        return true
    end, 1.0, 'after')
    return success
end

function Madcap.Funcs.flip_and_mayhemize(_cards,_args)
	MadLib.flip_cards(_cards, function(v)
		Madcap.Funcs.mayhemize(v, _args, true)
	end, nil, function(v)
        card:juice_up(0.3, 0.4)
        play_sound("rgmc_mayhemize")
	end)
end

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

SMODS.ConsumableType({
    key = "SpatiaPlanet",
    primary_colour = HEX("5024FF"),
    secondary_colour = HEX("2600C1"),
    collection_rows = { 5, 6 },
    shop_rate = 0.75,
    --loc_txt = {},
    default = "c_rgmc_rocket",
    can_stack = true,
    can_divide = true,
})

SMODS.ConsumableType({
    key = "PotentiaCrystal",
    primary_colour = HEX("917ECC"),
    secondary_colour = HEX("FEA600"),
    collection_rows = { 5, 6 },
    shop_rate = 0.25,
    --loc_txt = {},
    default = "c_rgmc_diamatine",
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

function Madcap.Funcs.prioritize_vulnerable_cards(a,b)
	local _a = (a:is_invulnerable() and 1 or 0) + math.random()/2
	local _b = (b:is_invulnerable() and 1 or 0) + math.random()/2
	return _a > _b
end

function Madcap.Funcs.use_cosma(self, card, area, copier, num_cards, check, func)
	if not G.hand then return false end
    local used_tarot = copier or card
    G.hand:unhighlight_all()
	-- no suitless
	local valid = MadLib.shuffle_sort_list(G.hand.cards, num_cards, check)
	--tell_stat('Valid Cards',valid)
	-- up down
	MadLib.loop_func(G.hand.cards,function(v, i)
		MadLib.simple_event(function()
			v:highlight(true)
			play_sound('card3', math.random()*0.2 + 0.9, 0.35)
			return true
		end, 0.15, 'after')
		MadLib.simple_event(function()
			v:highlight(false)
			return true
		end, 0.15, 'after')
	end)
	-- up
	MadLib.loop_func(G.hand.cards,function(v, i)
		MadLib.simple_event(function()
			play_sound('card3', math.random()*0.2 + 0.9, 0.35)
			v:highlight(true)
        	v:flip()
			return true
		end, 0.5, 'after')
	end)
	-- change
	MadLib.loop_func(valid,function(v, i)
		MadLib.simple_event(function()
			func(v,card,i)
			return true
		end, 0.05, 'after')
		MadLib.simple_event(function()
			v:juice_up(0.3, 0.5)
			return true
		end, 0.50, 'after')
	end)
	-- down
	MadLib.loop_func(G.hand.cards,function(v, i)
		MadLib.simple_event(function()
			v:highlight(false)
        	v:flip()
			return true
		end, 0.25, 'after')
	end)
	if used_tarot then used_tarot:juice_up(0.3, 0.5) end
	return true
end

function Madcap.Funcs.select_cards(self, card, copier, targets, func)
	if not G.hand then return false end
    local used_tarot = copier or card
    G.hand:unhighlight_all()
	-- no suitless
	--tell_stat('Valid Cards',valid)
	-- up down
	MadLib.loop_func(targets,function(v, i)
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
	MadLib.loop_func(targets,function(v, i)
		MadLib.simple_event(function()
			play_sound('card3', math.random()*0.2 + 0.9, 0.35)
			v:highlight(true)
        	v:flip()
			return true
		end, 0.1, 'after')
	end)
	-- change
	MadLib.loop_func(targets,function(v, i)
		MadLib.simple_event(function()
			func(v,card,i)
			return true
		end, 0.05, 'after')
	end)
	-- down
	MadLib.loop_func(targets,function(v, i)
		MadLib.simple_event(function()
			v:highlight(false)
        	v:flip()
			return true
		end, 0.1, 'after')
	end)
	if used_tarot then used_tarot:juice_up(0.3, 0.5) end
	return true
end

Madcap.GoldenHouseFuncs = {
    ['c_black_hole'] = function(t)
        local chips, mult = 0, 0

        -- Loop through all visible
        MadLib.loop_func(G.GAME.hands, function(v)
            if v.visible then
                chips   = chips + v.chips/2
                mult    = mult + v.mult/2
            end
        end)

        return chips, mult
    end,
    ['c_cry_planetlua'] = function(t)
        local chips, mult = 0, 0

        if SMODS.pseudorandom_probability(t, 'golden_house', 1, 5) then
            -- Loop through all visible
            MadLib.loop_func(G.GAME.hands, function(v)
                if v.visible then
                    chips   = chips + v.chips/2
                    mult    = mult + v.mult/2
                end
            end)
        end

        return chips, mult
    end,
    ['c_cry_nstar'] = function(t)
        local chips, mult = 0, 0

        local random_hand = MadLib.get_random_poker_hand()
        local neutrons    = (G.GAME.neutronstarsusedinthisrun or 0) + 2
        chips   = (random_hand.chips / 2) * neutrons
        mult    = (random_hand.mult / 2) * neutrons
        return chips, mult
    end,
}

-- Returns the chips and mult for the planet hand (or hands)
function Madcap.Funcs.get_goldenhouse_chipmult(target)
    if not target then return 0, 0 end
    local chips, mult, changed = 0,0,false

    --print(target)

    if -- regular planets
        target.ability.hand_type
        and G.GAME.hands[target.ability.hand_type]
        and not target.ability.jest_spec_moon -- not aij thing
    then
        chips   = G.GAME.hands[target.ability.hand_type].chips/2
        mult    = G.GAME.hands[target.ability.hand_type].mult/2
        changed = true
    elseif
        target.ability.hand_types -- More than one hand type
    then
        -- Loop through each selected
        for _, v in pairs(target.ability.hand_types) do
            if G.GAME.hands[v] then
                chips   = chips + G.GAME.hands[v].chips/2
                mult    = mult + G.GAME.hands[v].mult/2
            end
        end
        changed = true
    elseif
        Madcap.GoldenHouseFuncs[target.ability.key] -- has a function
    then
        chips, mult = Madcap.GoldenHouseFuncs[target.ability.key](target)
        changed = true
    end

    -- Subtypes give xChip/xMult
    if target.ability.sub_type then
        local adj_xchip = ((G.GAME.subhands[k].chips - 1) * 2) + 1
        local adj_xmult = ((G.GAME.subhands[k].mult - 1) * 2) + 1
        chips  = chips * adj_xchip
        mult   = mult * adj_xmult
    end

    return math.max(chips,0), math.max(mult,0), changed
end

local ggcm_ref = Madcap.Funcs.get_goldenhouse_chipmult
if G.AIJ then -- All in Jest

    -- Compat for the fancy planet cards
    function Madcap.Funcs.get_goldenhouse_chipmult(target)
        local chips, mult, changed = ggcm_ref(target)

        if changed then return chips, mult, true end

        if
            target.ability.hand_type
            and G.GAME.hands[target.ability.hand_type]
            and target.ability.jest_spec_moon
        then
            if
                -- All in Jest - chips moon
                MadLib.list_matches_one(Madcap.Lists.Moons.Chips, function(v)
                    return 'c_aij_' .. v == target.ability.key
                end)
            then
                chips   = chips + G.GAME.hands[v].chips
                changed = true
            elseif
                -- All in Jest - mult moon
                MadLib.list_matches_one(Madcap.Lists.Moons.Mult, function(v)
                    return 'c_aij_' .. v == target.ability.key
                end)
            then
                mult    = mult + G.GAME.hands[v].mult
                changed = true
            end
        end

        return chips, mult, changed
    end

end

function Madcap.Funcs.do_gimmick_generator(card,context,success_func)

    local pass = nil

    if context.forcetrigger then
        pass = true
    else
        card.ability.extra.rounds = (card.ability.extra.rounds or 0) + 1
        pass = not (card.ability.extra.rounds < card.ability.extra.max_rounds)

        -- only jiggle if it is one until the end
        if card.ability.extra.rounds + 1 == card.ability.extra.max_rounds then
            local eval = function(card)
                return card.ability.extra.rounds ~= card.ability.extra.max_rounds-1
            end
            juice_card_until(card, eval, true)
        end
    end

    if not pass then
        local full_msg = card.ability.extra.rounds .. '/' .. card.ability.extra.max_rounds
        return {
            card_eval_status_text(card, "extra", nil, nil, nil, {
                message = full_msg,
                colour = G.C.FILTER,
            }),
        }
    else -- force triggered or max rounds
        local ret = nil
        MadLib.simple_event(function()
            success_func(card)
            return true
        end, 1.0, 'after')
        return ret
    end
end

-- LOADING JOKERS
--mod_path..root
Madcap.object_buffer['Jokers'] = Madcap.object_buffer['Jokers'] or {}

local function load_items(path,func)
	local files = NFS.getDirectoryItems(mod_path..path)
	tell('File path is '.. path)
	MadLib.loop_func(files, function(file)
		tell('File is '..file)
		local f, err = SMODS.load_file(path..file)
		if err then
			tell_error(err)
			--errors[file] = err
			return false
		end

		local item = f()
		if not (item and item.data) then
			tell('Item could not load - improper data structure.')
			return false
		elseif item.devmode and item.devmode ~= Madcap.Data.devmode then
			tell('Item could not load - devmode only!')
			return false
		end

		if item.categories and MadLib.list_matches_one(item.categories, function(c)
			return MadcapConfig[v] ~= nil and MadcapConfig[v] == false
		end) then
			tell('Item '..(item.data and item.data.key or 'UNKNOWN')..' could not load - configs turned off.')
			return false
		end

		local data = item.data
		if data.object_type then
			if func then func(item.data) end
			tell('Attempting to load item '..(item.data and item.data.key or 'UNKNOWN')..'.')
			SMODS[data.object_type](data)
		end
	end)
end

local function loop_directories(tbl, path)
    path = path or {}
    tell('Loading Directories')
	print(path)
	MadLib.loop_table(tbl, function(key,value)
        if type(value) ~= "table" then return false end
		if value.pass ~= nil and value.pass() == true then
			tell("Loading folder at: " .. table.concat(path, ".") .. (next(path) and "." or "") .. key)
			local final_path = 'items/'
			MadLib.loop_func(path, function(v,i)
				final_path = final_path .. v .. '/'
			end)
			load_items(final_path..key..'/',value.func)
		else
			table.insert(path, key)
			loop_directories(value, path)
			table.remove(path)
		end
	end)
end

-- Usage

local function add_object_type(tbl, path, type)

end

Madcap.JokerIds = {} -- joker ids
Madcap.Directories = {
	['poker_hands'] = {
		pass = function()
			return true
		end
	},
	['jokers'] = {
		['madcap'] = {
			pass = function()
				return true
			end,
			func = function(d) -- add joker id to joker ids
				--tell('Adding '..(d and d.key or '?!?')..' to Joker List.')
				d.pools = { ['MadcapJoker'] = true }
				d.blueprint_compat  = d.blueprint_compat or true
				d.eternal_compat    = d.eternal_compat or true
				d.perishable_compat = d.perishable_compat or true
				d.unlocked          = d.unlocked or true
				d.discovered        = d.discovered or true
			end
		},
		['cryptid'] = {
			pass = function()
				return next(SMODS.find_mod("Cryptid")) -- cryptid jokers are not loaded here
			end,
			func = function(d)
				d.pools = { ['MadcapJoker'] = true }
				d.blueprint_compat  = d.blueprint_compat or true
				d.eternal_compat    = d.eternal_compat or true
				d.perishable_compat = d.perishable_compat or true
				d.unlocked          = d.unlocked or true
				d.discovered        = d.discovered or true
			end
		}
	},
	['consumables'] = {
		['madcap'] = {
			['tarot'] = {
				pass = function()
					return true
				end
			},
			['spectral'] = {
				pass = function()
					return true
				end
			},
			['cosma'] = {
				pass = function()
					return true
				end
			},
			['spatia'] = {
				pass = function()
					return true
				end
			},
			['potentia'] = {
				pass = function()
					return true
				end
			},
			['planets'] = {
				pass = function()
					return true
				end
			}
		},
		['morefluff'] = {
			['colour'] = {
				pass = function()
					return next(SMODS.find_mod("MoreFluff"))
				end
			},
			['rotarots'] = {
				pass = function()
					return next(SMODS.find_mod("MoreFluff"))
				end
			},
		}
	},
	['boosters']	= {
		pass = function()
			return true
		end
	},
	['challenges']	= {
		pass = function()
			return true
		end
	},
	['vouchers']	= {
		['madcap'] = {
			pass = function()
				return true
			end
		}
	},
	['enhancements'] = {
		['madcap'] = {
			pass = function()
				return true
			end
		},
		['morefluff'] = {
			pass = function()
				return next(SMODS.find_mod("MoreFluff"))
			end
		},
		['akyrs'] = {
			pass = function()
				return next(SMODS.find_mod("aikoyorisshenanigans"))
			end
		},
	},
	['editions'] = {
		pass = function()
			return true
		end
	},
	['seals']		= {
		pass = function()
			return true
		end
	},
	['sleeves']		= {
		pass = function()
			return next(SMODS.find_mod("CardSleeves"))
		end
	},
	['stickers']	= {
		pass = function()
			return true
		end
	},
	['tags']		= {
		['madcap'] = {
			['regular'] = {
				pass = function()
					return true
				end
			},
			['antags'] = {
				pass = function()
					return true
				end,
				func = function(d)
					table.insert(Madcap.Lists.AnTags, d.key)
				end
			},
			['special'] = {
				pass = function()
					return true
				end
			}
		}
	},
	['blinds'] = {
		['boss'] = {
			pass = function()
				return true
			end
		},
		['showdown'] = {
			pass = function()
				return true
			end
		},
		--TODO: add DX blinds?
	},
	['decks'] = {
		pass = function()
			return true
		end
	},
	['challenges'] 	= {
		pass = function()
			return true
		end
	},
}
load_folder('items/misc') -- load the items folder
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
loop_directories(Madcap.Directories)

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
	if not (card and context) then
		return nil
	end
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

function Madcap.Funcs.get_food_descale(value)
	return value
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


-- Has at least 1 card selected
function Madcap.Funcs.consumable_highlight_check(self,card)
	if not (self and card) then return false end
	return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
end

-- MoreFluff compat
if MoreFluff then
	function Madcap.Funcs.get_enhancement_tarot_loc_vars(self, info_queue, card)
		if not (self and card) then return  { vars = {} } end
		MadLib.add_to_queue(G.P_CENTERS[self.config.mod_conv])
		return MadLib.collect_vars(card and card.ability.max_highlighted or self.config.max_highlighted,
			localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv})
	end

	-- Progress bar for colour consumables.
	function Madcap.Funcs.get_progress_bar(val, max)
		if max > 10 then
			return val, "/"..max
		end
		return string.rep("#", val), string.rep("#", max - val)
	end

	function Madcap.Funcs.get_colour_loc_vars(self, info_queue, card)
		local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
		return { vars = {card.ability.val, val, max, card.ability.upgrade_rounds} }
	end

	function Madcap.Funcs.colour_can_use(self, card)
		return self and self.config.val > 0 or false
	end

	function Madcap.Funcs.colour_convert_suit(self, card, area, copier, suit)
		if not (self and card) then return end
		local blacklist = {}
		for i = 1, card.ability.val do
			local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v) return not v:is_suit(suit) and not blacklist[v] end)
			if #temp_pool == 0 then break end

			local eligible_card = pseudorandom_element(temp_pool, pseudoseed(self.config.key))
			blacklist[eligible_card] = true

			MadLib.simple_event(function()
				eligible_card:flip()
				play_sound('card1', 1)
				eligible_card:juice_up(0.3, 0.3)
				return true
			end, 0.15, 'after')

			MadLib.simple_event(function()
				eligible_card:flip()
				play_sound('card1', 1)
				eligible_card:change_suit(suit)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
	end

	function Madcap.Funcs.colour_add_consumable(self, card, area, copier, set, not_negative)
		if not (self and card) then return end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				play_sound('timpani')
				local n = MadLib.get_random_card(set, G.consumeables, self.config.key)
				n:add_to_deck()
				n:set_edition({negative = not not_negative}, true)
				G.consumeables:emplace(n)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
		delay(0.6)
	end

	function Madcap.Funcs.colour_add_consumable_exact(self, card, area, copier, id, not_negative)
		if not (self and card) then return end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				play_sound('timpani')
				local n = create_card(nil, G.consumeables, nil, nil, true, true, 'c_'..id)
				n:add_to_deck()
				n:set_edition({negative = not not_negative}, true)
				G.consumeables:emplace(n)
				card:juice_up(0.3, 0.5)
				return true
			end, 0.4, 'after')
		end
		delay(0.6)
	end

	function Madcap.Funcs.colour_add_tag(self, card, area, copier, tag)
		if not (self and card) then return false end
		for i = 1, card.ability.val do
			MadLib.simple_event(function()
				add_tag(Tag('tag_'..tag))
				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
				return true
			end)
			delay(0.2)
		end
		delay(0.6)
		return true
    end

    function Madcap.Funcs.colour_add_edition (self, card, area, copier, edition)
		if not (self and card) then return false end
		for i=1, card.ability.val do
			MadLib.simple_event(function()
				local temp_pool = MadLib.get_list_matches(G.hand.cards, function(v)
					return not v.edition
				end) or {}
				local backup_pool = MadLib.get_list_matches(G.hand.cards, function(v)
					return v.edition and not v.edition['rgmc_infernal']
				end) or {}

				local pool = (#temp_pool > 0 and temp_pool) or (#backup_pool > 0 and backup_pool)
				if pool then
					local eligible_card = pseudorandom_element(pool, pseudoseed(self.config.key))
					eligible_card:set_edition({ ['rgmc_infernal'] = true }, true)
					check_for_unlock({type = 'have_edition'})
					card:juice_up(0.3, 0.5)
				end
				return true
			end, 0.4, 'after')
		end
		return true
	end

	-- loc_var for Colours
    function Madcap.Funcs.get_colour_loc_vars(self, info_queue, card)
		if not (self and card) then return end
		local val, max = get_progress_bar(card.ability.partial_rounds, card.ability.upgrade_rounds)
		return MadLib.collect_vars(card.ability.val, val, max, card.ability.upgrade_rounds)
	end

	function Madcap.Funcs.get_poker_hand_level()
		local phand = (G.GAME and G.STATE == G.STATES.HAND_PLAYED) and G.hand or G.play
		if not (phand and phand.highlighted and #phand.highlighted > 0) then return 0 end

		local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(phand.highlighted)
		--print(poker_hands[1])

		return G.GAME.hands[poker_hands[1]] and G.GAME.hands[poker_hands[1]].level or 0
	end
end

if Partner_API then
	function Madcap.Funcs.get_partner_key()
		return G.GAME.selected_partner_card and G.GAME.selected_partner_card.key
	end

	function Madcap.Funcs.get_partner_link_level()
		return G.GAME.selected_partner_card and G.GAME.selected_partner_card:get_link_level()
	end
end

-- For the Red Pill, Blue Pill
MadLib.loop_table(MadLib.JokerLists.Chips, function(key,list)
	tell('Looping through '..key)
	print(list)
    MadLib.loop_func(list, function(v)
        tell('Attempting to load "'..tostring(v).. '" as a Chip Joker')
        if not SMODS.Centers[v] then return end
        SMODS.Centers[v].pools = SMODS.Centers[v].pools or {}
		SMODS.Centers[v].pools['ChipsJoker'] = true
    end)
end)


MadLib.loop_table(MadLib.JokerLists.Mult, function(key,list)
	tell('Looping through '..key)
	print(list)
    MadLib.loop_func(list, function(v)
        tell('Attempting to load "'..tostring(v).. '" as a Mult Joker')
        if not SMODS.Centers[v] then return end
        SMODS.Centers[v].pools = SMODS.Centers[v].pools or {}
        SMODS.Centers[v].pools['MultJoker'] = true
    end)
end)

SMODS.ObjectType({
	object_type = "ObjectType",
	key 	= "MadcapJoker",
	default = "j_rgmc_joker_squared",
	cards = {},
})

SMODS.ObjectType({
	object_type = "ObjectType",
	key 	= "ChipsJoker",
	default = "j_ice_cream",
	cards = {},
})

SMODS.ObjectType({
	object_type = "ObjectType",
	key 	= "MultJoker",
	default = "j_popcorn",
	cards = {},
})

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

function create_UIBox_HUDD()
    local scale = 0.4
    local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)

    local contents = {}

    local spacing = 0.13
    local temp_col = G.C.DYN_UI.BOSS_MAIN
    local temp_col2 = G.C.DYN_UI.BOSS_DARK
            contents.round = {
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.C, config={id = 'hud_hands',align = "cm", padding = 0.05, minw = 1.45, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
                  {n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 1.35}, nodes={
                    {n=G.UIT.T, config={text = localize('k_hud_hands'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                  }},
                  {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'hands_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.BLUE},shadow = true, rotate = true, scale = 2*scale}),id = 'hand_UI_count'}},
                  }}
                }},
                {n=G.UIT.C, config={minw = spacing},nodes={}},
                {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.45, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
                  {n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 1.35}, nodes={
                    {n=G.UIT.T, config={text = localize('k_hud_discards'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                  }},
                  {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, nodes={
                      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'discards_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.RED},shadow = true, rotate = true, scale = 2*scale}),id = 'discard_UI_count'}},
                    }}
                  }},
                }},
              }},
              {n=G.UIT.R, config={minh = spacing},nodes={}},
              {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.45*2 + spacing, minh = 1.15, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
                  {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.C, config={align = "cm", r = 0.1, minw = 1.28*2+spacing, minh = 1, colour = temp_col2}, nodes={
                      {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'dollars', prefix = localize('$')}}, maxw = 1.35, colours = {G.C.MONEY}, font = G.LANGUAGES['en-us'].font, shadow = true,spacing = 2, bump = true, scale = 2.2*scale}), id = 'dollar_text_UI'}}
                  }},
                  }},
                }},
            }},
            {n=G.UIT.R, config={minh = spacing},nodes={}},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.C, config={id = 'hud_ante',align = "cm", padding = 0.05, minw = 1.45, minh = 1, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 1.35}, nodes={
                  {n=G.UIT.T, config={text = localize('k_ante'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.round_resets, ref_value = 'ante'}}, colours = {G.C.IMPORTANT},shadow = true, font = G.LANGUAGES['en-us'].font, scale = 2*scale}),id = 'ante_UI_count'}},
                  {n=G.UIT.T, config={text = " ", scale = 0.3*scale}},
                  {n=G.UIT.T, config={text = "/ ", scale = 0.7*scale, colour = G.C.WHITE, shadow = true}},
                  {n=G.UIT.T, config={ref_table = G.GAME, ref_value='win_ante', scale = scale, colour = G.C.WHITE, shadow = true}}
                }},
              }},
              {n=G.UIT.C, config={minw = spacing},nodes={}},
              {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.45, minh = 1, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", maxw = 1.35}, nodes={
                  {n=G.UIT.T, config={text = localize('k_round'), minh = 0.33, scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2, colour = temp_col2, id = 'row_round_text'}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'round'}}, colours = {G.C.IMPORTANT},shadow = true, scale = 2*scale}),id = 'round_UI_count'}},
                }},
              }},
            }},
    }

    contents.hand =
        {n=G.UIT.R, config={align = "cm", id = 'hand_text_area', colour = darken(G.C.BLACK, 0.1), r = 0.1, emboss = 0.05, padding = 0.03}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes={
              {n=G.UIT.R, config={align = "cm", minh = 1.1}, nodes={
                {n=G.UIT.O, config={id = 'hand_name', func = 'hand_text_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "handname_text"}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, float = true, scale = scale*1.4})}},
                {n=G.UIT.O, config={id = 'hand_chip_total', func = 'hand_chip_total_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "chip_total_text"}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, float = true, scale = scale*1.4})}},
                {n=G.UIT.T, config={ref_table = G.GAME.current_round.current_hand, ref_value='hand_level', scale = scale, colour = G.C.UI.TEXT_LIGHT, id = 'hand_level', shadow = true}}
              }},
              {n=G.UIT.R, config={align = "cm", minh = 1, padding = 0.1}, nodes={
                {n=G.UIT.C, config={align = "cr", minw = 2, minh =1, r = 0.1,colour = G.C.UI_CHIPS, id = 'hand_chip_area', emboss = 0.05}, nodes={
                    {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_chips', object = Moveable(0,0,0,0), w = 0, h = 0}},
                    {n=G.UIT.O, config={id = 'hand_chips', func = 'hand_chip_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "chip_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2.3})}},
                    {n=G.UIT.B, config={w=0.1,h=0.1}},
                }},
                {n=G.UIT.C, config={align = "cm"}, nodes={
                  {n=G.UIT.T, config={text = "X", lang = G.LANGUAGES['en-us'], scale = scale*2, colour = G.C.UI_MULT, shadow = true}},
                }},
                {n=G.UIT.C, config={align = "cl", minw = 2, minh=1, r = 0.1,colour = G.C.UI_MULT, id = 'hand_mult_area', emboss = 0.05}, nodes={
                  {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_mult', object = Moveable(0,0,0,0), w = 0, h = 0}},
                  {n=G.UIT.B, config={w=0.1,h=0.1}},
                  {n=G.UIT.O, config={id = 'hand_mult', func = 'hand_mult_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "mult_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = scale*2.3})}},
                }}
              }}
            }}
          }}
    contents.dollars_chips = {n=G.UIT.R, config={align = "cm",r=0.1, padding = 0,colour = G.C.DYN_UI.BOSS_MAIN, emboss = 0.05, id = 'row_dollars_chips'}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = 1.3}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.3}, nodes={
            {n=G.UIT.T, config={text = localize('k_round'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.3}, nodes={
            {n=G.UIT.T, config={text =localize('k_lower_score'), scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
          }}
        }},
        {n=G.UIT.C, config={align = "cm", minw = 3.3, minh = 0.7, r = 0.1, colour = G.C.DYN_UI.BOSS_DARK}, nodes={
          {n=G.UIT.O, config={w=0.5,h=0.5 , object = stake_sprite, hover = true, can_collide = false}},
          {n=G.UIT.B, config={w=0.1,h=0.1}},
          {n=G.UIT.T, config={ref_table = G.GAME, ref_value = 'chips_text', lang = G.LANGUAGES['en-us'], scale = 0.85, colour = G.C.WHITE, id = 'chip_UI_count', func = 'chip_UI_set', shadow = true}}
        }}
      }}
    }}

    contents.buttons = {
      {n=G.UIT.C, config={align = "cm", r=0.1, colour = G.C.CLEAR, shadow = true, id = 'button_area', padding = 0.2}, nodes={
          {n=G.UIT.R, config={id = 'run_info_button', align = "cm", minh = 1.75, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.RED, button = "run_info", shadow = true}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
              {n=G.UIT.T, config={text = localize('b_run_info_1'), scale = 1.2*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
              {n=G.UIT.T, config={text = localize('b_run_info_2'), scale = 1*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = G.F_GUIDE and 'guide' or 'back', orientation = 'bm'}, func = 'set_button_pip'}}
            }}
          }},
          {n=G.UIT.R, config={align = "cm", minh = 1.75, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.ORANGE, button = "options", shadow = true}, nodes={
            {n=G.UIT.C, config={align = "cm", maxw = 1.4, focus_args = {button = 'start', orientation = 'bm'}, func = 'set_button_pip'}, nodes={
              {n=G.UIT.T, config={text = localize('b_options'), scale = scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }},
          }}
        }}
    }

    return {n=G.UIT.ROOT, config = {align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
      {n=G.UIT.R, config = {align = "cm", padding= 0.05, colour = G.C.DYN_UI.MAIN, r=0.1}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = G.C.DYN_UI.BOSS_DARK, r=0.1, minh = 30, padding = 0.08}, nodes={
          {n=G.UIT.R, config={align = "cm", minh = 0.3}, nodes={}},
          {n=G.UIT.R, config={align = "cm", id = 'row_blind', minw = 1, minh = 3.75}, nodes={}},
          contents.dollars_chips,
          contents.hand,
          {n=G.UIT.R, config={align = "cm", id = 'row_round'}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes=contents.buttons},
            {n=G.UIT.C, config={align = "cm"}, nodes=contents.round}
          }},
        }}
      }}
    }}
end


--[[
function create_UIBox_HUD_blindd()
  local scale = 0.4
  local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
  local has_blind_drawn = next(SMODS.find_card("j_aij_blind_drawn")) and type == 'Boss'
  G.GAME.blind:change_dim(1.5,1.5)

  return {n=G.UIT.ROOT, config={align = "cm", minw = 4.5, r = 0.1, colour = G.C.BLACK, emboss = 0.05, padding = 0.05, func = 'HUD_blind_visible', id = 'HUD_blind'}, nodes={
      {n=G.UIT.R, config={align = "cm", minh = 0.7, r = 0.1, emboss = 0.05, colour = G.C.DYN_UI.MAIN}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = 3}, nodes={
          {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.blind, ref_value = 'loc_name'}}, colours = {G.C.UI.TEXT_LIGHT},shadow = true, rotate = true, silent = true, float = true, scale = 1.6*scale, y_offset = -4}),id = 'HUD_blind_name'}},
        }},
      }},
      {n=G.UIT.R, config={align = "cm", minh = 2.74, r = 0.1,colour = G.C.DYN_UI.DARK}, nodes={
        {n=G.UIT.R, config={align = "cm", id = 'HUD_blind_debuff', func = 'HUD_blind_debuff'}, nodes={}},
        {n=G.UIT.R, config={align = "cm",padding = 0.15}, nodes={
          {n=G.UIT.O, config={object = G.GAME.blind, draw_layer = 1}},
          {n=G.UIT.C, config={align = "cm",r = 0.1, padding = 0.05, emboss = 0.05, minw = 2.9, colour = G.C.BLACK}, nodes={
            --{n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
              --{n=G.UIT.T, config={text = localize('ph_blind_score_at_least'), scale = 0.3, colour = G.C.WHITE, shadow = true}}
            --}},

          }},
        }},
		}},
    }}
end
]]


local function get_nested(orig, path)
    local current = orig
    for _, i in ipairs(path) do
        if current and current.nodes and current.nodes[i] then
            current = current.nodes[i]
        else
            return nil -- invalid path
        end
    end
    return current
end

local uibox_blind_ref = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
	local orig = uibox_blind_ref()
    local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)

	--tell('UI to find:')
	--print(orig.nodes[2].nodes[2].nodes[2].nodes)

	local score_text = { n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
				{n=G.UIT.T, config={ref_table = G.GAME, ref_value = 'chips_text', lang = G.LANGUAGES['en-us'], scale = 0.75, colour = G.C.WHITE, id = 'chip_UI_count', func = 'chip_UI_set', shadow = true}}}}

	local blind_chips_text = { n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
				{n=G.UIT.O, config={ w = 0.5, h = 0.5 , object = stake_sprite, hover = true, can_collide = false}},
				{n=G.UIT.T, config={ref_table = G.GAME.blind, ref_value = 'chip_text', lang = G.LANGUAGES['en-us'], scale = 0.75, colour = G.C.GOLD, id = 'HUD_blind_count', func = 'blind_chip_UI_scale', shadow = true}}
			}}

	-- Replace the first part with the actual score
	local _nodes
	if G.akyrs_blind_icons then
		table.insert(orig.nodes[2].nodes,{
			n=G.UIT.C, config={align = "cm",r = 0.1, padding = 0.05, emboss = 0.05, minw = 2.9, colour = G.C.BLACK},
			nodes={ score_text, blind_chips_text }
		})
	else
		orig.nodes[2].nodes[2].nodes[2].nodes[1] = score_text
		orig.nodes[2].nodes[2].nodes[2].nodes[2] = blind_chips_text
	end

	return orig
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


    local qwerty = orig.nodes[1].nodes[1].nodes[3]

    qwerty.nodes[1].nodes = nil

	-- Shorten the run info button
    if orig.nodes[1].nodes[1].nodes[5].nodes[1].nodes[1].nodes[1].config.id == "run_info_button" then
    orig.nodes[1].nodes[1].nodes[5].nodes[1].nodes[1].nodes[1] = {n=G.UIT.C, config={id = 'run_info_button', align = "cm", minh = 1, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.RED, button = "run_info", shadow = true}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
              {n=G.UIT.T, config={text = localize('b_run_info_1'), scale = 1.2*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0, maxw = 1.4}, nodes={
              {n=G.UIT.T, config={text = localize('b_run_info_2'), scale = 1*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = G.F_GUIDE and 'guide' or 'back', orientation = 'bm'}, func = 'set_button_pip'}}
            }}
          }}
    end

    -- Shorten the options button
    if orig.nodes[1].nodes[1].nodes[5].nodes[1].nodes[1].nodes[2].config.button == "options" then
        orig.nodes[1].nodes[1].nodes[5].nodes[1].nodes[1].nodes[2] = {n=G.UIT.C, config={align = "cm", minh = 1, minw = 1.5,padding = 0.05, r = 0.1, hover = true, colour = G.C.ORANGE, button = "options", shadow = true}, nodes={
            {n=G.UIT.C, config={align = "cm", maxw = 1.4, focus_args = {button = 'start', orientation = 'bm'}, func = 'set_button_pip'}, nodes={
              {n=G.UIT.T, config={text = localize('b_options'), scale = scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }},
          }}
    end

    -- Shrink hands
    local hand_data = orig.nodes[1].nodes[1].nodes[4].nodes[1].nodes[1]
    hand_data.config.minh = hand_data.config.minh * 0.75
    MadLib.loop_func(hand_data.nodes, function(v)
		if v and v.scale then v.scale = v.scale * 0.5 end
	end)
	-- Rearrange round/ante and button UI
	local buttons 		= orig.nodes[1].nodes[1].nodes[5].nodes[1]
	orig.nodes[1].nodes[1].nodes[5].nodes[1] = nil
	local round_data 	= orig.nodes[1].nodes[1].nodes[5].nodes[2]
	table.insert(orig.nodes[1].nodes[1].nodes, { n = G.UIT.R, config = { align = "cm", id = 'row_buttons'}, nodes = buttons.nodes })

	table.insert(round_data.nodes[1].nodes,{n=G.UIT.C, config={minw = spacing},nodes={}})
	table.insert(round_data.nodes[1].nodes,{n=G.UIT.C, config={id = 'hud_mayhem',align = "cm", padding = 0.05, minw = 1.45, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
		{n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 1.35 }, nodes={
			{n=G.UIT.T, config={text = localize('rgmc_mayhem'), scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
		}},
		{n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1.2, colour = G.C.DYN_UI.BOSS_DARK }, nodes={
			{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'mayhem'}}, font = G.LANGUAGES['en-us'].font, colours = { G.C.RGMC_UNUSUAL }, shadow = true, rotate = true, scale = 2*scale}), id = 'mayhem_UI_count'}},
		}}
	}})
    return orig
end

local blind_choice_ref = create_UIBox_blind_choice
function create_UIBox_blind_choice(type, run_info)
	local blind = blind_choice_ref(type, run_info)
	local extra = nil

	-- Capital Deck
	if G.GAME.modifiers.rgmc_capital == true then
		local is_boss = (type == 'Boss')
		local cost = G.GAME.modifiers.blind_price * (is_boss and (G.GAME.modifiers.boss_money_mult or 1.5) or 1)
		local cost_string = ' $' .. tostring(cost)
		local function insert_after_blind_name(nodes, new_node)
			for i, node in ipairs(nodes or {}) do
				print(node)
				if node.config and node.config.id == 'blind_name' then
					-- Insert right after
					table.insert(nodes, i + 1, new_node)
					return true -- done
				end
				-- search deeper
				if insert_after_blind_name(node.nodes, new_node) then
					return true
				end
			end
			return false
		end
		insert_after_blind_name(blind.nodes, { n=G.UIT.R, config = { align = "cm", padding = 0.07, r = 0.1, minw = 2.6, colour = G.C.BLACK, emboss = 0.05 }, nodes = {
			{n=G.UIT.C, config = { align = "cm" }, nodes = {
				{ n=G.UIT.O, config = { object = DynaText({ string = {{ string = localize('k_costs'), colour = G.C.WHITE}}, colours = {G.C.CHANCE}, scale = 0.35, silent = true, pop_delay = 4.5, shadow = true, maxw = 3})}},
				{ n=G.UIT.O, config = { object = DynaText({ string = {{ string = cost_string, colour = G.C.GOLD }}, colours = {G.C.CHANCE}, scale = 0.35, silent = true, pop_delay = 4.5, shadow = true, maxw = 3})}}
			}}
		}})
	end

	return blind
end

function Madcap.Funcs.mod_blind_box(blind_type, ax, original)
    return original
end

--[[
	LUXURY POINT stuff
]]

function Madcap.Funcs.get_luxury_pts_ui()
	if G.GAME.rgmc_luxury_pts == 0 then return nil end
	local scale = 0.5
	local pts_ui = {n = G.UIT.O, config = {
		object = DynaText({
			string = { { ref_table = G.GAME, ref_value = 'rgmc_luxury_pts', prefix = "£" } },
			scale_function = function()
				return scale_number(G.GAME.rgmc_luxury_pts, 1.3 * scale, 99999, 1000000)
			end,
			maxw = 1.3,
			colours = { G.C.RGMC_LUXURY },
			font = G.LANGUAGES['en-us'].font,
			shadow = true,
			spacing = 2,
			bump = true,
			scale = 1.3 * scale,
		}),
		id = 'luxury_pts_text_UI'
		}
	}
	return {n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 3.5, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
		{n=G.UIT.C, config = { align = "cm" }, nodes = {
			{ n=G.UIT.O,
				config = {
					object = DynaText({
						string = {{ string = localize('k_luxury_pts')..': ', colour = G.C.WHITE}},
						colours = { G.C.RGMC_LUXURY },
						scale = 1.0 * scale,
						silent = true,
						pop_delay = 4.5,
						shadow = true,
						maxw = 3,
					})
				}
			},
			pts_ui
		}}
	}}
end

-- convert cash to lp
function cash_to_lp(m)
	local lp = math.max(1, math.floor(m * 0.75))
	--tell('Dollars: ' .. number_format(m))
	--tell('Luxury Points: ' .. number_format(lp))
	return lp
end

function Card:calc_lp()
	return cash_to_lp(self.cost)
end

-- different one for luxury points
G.FUNCS.can_buy_luxury = function(e)
	local lp_cost = cash_to_lp(e.config.ref_table.cost)
    if lp_cost > G.GAME.rgmc_luxury_pts and lp_cost > 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.DARK_EDITION
        e.config.button = 'buy_from_shop'
    end
    if e.config.ref_parent and e.config.rref_parent.children.buy_and_use then
      if e.config.ref_parent.children.buy_and_use.states.visible then
        e.UIBox.alignment.offset.y = -0.6
      else
        e.UIBox.alignment.offset.y = 0
      end
    end
end

function ease_lp(mod, instant)
	if mod == 0 then return end
	local function _mod(mod)
		local dollar_UI = G.SHOP_SIGN and G.SHOP_SIGN:get_UIE_by_ID('luxury_pts_text_UI')
			or nil
		mod = mod or 0
		local text = '+' .. localize('£')
		local col = G.C.RGMC_LUXURY
		if to_big(mod) < to_big(0) then
			text = '-' .. localize('£')
			col = G.C.RGMC_EVIL
		end
		--Ease from current chips to the new number of chips
		G.GAME.rgmc_luxury_pts = math.max(0, G.GAME.rgmc_luxury_pts + mod)
		if dollar_UI then
			dollar_UI.config.object.string = '£' .. number_format(G.GAME.rgmc_luxury_pts or 0)
			G.SHOP_SIGN:recalculate()
			--Popup text next to the chips in UI showing number of chips gained/lost
			attention_text({
				text = text .. tostring(math.abs(mod)),
				scale = 0.5,
				hold = 0.7,
				cover = dollar_UI.parent,
				cover_colour = col,
				align = 'cm',
			})
		end
		--Play a chip sound
		play_sound('rgmc_kaching')
	end
	if instant then
		_mod(mod)
	else
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				_mod(mod)
				return true
			end
		}))
	end
end

-- does it use LP?
function Madcap.Funcs.uses_lp(card)
	return (card.ability.force_lp or card.config.force_lp)
		or card.config.center.rarity == 'rgmc_unusual'
end

-- luxury items get the L
local currency_sell_ui_ref = MadLib.define_get_currency_sell_ui
function MadLib.define_get_currency_sell_ui(card)
	if Madcap.Funcs.uses_lp(card) then
		return {n=G.UIT.T, config={text = localize('£'), colour = G.C.RGMC_LUXURY, scale = 0.4, shadow = true}}
	end
    return currency_sell_ui_ref(card)
end


--[[
	CROSS MOD SHIT
]]

Madcap.ExtraSuits = {}
Madcap.ExtraRanks = {}

Madcap.VanillaSuits = {
	Hearts 		= true,
	Diamonds	= true,
	Clubs		= true,
	Spades		= true
}


function Madcap.Funcs.init_suit_compat(suit, prefix, p)
	Madcap.ExtraSuits[suit] = { id = prefix, pos = p }
end

function Madcap.Funcs.init_rank_compat(rank, prefix, p)
	Madcap.ExtraRanks[rank] = { id = prefix, pos = p }
end

-- suit stuff
MadLib.loop_func({'goblets','towers','blooms','daggers','voids','lanterns'}, function(v,i)
	Madcap.Funcs.init_suit_compat('rgmc_'..v,'ns',i-1) -- y coord
end)

if next(SMODS.find_mod("Bunco")) then
	MadLib.loop_func({'Fleurons', 'Halberds'}, function(v,i)
		Madcap.Funcs.init_suit_compat('bunc_'..v,'bunc',i-1) -- y coord
	end)
end

if PB_UTIL then -- paperback moment!
	MadLib.loop_func({'Stars', 'Crowns'}, function(v,i)
		Madcap.Funcs.init_suit_compat('paperback_'..v,'paperback',i-1) -- y coord
	end)
end

-- UR
MadLib.loop_func({'0','0.5','1','11','12','13','21','25'}, function(v,i)
	Madcap.Funcs.init_rank_compat(MadLib.RankIds[v], 'ur',i-1) -- x coord
end)

-- HR
MadLib.loop_func({'10.5','16','24','32','34','52','55','64','128'}, function(v,i)
	Madcap.Funcs.init_rank_compat('rgmc_'..v,'hr',i-1) -- x coord
end)

-- NR
MadLib.loop_func({'Knight','Madcap','Phi','X','Sum','Infinity','Draw2','Skip','Reverse'}, function(v,i)
	Madcap.Funcs.init_rank_compat('rgmc_'..v,'nr',i-1) -- x coord
end)

tell('take a look!')
print(Madcap.ExtraSuits)
print(Madcap.ExtraRanks)
--Suit injection code based on Showdown by Mistyk__
local function inject_p_card_suit_compat(suit, rank)
	local r = Madcap.ExtraRanks[rank.key]
	local s = Madcap.ExtraSuits[suit.key]

	if not (r and s) then
        tell('FAIL for ' .. rank.key .. (r and '(+)' or '(-)') .. ' and ' .. suit.key .. (s and '(+)' or '(-)'))
        return
	end

    local full_atlas = 'rgmc_' .. s.id .. '_' .. r.id .. '_'
    --tell_stat('Full atlas is',full_atlas)
    --tell_stat('Full suit card ky thing is',suit.card_key .. '_' .. rank.card_key)

	local card = {
		name 	= rank.key .. ' of ' .. suit.key,
		value 	= rank.key,
		suit 	= suit.key,
		pos 	= { x = r.pos, y = s.pos },
		lc_atlas = full_atlas..'lc',
		hc_atlas = full_atlas..'lc'
	}
	G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = card
end

local function rank_injection(self)
	print("Performing extra rank injection YAY!")
	for _, suit in pairs(SMODS.Suits) do
		inject_p_card_suit_compat(suit, self)
	end
end

--Injected Rank List, will loop over all possible ranks
--table: key = rank_key, pos_x = rank's x position
local inject_rank_list = {}

local function inject_rank_atlas(prefix)
	MadLib.loop_table(SMODS.Ranks, function(k)
		if k:find(prefix) then
			local rank = SMODS.Ranks[k]
			rank.inject = rank_injection
			inject_rank_list[#inject_rank_list+1] = {key = k, pos_x = rank.pos.x}
			print("Injecting the graphic for rank "..rank.key)
		end
	end)
end

inject_rank_atlas('rgmc_')
inject_rank_atlas('unstb_')

Madcap.SuitIds = { 'goblets', 'towers', 'blooms', 'daggers', 'voids', 'lanterns' }

-- Temporary code until UnStableEX updates
if next(SMODS.find_mod("UnStable")) then
	local unstb_ranks = { '21', '???', '0.5', 'e', 'Pi', '1', '0', 'r2', '11', '12', '13', '25', '161' }

	MadLib.loop_func(Madcap.SuitIds, function(v1,_y)
		MadLib.loop_func(unstb_ranks, function(v2,_x)
			local id = (_x < 9) and 'ex' or 'ex2'
			local suit = SMODS.Suits['rgmc_'..v1]
			local rank = SMODS.Ranks['unstb_'..v2]

			G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = {
				name 	= rank.key .. ' of ' .. suit.key,
				value 	= rank.key,
				suit 	= suit.key,
				pos 	= { x = _x, y = _y },
				lc_atlas = 'ns_unstb_'..id..'lc',
				hc_atlas = 'ns_unstb_'..id..'lc'
			}
		end)
	end)
end

if AKYRS then
	table.insert(AKYRS.tea_cards, 'm_rgmc_boba_tea_card')
end

-- Pure ranks and suits
if AKYRS_CROSSMOD then

	local pure_atlas = 'rgmc_akyrs_pure'
	-- Madcap suits
	MadLib.loop_func(Madcap.SuitIds, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(0,i-1) }
	end)
	-- Bunco suits
	if next(SMODS.find_mod("Bunco")) then
		MadLib.loop_func({ 'Fleurons', 'Halberds' }, function(v,i)
			AKYRS_CROSSMOD.suit_to_atlas_map['bunc_'..v] = { pure_atlas, MLIB.coords(1,i-1) }
		end)
    end
	-- Paperback suits
    if next(SMODS.find_mod("Paperback")) or PB_UTIL then
		MadLib.loop_func({ 'Stars', 'Crowns' }, function(v,i)
			AKYRS_CROSSMOD.suit_to_atlas_map['paperback_'..v] = { pure_atlas, MLIB.coords(1,i+1) }
		end)
	end
	-- UnStable/Madcap overlap ranks
	local unstb = next(SMODS.find_mod("UnStable")) and 'unstb_' or 'rgmc_'
	MadLib.loop_func({ '0', '0.5', '1', '11', '12', '13', '21', '25' }, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map[unstb..v] = { pure_atlas, MLIB.coords(2,i-1) }
	end)
	-- large numbers above 10
	MadLib.loop_func({ '10.5', '16', '24', '32', '34', '52', '55', '64', '128' }, function(v,i)
		local n = i+24
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(math.floor(n/8), (i%8)-1) }
	end)
	-- and the rest!
	MadLib.loop_func({ 'Knight', 'Madcap', 'Phi', 'X', 'Sum', 'Infinity' }, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(4, i+1) }
	end)
	-- oh, and the UNO ranks too.
	MadLib.loop_func({ 'Draw2', 'Skip', 'Reverse' }, function(v,i)
		AKYRS_CROSSMOD.suit_to_atlas_map['rgmc_'..v] = { pure_atlas, MLIB.coords(5, i-1) }
	end)
	-- UnStable ranks
	if next(SMODS.find_mod("UnStable")) then
		MadLib.loop_func({ '161', '???', 'e', 'Pi', 'r2' }, function(v,i)
			AKYRS_CROSSMOD.suit_to_atlas_map['unstb_'..v] = { pure_atlas, MLIB.coords(5,2+i) }
		end)
	end
end

----------------------------------------------
------------MOD CODE END----------------------
