local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.visibility_rate = 0 -- Poptart
    ret.last_spectral = nil -- Pact
    ret.last_divine = nil -- Mind
    return ret
end

--Init stuff at the start of the game
local gigo = Game.init_game_object
function Game:init_game_object()
	local G = gigo(self)
	-- Add initial dropshot and number blocks card
	G.current_round = G.current_round or {}
    
    MadLib.merge_lists(G.current_round, {
        rgmc_barbershop = { rank = "7", suit = "Diamonds" },
        rgmc_edwin_card = { rank = "3", suit = "Clubs" },
    })

    -- Create G.GAME.events when starting a run, so there's no errors
	G.events        = {}
	G.jokers_sold   = {}
	G.dead_jokers   = {}

    G.madcap_content_rate   = 0
    G.spatia_rate       = 0
    G.cosma_rate        = 0
    G.potentia_boost    = 0
    
	Madcap.Funcs.update_global_joker_counts()
    return G
end

-- fuck it im copying paya
function Madcap.Funcs.update_global_joker_counts()
	if not G.GAME then return end
	G.GAME.Jokers = {} 
	G.GAME.Jokers.ActionReplay 		= nil
	G.GAME.Jokers.HappyStickJoker 	= nil

	MadLib.loop_func(SMODS.get_card_areas('jokers'), function(area)
		if not area.cards then return end
		MadLib.loop_func(area.cards, function(v)
			if not (v and type(v) == 'table' and not v.debuff) then return end
			local key = v.config.center_key
			if key == 'j_rgmc_action_replay' then -- Action Replay
				G.GAME.Jokers.ActionReplay = v
			end
			if key == 'j_rgmc_happy_stick_joker' then -- Happy Stick Joker
				G.GAME.Jokers.HappyStickJoker = v
			end
		end)
	end)
end

local add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
	add_to_deck_ref(self, from_debuff)
	Madcap.Funcs.update_global_joker_counts()
end

local remove_from_deck_ref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
	remove_from_deck_ref(self, from_debuff)
	Madcap.Funcs.update_global_joker_counts()
end

function Madcap.Funcs.get_aargon(card, group)
    -- find index of the given card in the group
    local idx
    for i, c in ipairs(group) do
        if c == card then
            idx = i
            break
        end
    end
    if not idx then return -9876 end  -- card not found in group
    -- look left
    local left_card = group[idx - 1]
    if not left_card then return -9876 end  -- nothing to the left
    -- check if it's bismuth
    if SMODS.has_enhancement(left_card, 'm_rgmc_bismuth') then
        -- recurse
        return Madcap.Funcs.get_aargon(left_card, group)
    else
        -- return rank of left card
        return left_card:get_id()
    end
end

MadLib.SpecificRanks['rgmc_aesthetic'] = -92895

-- Hexa & Binary Joker yoink.
local get_id_use = false

local card_get_id_ref = Card.get_id
function Card:get_id()
	if not get_id_use then
		get_id_use = true

		local id = card_get_id_ref(self) or self.base.id

		if
			self.config.center.specific_rank
		then
			tell('Has specific rank!')
			if SMODS.Ranks[self.config.center.specific_rank] then
				id = (SMODS.Ranks[self.config.center.specific_rank] and SMODS.Ranks[self.config.center.specific_rank].id)
					or MadLib.SpecificRanks[self.config.center.specific_rank]
					or -91698
			end
		end

		if SMODS.has_enhancement(self, 'm_rgmc_bismuth') then
			id = (next(SMODS.find_card('j_rgmc_aargon')) and self.area)
				and Madcap.Funcs.get_aargon(self,self.area)
				or -91798
		end

		if id == "rgmc_X" then -- x cards equal
            id = SMODS.Ranks[G.GAME.x_value].id
		end

		if -- Rio (legendary)
            next(SMODS.find_card('j_rgmc_legend_rio'))
            and id == 14
        then
            -- counts as either queen, king, or ace depending on which has fewest cards
            -- at start of blind (using G.GAME.rank_dist)
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

local is_suit_hook = Card.is_suit
function Card:is_suit(...)


    return is_suit_hook(self, ...)
end


local score_card_ref = SMODS.score_card
function SMODS.score_card(card, context)
	if card.base.value == 'rgmc_infinity' and not infinity_scoring then
		infinity_scoring = true
		local base_value, base_id = card.base.value, card.base.id
		MadLib.loop_function(G.playing_cards, function(c)
			if c == card then return end
			card.base.value = c.base.value
			card.base.id 	= c.base.id
			score_card_ref(card, context)
		end)
		card.base.value = base_value
		card.base.id 	= base_id
		infinity_scoring = nil
		return 
	end
	score_card_ref(card, context)
end

local move_forwards = function(pos, list)
	list[pos], list[pos+1] = list[pos+1], list[pos]
	return pos + 1
end

local move_backwards = function(pos, list)
	list[pos], list[pos-1] = list[pos-1], list[pos]
	return pos - 1
end

local card_shuffle_ref = CardArea.shuffle
function CardArea:shuffle(_seed)
	card_shuffle_ref(self,_seed)
	local pos = 1
	while pos < #self.cards do
		local card = self.cards[pos]
		if not card.sort_marked then
			card.sort_marked = true
			local rolls = 0
			if card.seal and card.seal == 'rgmc_patina' then
				--tell('Patina Seal')
				while pos < math.min(#self.cards / 2,#self.cards) do pos = move_forwards(pos, self.cards) end
				MadLib.number_func(10, function()
					if not SMODS.pseudorandom_probability(card, 'patina', 1, 3) then return end
					pos = move_forwards(pos, self.cards)
					rolls = rolls + 1
				end)
				--tell('Position for Patina is now' .. tostring(pos) .. '/' .. tostring(#self.cards) .. '.')
				--print(self.cards[pos].seal)
				--tell(tostring(rolls) .. ' rolls.')
			elseif card.seal and card.seal == 'rgmc_cuprum' then
				--tell('Cuprum Seal')
				while pos > math.max(#self.cards / 2,1) do pos = move_backwards(pos, self.cards) end
				MadLib.number_func(10, function()
					if not SMODS.pseudorandom_probability(card, 'cuprum', 1, 2) then return end
					pos = move_backwards(pos, self.cards)
					rolls = rolls + 1
				end)
				--tell('Position for Cuprum is now' .. tostring(pos) .. '/' .. tostring(#self.cards) .. '.')
				--print(self.cards[pos].seal)
				--tell(tostring(rolls) .. ' rolls.')
			elseif SMODS.has_enhancement(card, 'm_rgmc_plumbum') then
				tell('Plumbum enhancement')
				while pos > 1 do
					if SMODS.has_enhancement(self.cards[pos-1], 'm_rgmc_plumbum') then
						break
					end
					pos = move_backwards(pos, self.cards)
				end
				print(self.cards[pos].config.center.key)
				--tell('Position for Plumbum is now' .. tostring(pos) .. '/' .. tostring(#self.cards) .. '.')
			end
		end
		pos = pos + 1
	end
	MadLib.loop_func(self.cards, function(v)
		if not v then return end
		v.sort_marked = nil 
	end)
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
end


Madcap.Lists.RandomPoolBlacklist = {
	Voucher 	= 1,
	Booster 	= 1,
	Enhanced 	= 0,
	Edition 	= 0,
	Stake 		= 0,
	Seal 		= 0,
	Demo 		= 0,
	Back 		= 0,
	Sleeve 		= 0,
	Default 	= 0,
}

function Madcap.Funcs.get_random_set(seed, blacklist, min_number)
    local pool = pseudorandom_element(G.P_CENTER_POOLS, pseudoseed(seed))
    local set = pool and pool[1] and pool[1].set

    while not set or (blacklist[set] ~= nil and blacklist[set] < min_number) do
        pool = pseudorandom_element(G.P_CENTER_POOLS, pseudoseed(seed))
        set = pool and pool[1] and pool[1].set
    end

	return set
end

Madcap.Funcs.has_major_sticker = function(self)
	return self.ability.rgmc_shichi
		or self.ability.rgmc_coronated
		or self.ability.rgmc_unity
end

function MadLib.is_shop_area(area)
	--print('area is' .. area.key)
	return area == (G.shop_jokers or {})
    or area == (G.shop_vouchers or {})
    or area == (G.shop_booster or {})
end

local is_g1_card = function(self)
	return self.ability.eternal
		or self.ability.perishable
		or self.ability.rgmc_faulty
		or self.ability.rgmc_engraved
		or self.ability.rgmc_shielded
		or self.ability.rgmc_weakened
		or self.ability.rgmc_unstable
end

function Card:rgmc_set_faulty(a)
	self.ability.rgmc_faulty = not is_g1_card(self)
		and a
end

function Card:rgmc_set_engraved(a)
	self.ability.rgmc_engraved = not is_g1_card(self)
		and a
end

function Card:rgmc_set_shielded(a)
	self.ability.rgmc_shielded = not is_g1_card(self)
		and a
end

function Card:rgmc_set_weakened(a)
	self.ability.rgmc_weakened = not is_g1_card(self)
		and a
end

function Card:rgmc_set_unstable(a)
	self.ability.rgmc_unstable = not is_g1_card(self)
		and a
end

local is_g2_card = function(self)
	return self.ability.rgmc_positive
		or self.ability.rgmc_negative
		or self.ability.rgmc_invisible
		or self.ability.rgmc_stereo
		or self.ability.rgmc_lucky
		or self.ability.rgmc_unlucky
		or self.ability.rgmc_slashed
		or self.ability.rgmc_chained
		or self.ability.rgmc_shichi
end

function Card:rgmc_set_positive(a)
	self.ability.rgmc_positive = not is_g2_card(self)
		and a
end

function Card:rgmc_set_negative(a)
	self.ability.rgmc_negative = not is_g2_card(self)
		and a
end

function Card:rgmc_set_invisible(a)
	self.ability.rgmc_invisible = not is_g2_card(self)
		and a
end

function Card:rgmc_set_stereo(a)
	self.ability.rgmc_stereo = not is_g2_card(self)
		and a
end

function Card:rgmc_set_lucky(a)
	self.ability.rgmc_lucky = not is_g2_card(self)
		and a
end

function Card:rgmc_set_unlucky(a)
	self.ability.rgmc_unlucky = not is_g2_card(self)
		and a
end


local is_g3_card = function(self)
	return self.ability.rental
		or self.ability.rgmc_delayed
		or self.ability.rgmc_toxic
		or self.ability.rgmc_irate
		or self.ability.rgmc_dliuted
end

function Card:rgmc_set_delayed(a)
	self.ability.rgmc_delayed = not is_g3_card(self)
		and a
end

function Card:rgmc_set_toxic(a)
	self.ability.rgmc_toxic = not is_g3_card(self)
		and a
end

function Card:rgmc_set_irate(a)
	self.ability.rgmc_irate = not is_g3_card(self)
		and a
end

function Card:rgmc_set_shichi(a)
	self.ability.rgmc_shichi = not (is_g2_card(self) or Madcap.Funcs.has_major_sticker(self))
		and a
end

function Card:rgmc_set_slashed(a)
	self.ability.rgmc_slashed = not is_g2_card(self)
		and a
end

function Card:rgmc_set_chained(a)
	self.ability.rgmc_chained = not is_g2_card(self)
		and a
end

function Card:rgmc_set_diluted(a)
	self.ability.rgmc_diluted = not is_g3_card(self)
		and a
end


local is_g4_card = function(self)
	return self.ability.rgmc_painted
		or self.ability.rgmc_twinkling
		or self.ability.rgmc_immutable
		or self.ability.rgmc_coronated
end


function Card:rgmc_set_coronated(a)
	self.ability.rgmc_coronated = not (is_g4_card(self) or Madcap.Funcs.has_major_sticker(self))
		and a
end

function Card:rgmc_set_painted(a)
	self.ability.rgmc_painted = not is_g4_card(self)
		and a
end

function Card:rgmc_set_twinkling(a)
	self.ability.rgmc_twinkling = not is_g4_card(self)
		and a
end

function Card:rgmc_set_immutable(a)
	self.ability.rgmc_immutable = not is_g4_card(self)
		and a
end

local set_shop_stickers_ref =  MadLib.set_shop_stickers
function MadLib.set_shop_stickers(card)
    card = set_shop_stickers_ref(card)

    -- Faulty
    if 
        G.GAME.modifiers.rgmc_enable_faulty_in_shop 
        and pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
        and not SMODS.Stickers["rgmc_faulty"].should_apply
    then
        card:rgmc_set_faulty(true)
    end

    if G.GAME.modifiers.madcap_stickers then

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_negative"].should_apply
		then
			card:rgmc_set_negative(true)
		end

        if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_positive"].should_apply
		then
			card:rgmc_set_positive(true)
		end

        if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_shielded"].should_apply
		then
			card:rgmc_set_shielded(true)
		end

        if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_weakened"].should_apply
		then
			card:rgmc_set_weakened(true)
		end

        if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_invisible"].should_apply
		then
			card:rgmc_set_invisible(true)
		end

        if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_stereo"].should_apply
		then
			card:rgmc_set_stereo(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_lucky"].should_apply
		then
			card:rgmc_set_lucky(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_unlucky"].should_apply
		then
			card:rgmc_set_unlucky(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_delayed"].should_apply
		then
			card:rgmc_set_delayed(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_toxic"].should_apply
		then
			card:rgmc_set_toxic(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_irate"].should_apply
		then
			card:rgmc_set_irate(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_shichi"].should_apply
		then
			card:rgmc_set_shichi(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_coronated"].should_apply
		then
			card:rgmc_set_coronated(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.5
			and not SMODS.Stickers["rgmc_slashed"].should_apply
		then
			card:rgmc_set_slashed(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_chained"].should_apply
		then
			card:rgmc_set_chained(true)
		end

		if
			pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr') .. G.GAME.round_resets.ante) > 0.8
			and not SMODS.Stickers["rgmc_diluted"].should_apply
		then
			card:rgmc_set_diluted(true)
		end
    end

    return card
end

local old_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

	if not forced_key then
		if G.GAME.rgmc_glitch_enabled then
			_type = Madcap.Funcs.get_random_set('glitch_in_the_system', Madcap.Lists.RandomPoolBlacklist, MadLib.is_shop_area(area) and 1 or 2)
		elseif next(SMODS.find_card("j_rgmc_happy_stick_joker")) 
			and MadLib.list_matches_one(SMODS.find_card("j_rgmc_happy_stick_joker"), function(v)
			return SMODS.pseudorandom_probability(v, 'happy_stick_joker', 1, v.ability.extra.odds)
		end) then
			_type = Madcap.Funcs.get_random_set('happy_stick_joker', Madcap.Lists.RandomPoolBlacklist, 2)
		end
	end

	local card = old_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

	if G.GAME.mayhem then
		local mayhem_state	= mfuncs.get_mayhem_state()
		if mayhem_state > 0 then card = Madcap.Funcs.mayhemize(card) end
	end

	return card
end

-- Get pack
local getpackref = get_pack
function get_pack(_key, _type)
	local abc = getpackref(_key, _type)
	return abc
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
        if not v:nosuit() and v.base.suit ~= nil then
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



function Madcap.Funcs.mod_blind_box(blind_type, ax, original)
    return original
end

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
--[[
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
]]

local edit_uibox_ref = MadLib.edit_uibox_contents
function MadLib.edit_uibox_contents(contents, scale)
	local scale_mayhem = scale * (3/4)
	contents = edit_uibox_ref(contents, scale)
	for i=1,2 do
		contents.buttons[1].nodes[i].config.minw = contents.buttons[1].nodes[i].config.minw * 0.75
		contents.buttons[1].nodes[i].config.minh = contents.buttons[1].nodes[i].config.minh * 0.6
	end
	--contents.dollars_chips = nil
	table.insert(contents.buttons[1].nodes,{n=G.UIT.R, config={id = 'hud_mayhem',align = "cm", padding = 0.05, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
		{n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 1.35 }, nodes={
			{n=G.UIT.T, config={text = localize('rgmc_mayhem'), scale = scale_mayhem, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
		}},
		{n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1, colour = G.C.DYN_UI.BOSS_DARK }, nodes={
			{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'mayhem'}}, font = G.LANGUAGES['en-us'].font, colours = { G.C.RGMC_UNUSUAL }, shadow = true, rotate = true, scale = scale_mayhem * 2}), id = 'mayhem_UI_count'}},
		}},
		{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR}, nodes={
			{n=G.UIT.T, config={text = '/', scale = scale_mayhem, colour = darken(G.C.UI.TEXT_LIGHT,0.3), shadow = true}},
			{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'max_mayhem'}}, font = G.LANGUAGES['en-us'].font, colours = {darken(G.C.RGMC_UNUSUAL,0.2)},shadow = true, rotate = true, scale = scale_mayhem}),id = 'max_mayhem_UI'}}
		}}
	}})
	return contents
end

local uibox_ref = create_UIBox_HUD
function create_UIBox_HUD()
	local orig = uibox_ref()
		--if not Entropy.DeckOrSleeve("doc") then return orig end
    return orig
end

--[[
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
]]

local card_open_ref = Card.open
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

-- Add Remove Joker to contexts
local sd = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
    --[[if G.GAME.MADCAP then
        SMODS.calculate_context({ remove_joker = self })
    end]]
    return sd(self,a,b,c,d)
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
		--tell('Wow! Got a ' .. _rvals.id)
    end

    draw_card_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end
-- At end of round, check on Sinister Card timers
local end_round_ref = end_round
function end_round()
	end_round_ref() -- continue as usual
end

function Card:rgmc_is_temporary()
	return self.ability.rgmc_temporary
end

Madcap.Lists.EndOfRoundDebuffs = {
	'rgmc_weakened'
}

if not Entropy then
	local end_round_temp_ref = end_round
	function end_round()
		end_round_temp_ref()
		G.GAME.round_resets.path_toggled = nil
		local remove_temp = {}
		MadLib.loop_func({
			G.jokers,
			G.hand,
			G.consumeables,
			G.discard,
			G.deck
		}, function(list)
			MadLib.loop_func(list.cards, function(card)
                if card:rgmc_is_temporary() then
                    if
						card.area ~= G.hand
						and card.area ~= G.play
						and card.area ~= G.jokers
						and card.area ~= G.consumeables
					then
						card.states.visible = false
					end
                    card:remove_from_deck()
                    card:start_dissolve()
                    if card.ability.temporary then remove_temp[#remove_temp + 1] = card end
                end
				local pitch = 0
                MadLib.loop_func(Madcap.Lists.EndOfRoundDebuffs, function(v)
					if
						not (card.ability.debuff_sources
						and card.ability.debuff_sources[v])
					then
						return
					end
					pitch = pitch + 0.06
					MadLib.simple_event(function()
						SMODS.debuff_card(card, false, v)
						card:juice_up(0.3, 0.3)
						play_sound('rgmc_revert', 1 + pitch)
						return true
					end, 0.7, 'after')
				end)
			end)
		end)
		if #remove_temp > 0 then
			SMODS.calculate_context({
				remove_playing_cards = true,
				removed = remove_temp
			})
		end
	end
else
	print('chicken jockey!')
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

table.insert(SMODS.calculation_keys, "rgmc_luxury_pts")
if SMODS.other_calculation_keys then
    table.insert(SMODS.other_calculation_keys, "rgmc_luxury_pts")
end

-- Calculate individual effect fixing
if SMODS and SMODS.calculate_individual_effect then
	local cie = SMODS.calculate_individual_effect
	function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		local ret = cie(effect, scored_card, key, amount, from_edition)

		if
			MadLib.list_matches_one({'x_mult', 'xmult', 'x_mult_mod', 'xmult_mod'}, function(v)
				return v == string.lower(key)
			end) and amount ~= 1
		then
			MadLib.loop_func(SMODS.find_card('j_rgmc_squeezy_cheeze'), function(v)
				v.ability.extra.xmult_store = lenient_bignum(to_big(v.ability.extra.xmult_store) + to_big(amount))
				if v.ability.extra.xmult_store > 1 then
					--tell("New xmult_store is "..lenient_bignum(v.ability.extra.xmult_store))
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

		if key == "rgmc_luxury_pts" then -- TODO: check if this works?
			amount = math.max(amount, 0)
			G.GAME.rgmc_luxury_pts = G.GAME.rgmc_luxury_pts + amount
			text = "+£"..number_format(amount)
			if from_edition then
				card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = text, colour = G.C.RGMC_LUXURY, sound = 'rgmc_kaching', edition = true})
			else
				card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, {message = text, colour = { 0.8, 0.45, 0.85, 1 }, sound = 'rgmc_kaching', edition = true})
			end
			return true
		end
		if ret then return ret end
	end
end

if Partner_API then
	local cie_partner = SMODS.calculate_individual_effect
	function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		local ret = cie_partner(effect, scored_card, key, amount, from_edition)
		if -- Squeezy (Partner) TODO: Add this to uhhh Partner hook
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
            for i = #suits, 1, -1 do suits[#suits+1] = suits[i] end
            table.sort(suits, cmp)
            deck_size = deck_size * 2 -- double that shit
        end

        -- do the suit shit i guess
        MadLib.event({
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
        })
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
        MadLib.event({
            func = function()
                for i = 1,#G.playing_cards do
                    local _rank, _suit = rank_list[rank_index], suit_list[suit_index]
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
                    local _rank, _suit = rank_list[rank_index], suit_list[suit_index]
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
        })
    end
end

local level_up_hand_ref = level_up_hand
function level_up_hand(card, hand, instant, amount, context)
	if to_big(amount or 1) > to_big(0) then -- actually levelling up the hand
		-- Rocket Keychain: level up a random hand
		MadLib.loop_joker_effect('j_rgmc_rocket_keychain', function(v)
			if hand ~= v.ability.extra.target_hand then return end
			level_up_hand_ref(card, MadLib.get_most_played_hand(), instant, v.ability.extra.level_ups)
		end)
	end
	level_up_hand_ref(card, hand, instant, amount)
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
	local forced = false

    -- Force poker hand.
    if not forced then
		-- Waveworx
		if G.GAME.force_poker_hand then MadLib.force_poker_hand(results, G.GAME.force_poker_hand) end

		-- Mulch
		local mulch = next(SMODS.find_card('j_rgmc_mulch'))
		if mulch then
			mulch = SMODS.find_card('j_rgmc_mulch')[1]
			local high_rank, low_rank = Madcap.Funcs.get_high_and_low(hand)
			if
				high_rank == (mulch.ability.extra.ranks[1] or '7')
				and low_rank == (mulch.ability.extra.ranks[2] or '2')
			then
				MadLib.force_poker_hand(mulch.ability.extra.poker_hand or 'Straight')
			end
		end

		-- Spider Solitaire
		-- Mulch
		local spider = next(SMODS.find_card('j_rgmc_spider_solitaire'))
		if spider and results['Straight'][1] then
			local cardtype = hand[1]:has_light_suit()
				and 'light' or 'dark'
			print('card type is ' .. cardtype)
			for _, v in pairs(hand) do
				if cardtype == 'light' then
					if v:has_light_suit() then
						--print('light -> dark')
						cardtype = 'dark'
					else
						cardtype = nil
						break
					end
				else
					if v:has_dark_suit() then
						--print('dark -> light')
						cardtype = 'light'
					else
						cardtype = nil
						break
					end
				end
			end
			if cardtype then results['Straight Flush'] = results['Straight'] end
		end
    end

    return results
end

local get_blind_amount_stake_ref = get_blind_amount
function get_blind_amount(ante)
	if G.GAME.modifiers.rgmc_stake then
		local scale = G.GAME.modifiers.scaling or 1
		local amounts = {
			350,
			700 + 150*scale,
			1400 + 700*scale,
			2100 + 3600*scale,
			15000 + 5500*scale*math.log(scale + 1.5),
			12000 + 9500*(scale+1)*(0.45*scale),
			10000 + 27000*(scale+1)*((scale/3.8)^2),
			50000 * (scale+1.2)^2 * (scale/6.5)^2
		}

		if ante < 1 then return amounts[1] end
		if ante <= 8 then
			local base = amounts[ante]
			return base - base % (10 ^ math.floor(math.log10(base) - 1))
		end
		-- smoother long-term scaling
		local a = amounts[8]
		local b = amounts[8] / amounts[7]
		local c = ante - 8
		local d = 1.1 + 0.18 * c

		-- controlled exponential with damping
		local growth = (b + (b * 0.85 * c)^d) ^ (c ^ 0.85)

		-- mild logarithmic damping past ante 20
		local damp = 1 + math.log((c / 6) + 1) / 4
		local amount = math.floor(a * growth * damp)
		amount = amount - amount % (10 ^ math.floor(math.log10(amount) - 1))

		if (amount ~= amount) or amount > 1e300 then amount = 1e300 end

		return amount
	end
    return get_blind_amount_stake_ref(ante)
end


--[[
	Faulty and Weakness prevent triggering when activated
]]

function Card:cannot_trigger()
	return self.faulty_trigger
		or self.ability.rgmc_weakened_active
end

-- Jokers
local joker_calc_old = Card.calculate_joker -- preventing joker triggers
function Card:calculate_joker(context)
	if self and not self:cannot_trigger() then
		return joker_calc_old(self, context)
	end
end

-- Playing cards
local score_card_old = SMODS.score_card
function SMODS.score_card(card, context)
	if card and not card:cannot_trigger() then
		return score_card_old(card, context)
	end
end

-- Also deal with editions
local calculate_edition_ref = Card.calculate_edition
function Card:calculate_edition(context)
	if self:cannot_trigger() then return end
	return calculate_edition_ref(self, context)
end


--[[
	This is intended for anything which counts Jokers.
	For example, Joker Stencil would not count a card
	if it has Invisible.
]]
local get_quantity_value_ref = Card.get_quantity_value
function Card:get_quantity_value()
	if self.ability and self.ability.rgmc_invisible then return 0 end
	local ret = get_quantity_value_ref(self)
	if self.ability and self.ability.rgmc_stereo then ret = ret * 2 end
	return ret
end


--[[
	Flipped cards cannot be debuffed if the Streemerz Joker is owned
	Shielded cannot be debuffed (it's literally the sticker's job)
	Painted prevents debuffing because I think it's funny
]]
local set_debuff_ref = Card.set_debuff
function Card:set_debuff(should_debuff)
    if
		(self.edition and self.edition.rgmc_flipped and next(SMODS.find_card('j_rgmc_streemerz'))) -- Streemerz
		and not self.ability.rgmc_shielded 	-- shielded cannot be debuffed
		and not self.ability.rgmc_engraved 	-- this would be too easy
		and not self.ability.rgmc_painted 	-- painted cannot be debuffed because paint is cool
	then
		return
	end
	set_debuff_ref(self, should_debuff)
end

--[[
	Flipped cards cannot be killed if the Streemerz Joker is owned
	Shielded cannot be killed (it's literally the sticker's job)
	Twinkling prevents death because "plot armor" (idk probably something related to editions)
]]
local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(...)
    if
		(self.edition and self.edition.rgmc_flipped and next(SMODS.find_card('j_rgmc_streemerz'))) -- Streemerz
	 	or (self.ability.rgmc_shielded
		or self.ability.rgmc_twinkling)
	then
		print("Piss off")
        return
    end

    return start_dissolve_ref(self, ...)
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

local get_pareidolia_ref = MadLib.get_pareidolia
function MadLib.get_pareidolia(card)
	if not Card:get_quantity_value() == 0 then return false end
    return get_pareidolia_ref(card)
end

local is_face_hook = Card.is_face
function Card:is_face(...)
	-- Invisible = no face!
	if not Card:get_quantity_value() == 0 then return false end
    return is_face_hook(self, ...)
end

	-- sinister card round tickers
	--[[
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
	end]]
