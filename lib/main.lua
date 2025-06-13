
function RGMC.funcs.run_start()
    -- start of run
    tell('Run Start')

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
        force_poker_hand    = nil       -- in case cryptid isnt here.
    }

    G.GAME.Exotic = G.GAME.Exotic or false -- Used for exotic suits and ranks?

    RGMC.funcs.ante_start() -- Since the game starts at the first ante...?
end

-- Upon selecting the blind...
function RGMC.funcs.blind_start()
    -- start of blind
    tell('Blind Start')

    G.GAME.MADCAP.rank_dist = RGMC.funcs.get_ranks_in_deck()

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
function RGMC.funcs.blind_end()

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
function RGMC.funcs.ante_start()
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
		first_hand_type	= nil,	-- first hand type (for madcap mouth)
	}


	local x_card = G.playing_cards and pseudorandom_element(G.playing_cards, pseudoseed('rgmc_x_value')) or nil -- pick a card, any card...
	G.GAME.MADCAP.x_value = x_card and x_card.base.value or "10" -- The rank becomes the x's rank

	for key, _ in pairs(G.GAME.round_resets.blind_choices) do
		if G.P_BLINDS[G.GAME.round_resets.blind_choices[key]].rgmc_ante_start then
            G.P_BLINDS[G.GAME.round_resets.blind_choices[key]]:rgmc_ante_start()
        end
	end

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
function RGMC.funcs.ante_finish()
    -- end of ante
    tell('Ante End')

end

-- Upon starting a shop
function RGMC.funcs.shop_start()
    -- start of shop
    tell('Shop Start')

end

-- Upon recording a singular card?
function RGMC.funcs.record_card(card)
    -- recording card
    tell('Record Card')
end

-- Upon playing a hand...
function RGMC.funcs.play_hand(hand)
    -- recording hand
    tell('Play Hand')
    G.GAME.MADCAP.ante.hands = G.GAME.MADCAP.ante.hands + 1
end

-- Upon discarding a hand...
function RGMC.funcs.discard_hand(hand, chips, text)
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
function RGMC.funcs.blind_skip()
    -- start of blind
    tell('Blind Skip')
    G.GAME.MADCAP.blinds_skipped = G.GAME.MADCAP.blinds_skipped and G.GAME.MADCAP.blinds_skipped + 1 or 0
end

-- Record hand
function RGMC.funcs.record_hand(hand, chips, text)

    local hand_type = G.GAME.MADCAP.ante.hand_types[text]

    SMODS.calculate_context({ rgmc_total_score = chips })

	tell('Score is now ' .. tostring(chips) .. ".")
    for i=1,#hand do
        local card = hand[i]

        -- rank type stuff
        G.GAME.MADCAP.ante.ranks[card.base.value] = G.GAME.MADCAP.ante.ranks[card.base.value] or 0
        if G.GAME.MADCAP.ante.ranks[card.base.value] == 0 then -- rank
            G.GAME.MADCAP.ante.unique_ranks = G.GAME.MADCAP.ante.unique_ranks + 1
            --tell('Total unique ranks: '..G.GAME.MADCAP.ante.unique_ranks)
        end
        G.GAME.MADCAP.ante.ranks[card.base.value] = G.GAME.MADCAP.ante.ranks[card.base.value] + 1

        -- suit type stuff
        G.GAME.MADCAP.ante.suits[card.base.suit] = G.GAME.MADCAP.ante.suits[card.base.suit] or 0
        if G.GAME.MADCAP.ante.suits[card.base.suit] == 0 then -- suit
            G.GAME.MADCAP.ante.unique_suits = G.GAME.MADCAP.ante.unique_suits + 1
            --tell('Total unique suits: '..G.GAME.MADCAP.ante.unique_suits)
        end
        G.GAME.MADCAP.ante.suits[card.base.suit] = G.GAME.MADCAP.ante.suits[card.base.suit] + 1

        if card:is_face(true) then G.GAME.MADCAP.ante.faces_scored = G.GAME.MADCAP.ante.faces_scored + 1 end

        if card.config.center ~= G.P_CENTERS.c_base then
            G.GAME.MADCAP.last_enhancement = card.config.center
            --tell('Last enhancement is now '..G.GAME.MADCAP.last_enhancement.key)
        end
    end

    G.GAME.MADCAP.ante.hand_types[text] = G.GAME.MADCAP.ante.hand_types[text] or 0
    G.GAME.MADCAP.ante.hand_types[text] = G.GAME.MADCAP.ante.hand_types[text] + 1

    --tell_stat('unique hand types',#G.GAME.MADCAP.ante.hand_types)

end

-- Gets the number of each rank in deck.
-- Used to find the most/least of each rank.
function RGMC.funcs.get_ranks_in_deck()
    local deck = {}
    for i=1, #G.deck.cards do
        local card = G.deck.cards[i]
        deck[card.base.value] = deck[card.base.value] or 0
        deck[card.base.value] = deck[card.base.value] + 1
    end

    return deck
end


-- Used for Perilous and Boomerang tags - adds (or removes) chips to blind.
function Blind:add_chips(chips)
	G.GAME.blind.chips = G.GAME.blind.chips + chips
	G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	G.GAME.blind:wiggle()
	return true
end

-- Checks if it's time for EXOTICS (Goblets and Towers) - like in Bunco
function RGMC.funcs.exotic_in_pool(suit)
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

function findInTable(e, t)
	for k, v in pairs(t) do
		if v == e then return k end
	end
	return -1
end


function ReverseTable(t)
	local rt = {}
	for i = #t, 1, -1 do
		rt[#rt+1] = t[i]
	end
	return rt
end


-- Used strictly by SMODS.calculate_main_scoring
function RGMC.funcs.alter_score_order(card,scoring_hand,context,in_scoring)

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

function RGMC.funcs.get_rio_rank()

    if not (G.GAME and G.GAME.MADCAP and G.GAME.MADCAP.rank_dist) then -- this should work, G.GAME.MADCAP is made on start
        --tell('Ooh... my head hurty...')
        return "Ace"
    end

    local minimum, selection = #G.deck.cards, nil
    local rank_values = {
        "Queen",
        "King",
        "Ace"
    }

    -- which is the lowest? if tie, prioritize by order
    for i=1, #rank_values do
        local thing, amt = rank_values[i], G.GAME.MADCAP.rank_dist[rank_values[i]]
        tell("There are " .. tostring(amt) .. " of " .. tostring(thing) .. ".")
        if amt <= minimum then
            tell("That is enough.")
            minimum = amt
            selection = rank_values[i]
        end
    end

    --tell("Rio's really feeling like a "..selection)
    return selection
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

            id = SMODS.Ranks[RGMC.funcs.get_rio_rank()].id
        end

        if id == "rgmc_sigma" then -- equals number cards in playing hand
            local _, _2, _3, scoring = G.FUNCS.get_poker_hand_info(G.play.cards)
            if next(SMODS.find_card('j_rgmc_legend_rio')) then
                scoring  = G.play.cards
            end
            id = RGMC.funcs.get_hand_sigma(scoring)
		end

		get_id_use = false
		return id
	else
		get_id_use = false
		return card_get_id_ref(self)
	end

end

function RGMC.funcs.winning()
    return G.GAME and (to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) <= to_big(0) or false
end

function RGMC.funcs.do_x_score(exp, times)

    local amt = exp ^ times

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
        func = function()
            G.GAME.chips = (to_big(G.GAME.chips)) * (to_big(amt))
            G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
            play_sound('holo1')
            return true
            end,
        }))

    return {
        message = "X" .. tostring(amt),
        colour = G.C.PURPLE
    }
end

function RGMC.funcs.do_e_score(exp, times)

    local amt = exp
    for i = 1, times do amt = exp ^ times end

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
        func = function()
            G.GAME.chips = (to_big(G.GAME.chips)) ^ (to_big(amt))
            G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.8, 0.8)
            play_sound('talisman_emult')
            return true
            end,
        }))

    return {
        message = "^" .. tostring(amt),
        colour = G.C.PURPLE
    }
end


-- GET MOST PLAYED HAND
-- Gets the most played poker hand
function RGMC.funcs.get_most_played_hand()
	-- defaults to high card
	if not G.GAME or not G.GAME.current_round then return 'High Card' end
	local chosen_hand 	= 'High Card'
	local hand_name 	= 'High Card'
	local most_played 	= -1
	local cur_order 	= -1
	for k, v in pairs(G.GAME.hands) do
		if
			v.played > most_played
			or (v.played == most_played and cur_order > v.order)
		then
			most_played = v.played
			hand_name = k
		end
	end
	chosen_hand = hand_name
	return chosen_hand
end

-- FLIP CARDS (from Entropy)
-- needed a good animation for strength effect
function RGMC.funcs.flip_cards(cardlist, func, before, after)
    if not Talisman.config_file.disable_anims then
        for i, v in ipairs(cardlist) do
            local card = cardlist[i]
            if card then
                G.E_MANAGER:add_event(
                    Event(
                        {
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                if before then
                                    before(card)
                                end
                                if card.flip then
                                    card:flip()
                                end
                                return true
                            end
                        }
                    )
                )
            end
        end
    else
        if before then
            before(card)
        end
    end
    for i, v in ipairs(cardlist) do
        local card = cardlist[i]
        if card then
            G.E_MANAGER:add_event(
                Event(
                    {
                        trigger = "after",
                        delay = 0.15,
                        func = function()
                            func(card, cardlist, i)
                            return true
                        end
                    }
                )
            )
        end
    end
    if not Talisman.config_file.disable_anims then
        for i, v in ipairs(cardlist) do
            local card = cardlist[i]
            if card then
                G.E_MANAGER:add_event(
                    Event(
                        {
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                if card.flip then
                                    card:flip()
                                end
                                if after then
                                    after(card)
                                end
                                return true
                            end
                        }
                    )
                )
            end
        end
    else
        if after then
            after(card)
        end
    end
end

-- Weighted edition system
edition_weights = {
	['e_foil'] 				= 5,
	['e_holo'] 				= 4,
	['e_polychrome'] 		= 3,
	['e_rgmc_chrome'] 		= 3,
	['e_rgmc_iridescent'] 	= 2,
	['e_rgmc_disco'] 		= 2,
	['e_rgmc_chrome'] 		= 2,
	['e_negative'] 			= 1,
}

if Cryptid then
	tell('Cryptid Eiditions added!')

	edition_weights['e_cry_mosaic'] = 2

	for k,v in pairs(edition_weights) do v = v * 2 end

	edition_weights['e_cry_blurred'] 	= 2
	edition_weights['e_cry_gold'] 		= 2
	edition_weights['e_cry_glass'] 		= 1
	edition_weights['e_cry_glitched'] 	= 1
	edition_weights['e_cry_oversat'] 	= 1

	for k,v in pairs(edition_weights) do v = v * 2 end

	edition_weights['e_cry_m'] 			= 1
	edition_weights['e_cry_noisy'] 		= 1
	edition_weights['e_cry_astral'] 	= 1
end

-- TODO: add cryptid

function RGMC.funcs.get_weighted_edition()
	local weight_table = {}
	local number, minimum = 0, 1e6
	local edition = nil

	for k, v in pairs(edition_weights) do
		number = number + v
		weight_table[k] = number
		if minimum > v then -- we'll need the minimum for later
			minimum = v
		end
	end

	for i=1, #weight_table do
		weight_table[i] = weight_table[i] - minimum + 1
	end -- subtract minimum

	number = math.random(1, number) -- choose a random number

	for k, v in pairs(weight_table) do
		-- will keep picking until it finds a number larger than it (that's the one!)
		if number > v then edition = k end
	end

	return edition -- we got our edition
end

-- Weighted enhancement system
enhancement_weights = {
	['m_bonus'] 			= 4,
	['m_mult'] 				= 4,
	['m_steel'] 			= 3,
	['m_gold'] 				= 2,
	['m_stone'] 			= 3,
	['m_glass'] 			= 2,
	['m_lucky'] 			= 2,
	['m_rgmc_ferrous'] 		= 2,
	['m_rgmc_wolfram'] 		= 2,
	['m_rgmc_lustrous'] 	= 1
}

if Cryptid then
	tell('Cryptid Enhancements added!')

	enhancement_weights['m_cry_echo'] 		= 2
	enhancement_weights['m_cry_light'] 		= 2

	for k,v in pairs(enhancement_weights) do v = v * 5 end

	enhancement_weights['m_cry_abstract'] 	= 2
end

function RGMC.funcs.get_weighted_enhancement()
	local weight_table = {}
	local number, minimum = 0, 1e6
	local enhancement = nil

	for k, v in pairs(enhancement_weights) do
		number = number + v
		weight_table[k] = number
		if minimum > v then -- we'll need the minimum for later
			minimum = v
		end
	end

	for i=1, #weight_table do
		weight_table[i] = weight_table[i] - minimum + 1
	end -- subtract minimum

	number = math.random(1, number) -- choose a random number

	for k, v in pairs(weight_table) do
		-- will keep picking until it finds a number larger than it (that's the one!)
		if number > v then enhancement = k end
	end

	return enhancement -- we got our enhancement
end


-- Weighted booster system
booster_weights = {
	['p_arcana_normal'] 	= 10,
	['p_arcana_jumbo'] 		= 8,
	['p_arcana_mega'] 		= 4,
	['p_celestial_normal'] 	= 9,
	['p_celestial_jumbo'] 	= 7,
	['p_celestial_mega'] 	= 4,
	['p_spectral_normal'] 	= 6,
	['p_spectral_jumbo'] 	= 4,
	['p_spectral_mega'] 	= 2,
	['p_standard_normal'] 	= 9,
	['p_standard_jumbo'] 	= 7,
	['p_standard_mega'] 	= 4,
	['p_buffoon_normal'] 	= 9,
	['p_buffoon_jumbo'] 	= 7,
	['p_buffoon_mega'] 		= 4,
}

if Cryptid then
	tell('Cryptid Boosters added!')
	booster_weights['p_cry_meme_1'] 		= 4
	booster_weights['p_cry_meme_two'] 		= 2
	booster_weights['p_cry_meme_three'] 	= 1
	booster_weights['p_cry_code_normal_1'] 	= 4
	booster_weights['p_cry_code_jumbo_1'] 	= 2
	booster_weights['p_cry_code_mega_1'] 	= 1

	for k,v in pairs(booster_weights) do
		v = v * 10
	end
	booster_weights['p_cry_empowered'] = 3
	booster_weights['p_cry_baneful_1'] = 5
end

function RGMC.funcs.get_weighted_booster()
	local weight_table = {}
	local number, minimum = 0, 1e6
	local edition = nil

	for k, v in pairs(edition_weights) do
		number = number + v
		weight_table[k] = number
		if minimum > v then -- we'll need the minimum for later
			minimum = v
		end
	end

	for i=1, #weight_table do
		weight_table[i] = weight_table[i] - minimum + 1
	end -- subtract minimum

	number = math.random(1, number) -- choose a random number

	for k, v in pairs(weight_table) do
		-- will keep picking until it finds a number larger than it (that's the one!)
		if number > v then edition = k end
	end

	return edition -- we got our edition
end

-- This is what I use for most randomization
function RGMC.funcs.calculate_roll(params)
    if not params then
        tell("Calculate Roll - No parameters added?!")
        return false -- NEEDS PARAMS!
    end

    local denom = params.denom or ( card and (card.ability.odds or card.ability.extra.odds or card.ability.immutable.odds) or 1e6)
    local numer = params.numer or G.GAME.probabilities.normal
    local exp   = params.exp or 1


    if denom == 1e6 then
        tell('Probability not found, set to 1e6. Please fix!')
    end

    if
        params.card    -- uses a card
    then
        if
            Cryptid     -- is Cryptid installed? (implements cry_prob)
        then
            local card, cry_denom = params.card, card.ability.cry_prob ^ (params.exp or 1)
            -- If no denominator is dictated, looks for card odds or drops a 1 in 2.
            return cry_prob(card.ability.cry_prob, denom, card.ability.cry_rigged)
        end
    end

    return pseudorandom(pseudoseed(params.seed or 'rgmc')) < (numer ^ exp) / denom
end

-- This is what I use for most randomization
function RGMC.funcs.calculate_card_odds(c, s)
    local params = { card = card }
    if s then
        params.seed = s
    end
    return RGMC.funcs.calculate_roll(params)
end

-- Simple way to get a random element from list.
function RGMC.funcs.get_random_from_list(list, seed)
    return pseudorandom_element(list, pseudoseed(seed or RGMC.seed))
end

-- A cleaner function add event function without all those pesky parentheses!
-- Only takes function
function RGMC.funcs.simple_event(doohickey)
    G.E_MANAGER:add_event(Event({func = doohickey}))
end

-- Why deep copy? To avoid references to pre-existing values that I dont want to change.
-- Deep copy, taken from Cryptid
function RGMC.funcs.deep_copy(obj, seen)
	if type(obj) ~= "table" then
		return obj
	end
	if seen and seen[obj] then
		return seen[obj]
	end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do
		res[RGMC.funcs.deep_copy(k, s)] = RGMC.funcs.deep_copy(v, s)
	end
	return res
end

-- Returns the number of cards in a group that have a specified suit.
function RGMC.funcs.count_suit(group,target)
	local number = 0
	for i = 1, #group do
		if group[i]:is_suit(target) and not group[i]:nosuit() then number = number + 1 end
	end
	return number
end

-- Takes a card and returns whether the card's rank id falls within the list of rank ids.
function RGMC.funcs.card_rank_in_list(card,list)
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
function RGMC.funcs.card_suit_in_list(card,list)
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
function RGMC.funcs.is_playing_blind()
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
function RGMC.funcs.is_choosing_card()
    return G.STATE == G.STATES.TAROT_PACK
        or G.STATE == G.STATES.PLANET_PACK
        or G.STATE == G.STATES.SPECTRAL_PACK
        or G.STATE == G.STATES.STANDARD_PACK
        or G.STATE == G.STATES.BUFFOON_PACK
        or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
end

-- Is choosing a Celestial / Spectral pack. (Used for music!)
function RGMC.funcs.is_choosing_celestial()
    return G.STATE == G.STATES.PLANET_PACK
        or G.STATE == G.STATES.SPECTRAL_PACK
end

function RGMC.funcs.get_boss_status()
    return
        not (G.GAME.blind
        and G.GAME.blind.boss)
    and 0 or
        RGMC.funcs.is_finisher_ante()
        and (G.GAME.blind
        and G.GAME.blind.boss
        and G.GAME.blind.showdown)
    and 2 or 1
end

-- From Cryptid
function RGMC.funcs.safe_get(t, ...)
	local current = t
	for _, k in ipairs({ ... }) do
		if not current or current[k] == nil then
			return false
		end
		current = current[k]
	end
	return current
end

function RGMC.funcs.get_num_enhanced(group, key)
    if not (G.GAME and group) then return 0 end
    local cards = 0

    for k,v in pairs(group) do
        if v.config.center == G.P_CENTERS['m_'..key] then cards = cards + 1 end
    end

    return cards
end

