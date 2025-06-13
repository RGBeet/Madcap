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


local draw_card_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if card then
        if card.ability.rgmc_jade then -- jade seal active
            to = G.deck
            dir = 'down'
            sort = true
            card.ability.rgmc_jade = nil -- we're done here'
        end
    end
    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

function RGMC.funcs.handle_glass_card_scoring(card)

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


-- sum is decided here. haha
local get_nominal_ref = Card.get_nominal
function Card:get_nominal(mod)
    if self.base.value == 'rgmc_sum' then
        tell('Sum Card found?! Wowie!')
        return RGMC.funcs.get_hand_sigma(G.play.cards) -- returns sum of hand cards
    else -- carry on!
        return get_nominal_ref(self,mod)
    end
end


-- Used to mess around with poker hand stuff (e.g. Waveworx)
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
end

-- Enables/disables special suits (cups/shields)
function RGMC.funcs.set_special_suits(x)
    if G.GAME then G.GAME.Exotic = (x or false) end
    tell('Triggered Exotic System enabling.')
end

--[[
-- Painted stickers won't let anything change enhancements
local card_set_ability_ref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    if
        self.ability
        and self.ability.rgmc_painted
    then
        self:juice_up(0.3, 0.4)
        play_sound('tarot2', 1.2, 0.4)
        return -- nope!
    end

    card_set_ability_ref(self, center, initial, delay_sprites)
end

-- Twinkling stickers won't let anything change editions
local card_set_edition_ref = Card.set_edition
function Card:set_edition(...)
    if
        self.ability
        and self.ability.rgmc_twinkling
    then
        self:juice_up(0.3, 0.4)
        play_sound('tarot2', 1.2, 0.4)
        return nil
    end

    return card_set_edition_ref(self,...)
end
]]

local light_suits = {"Diamonds","Hearts","rgmc_goblets"}
function Card:is_light_suit()
    for _, suit in ipairs(light_suits) do
		if self:is_suit(suit,true,false) then return true end; end
    return false
end

local dark_suits = {"Spades","Clubs","rgmc_towers"}
function Card:is_dark_suit()
    for _, suit in ipairs(dark_suits) do
		if self:is_suit(suit,true,false) then return true end; end
    return false
end

local regular_suits = {"Diamonds","Hearts","Spades","Clubs"}
function Card:is_regular_suit()
    for _, suit in ipairs(regular_suits) do
		if self:is_suit(suit,true,false) then return true end; end
    return false
end

local special_suits = {"rgmc_goblets","rgmc_towers"}
function Card:is_special_suit()
    for _, suit in ipairs(special_suits) do
		if self:is_suit(suit,true,false) then return true end; end
    return false
end

function RGMC.funcs.get_default_attention_hold(text)
    return G.SETTINGS.GAMESPEED * (#text * 0.02 + 1.3)
end
-- Returns a random rank within the nominal values listed - if no values are set, any rank can be returned.
function RGMC.funcs.get_random_rank(a,b)
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


function RGMC.funcs.add_booster_to_shop(key, params)

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


function RGMC.funcs.get_common_jokers(r)
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


-- SIMPLE JUICE
-- Does a simple little juice - can do a silly sound too!
function RGMC.funcs.simple_juice(card, sound)
	G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
		play_sound((sound or 'tarot2'), 0.76, 0.4)
		card:juice_up(0.5, 0.7)
		return true end }))
end

-- APPLY SEAL TO RANDOM
-- Applies a seal to a random card from a specified card area # times
function RGMC.funcs.apply_seal_to_random(seal, times, context, cardarea)
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
function RGMC.funcs.card_is_rankless_suitless(card)
    return SMODS.has_no_suit(card)
    or SMODS.has_enhancement(card, "m_cry_abstract") -- abstract card
end


-- GET BLINDS PER ANTE
-- used to determine whether we are at the last blind of the ante?
function RGMC.funcs.get_blinds_per_ante()
	return 3
end

-- Used to check position in list, returns as integer?
function RGMC.funcs.get_position_in_list(obj,list)
    if not (obj and list) then return -1 end -- uh oh!

    for i=1,#list do
        if list[i] == obj then
            return i -- found it!
        end
    end
    return -1 -- cannot find it.
end

-- Gets a random Poker Hand (usually visible) - used in Rocket Keychain
function RGMC.funcs.get_random_poker_hand(bypass_visible,min_hand,max_hand)
	local chosen_hand = nil

    -- make a temporary list, shuffle it.
	local shuffle_deck = RGMC.funcs.deep_copy(G.handlist)
    pseudoshuffle(shuffle_deck,seed)

    for i=1,#shuffle_deck do
        local passes = true
        chosen_hand = shuffle_deck[i]

        -- if minimum hand exists, cannot be lower in list than minimum hand
        if min_hand then
            if RGMC.funcs.get_position_in_list(G.handlist,min_hand) > RGMC.funcs.get_position_in_list(G.handlist,chosen_hand) then
                passes = false
            end
        end

        -- if maximum hand exists, cannot be higher in list than maximum hand
        if max_hand then
            if RGMC.funcs.get_position_in_list(G.handlist,max_hand) < RGMC.funcs.get_position_in_list(G.handlist,chosen_hand) then
                passes = false
            end
        end

        if -- if it is visible, or visible is not needed, and it passes
            (bypass_visible or G.GAME.hands[chosen_hand].visible)
            and passes
        then
            return chosen_hand
        end
    end

    return nil -- you get NOTHING!
end


-- From JenLib - used to determine whether the card has no suit.
function Card:nosuit()
    return SMODS.has_enhancement(self, "m_stone")
		or SMODS.has_enhancement(self, "m_rgmc_bismuth")
		or self.config.center.no_suit
end


-- Turns a number into its ordinal (e.g. 1 -> 1st, 10 -> 10th, etc.)
-- Used for Changing Had
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

-- Takes a rarity id. If it's in Madcap's rarity index, return that value - otherwise, return 0.
function RGMC.funcs.get_rarity_value(val)
	local rarval = RGMC.rarities[val] and RGMC.rarities[val].value or 0
	return rarval
end

-- In case the following function gets a numeric id from vanilla Balatro
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
		--tell('Invalid Joker Rarity: ' .. tostring(joker.config.center.rarity))
		return false -- not a real rarity!
	end

	--tell("Joker Rarity  is " .. tostring(joker_rarity) .. ", and Minimum Rarity is " .. tostring(val) .. ".")
	local v1, v2 = RGMC.funcs.get_rarity_value(joker_rarity), RGMC.funcs.get_rarity_value(val)
	--tell("Joker Rarity Val is " .. tostring(v1) .. ", and Minimum Rarity Val is " .. tostring(v2) .. ".")

	return equals and (v1 and v1 >= v2 or false) or (v1 and v1 > v2 or false)
end

-- Returns how many Jokers in the specified cardarea (G.jokers) exceed (or equal) the specified requirement
function RGMC.funcs.jokers_greater_than_rarity(group, rarity, equals)
	local matches = 0
	for k,v in pairs(group) do
		if RGMC.funcs.greater_than_rarity(v, rarity, equals or false) then
			matches = matches + 1
		end
	end
	return matches
end

-- Gets the nominal ranks of all regular ranks in the group (usually G.hand.cards).
-- Used for the Sum rank.
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

-- Is the current ante (or specified) a finisher blind ante?
function RGMC.funcs.is_finisher_ante(ante)
    return (ante or G.GAME.round_resets.ante) % G.GAME.win_ante == 0
end
