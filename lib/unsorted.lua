


-- is the card any of these?
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

-- is the suit any of these?
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

-- Count a singular suit
function RGMC.funcs.count_suit(group,target)
	local number = 0
	for i = 1, #group do
		if group[i]:is_suit(target) and not group[i]:nosuit() then number = number + 1 end
	end
	return number
end

-- Checks whether the rank of a card is one
-- that is not standard (Sum, Infinity, X, Entropy's Nil)
function RGMC.funcs.is_irregular_rank(card)
	local rank = card:get_id()

	return rank == 'rgmc_sum'
end

-- the cooler irregular rank checker
function Card:is_irregular_rank()
	return self.id == 'rgmc_sum'
end

-- used for finding the sum card value
function RGMC.funcs.get_hand_sigma(group)
	local total = 0
    for _, v in ipairs(group) do
        if not (SMODS.has_no_rank(v) or RGMC.funcs.is_irregular_rank(v))  then
            local rank = SMODS.Ranks[v.base.value]
            total = total + rank.nominal
        end
    end
	return total
end

-- function to shuffle the array
function RGMC.funcs.shuffle(array)
	local returnArray = {}
	for i = #array, 1, -1 do
		local j = math.random(i)
		array[i], array[j] = array[j], array[i]
		table.insert(returnArray, array[i])
	end
	-- return the target array
	return returnArray
end

-- Checks whether the Joker falls within a certain rarity
function RGMC.funcs.meets_joker_rarity_req(j,a,b,e)
	local low, high, rarity, equals = a or 0, b or 10, RGMC.rarities[j.config.center.rarity] or 0, e or false
	return equals and (rarity >= a and rarity <= b) or (rarity > a and rarity < b)
end

function RGMC.funcs.get_rarity_value(val)
	local rarval = RGMC.rarities[val] and RGMC.rarities[val].value or 0
	return rarval
end

local rarity_conversion = {
	[1] = 'Common',
	[2] = 'Uncommon',
	[3] = 'Rare',
	[4] = 'Legendary'
}

-- Checks whether the Joker falls within a certain rarity
function RGMC.funcs.greater_than_rarity(joker,val,equals)
	local joker_rarity

	if SMODS.Rarities[joker.config.center.rarity] then
		joker_rarity = SMODS.Rarities[joker.config.center.rarity].key
	elseif rarity_conversion[joker.config.center.rarity] then
		joker_rarity = rarity_conversion[joker.config.center.rarity]
	else
		tell('Invalid Joker Rarity: ' .. tostring(joker.config.center.rarity))
		return false -- not a real rarity!
	end

	tell("Joker Rarity  is " .. tostring(joker_rarity) .. ", and Minimum Rarity is " .. tostring(val) .. ".")

	local v1 = RGMC.funcs.get_rarity_value(joker_rarity)
	local v2 = RGMC.funcs.get_rarity_value(val)

	tell("Joker Rarity Val is " .. tostring(v1) .. ", and Minimum Rarity Val is " .. tostring(v2) .. ".")

	if equals then
		return v1 and v1 >= v2 or false
	else
		return v1 and v1 > v2 or false
	end
end

function RGMC.funcs.jokers_greater_than_rarity(group, rarity, equals)
	local matches = 0
	for k,v in pairs(group) do
		if RGMC.funcs.greater_than_rarity(v, rarity, equals or false) then
			matches = matches + 1
		end
	end
	return matches
end


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

-- Do a random number check using the card's odds config and the game's probability stat.
function RGMC.funcs.get_random(card, seed)
    local full_seed = seed and 'rgmc_'..seed or 'rgmc'
    local first, second = pseudoseed(full_seed), (G.GAME.probabilities.normal or 1) / card.ability.extra.odds
    --tell("PROBABILITY: "..tostring(first).." then "..tostring(second))
    return first < second
end

-- Do a random number check using a specified odds and the game's probability stat. (Used outside of card stuff)
function RGMC.funcs.rand_check(a,b,seed)
    local odds, bypass, full_seed = a or 2, b or false, 'rgmc_'..seed or 'rgmc'
    local num = pseudoseed(full_seed), ((bypass and 1 or G.GAME.probabilities.normal) or 1) / odds
    --tell("PROBABILITY: "..tostring(first).." then "..tostring(second))
    return num > odds
end

function RGMC.funcs.madcap_active()
    return G.GAME and G.GAME.MADCAP
end

-- card has no dang rank
function Card:norank()
    return SMODS.has_enhancement(self, "m_stone")
		or SMODS.has_enhancement(self, "m_rgmc_bismuth")
		or self.config.center.no_rank
end

-- add context for bonus info
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
						level_up_hand_ref(card, RGMC.funcs.get_most_played_hand(), instant, v.ability.extra.level_ups)
					end
				end
			end
		end
	end

	level_up_hand_ref(card, hand, instant, amount)
end

function RGMC.funcs.get_num_position(n)
    local suffix = "th"
    if n % 100 < 11 or n % 100 > 13 then
        local lastDigit = n % 10
        if lastDigit == 1 then
            suffix = "st"
        elseif lastDigit == 2 then
            suffix = "nd"
        elseif lastDigit == 3 then
            suffix = "rd"
        end
    end
    return tostring(n) .. suffix
end

function RGMC.funcs.simple_event(doohickey)
    G.E_MANAGER:add_event(Event({func = doohickey}))
end

function RGMC.funcs.edition_in_play(context, card)
	return (
		context.edition
		and context.cardarea == G.jokers
		and card.config.trigger
	) or (
		context.main_scoring
		and context.cardarea == G.play
	)
end

function RGMC.funcs.reset_rgmc_barbershop_order()
    --tell('Barber Pole Shuffle')

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



local deck_apply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(self)
    deck_apply_to_run_ref(self)

    if
        self.effect.config.starting_suits
        and not self.effect.config.starting_ranks
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
        self.effect.config.starting_suits
        and self.effect.config.starting_ranks
    then
        local suit_size = #self.effect.config.starting_suits -- number of suits
        local suit_list = self.effect.config.starting_suits -- the list of suits

        local rank_size = #self.effect.config.starting_ranks -- number of ranks
        local rank_list = self.effect.config.starting_ranks -- the list of ranks

        local deck_size = suit_size * rank_size

        local suit_index, rank_index, total = 1, 1, 0
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1,#G.playing_cards do
                    if suit_index > suit_size then
                        if rank_index+1 > rank_size then
                            break
                        else
                            rank_index = rank_index + 1
                        end
                        suit_index = 1
                    end
                    local r, s = rank_list[rank_index], suit_list[suit_index]
                    assert(SMODS.change_base(G.playing_cards[i], s, r))

                    suit_index = suit_index + 1
                    total = total + 1
                end


                for i = 1, (deck_size - total) do
                    if suit_index > suit_size then
                        if rank_index+1 > rank_size then
                            break
                        else
                            rank_index = rank_index + 1
                        end
                        suit_index = 1
                    end
                    local r, s = rank_list[rank_index], suit_list[suit_index]

					local _card = copy_card(G.playing_cards[#G.playing_cards])
                    assert(SMODS.change_base(_card, s, r))
					_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)

                    suit_index = suit_index + 1
                    total = total + 1
                end

                return true
            end
        }))
    end
end


function RGMC.funcs.get_unlock(rank)
    return false
end

function RGMC.funcs.handle_deck_showdown(showdown)
	return G.GAME.round_resets.ante % G.GAME.win_ante == 0		-- Finisher Blind ante
			and (not G.GAME.bosses_used[showdown] -- Haven't seen [Showdown] this run?
			or (G.GAME.bosses_used[showdown]
			and (pseudorandom(pseudoseed("rgmc_handle_deck_showdown")) < (1/3)))) -- Fixed 1 in 3 chance after first [Showdown]
end

local get_new_boss_ref = get_new_boss
function get_new_boss()

	--[[
	local cards = BerryLegendaries and SMODS.find_card('j_blurb_zohn') or nil
	for _,v in pairs(cards) do
		if v.ability.extra.change_boss == true then
			v.ability.extra.change_boss = false
			return 'bl_wall'
		end
	end
	]]

	local set_finisher = nil

	-- Pale Deck: The Force & Midnight Void appear more often.
	if G.GAME.modifiers.rgmc_pale then
		set_finisher = "bl_rgmc_final_void"
		if RGMC.funcs.handle_deck_showdown(set_finisher) then -- Guaranteed Midnight Void
			return set_finisher
		end
		if G.GAME.modifiers.rgmc_force_awakened then -- Force chance activated
			return "bl_rgmc_force"
		end
	end

	-- Punisher Tag: rerolls boss blind into finisher blind.
	if G.GAME.rgmc_punisher then
		G.GAME.rgmc_punisher = nil -- dont need this anymore

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
