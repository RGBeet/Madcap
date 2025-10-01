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
	print("ADD TO DECK!")
	if (not self.added_to_deck) and not from_debuff then
		if self.added_to_deck and self.ability and self.ability.rgmc_positive and G.hand then
			G.hand.config.card_limit = G.hand.config.card_limit - 1
		end
	end
	add_to_deck_ref(self, from_debuff)
	Madcap.Funcs.update_global_joker_counts()
end

local remove_from_deck_ref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
	if self.added_to_deck and self.ability and self.ability.rgmc_positive and G.hand and not from_debuff then
		if self.added_to_deck and self.ability and self.ability.rgmc_positive and G.hand then
			G.hand.config.card_limit = G.hand.config.card_limit + 1
		end
	end
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

function MadLib.is_shop_area(area)
	--print('area is' .. area.key)
	return area == (G.shop_jokers or {})
    or area == (G.shop_vouchers or {})
    or area == (G.shop_booster or {})
end

local old_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)

	if G.GAME.rgmc_glitch_enabled then
		_type = Madcap.Funcs.get_random_set('glitch_in_the_system', Madcap.Lists.RandomPoolBlacklist, MadLib.is_shop_area(area) and 1 or 2)
		print("Glitch Enabled! Type is")
		print(_type)
	end

	if 
		next(SMODS.find_card("j_rgmc_happy_stick_joker")) 
		and MadLib.list_matches_one(SMODS.find_card("j_rgmc_happy_stick_joker"), function(v)
		return SMODS.pseudorandom_probability(v, 'happy_stick_joker', 1, v.ability.extra.odds)
	end) then
		_type = Madcap.Funcs.get_random_set('happy_stick_joker', Madcap.Lists.RandomPoolBlacklist, 2)
	end

	local card = old_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	-- Mayhemize.
	if G.GAME.mayhem then
		local mayhem_state	= mfuncs.get_mayhem_state()
		if mayhem_state > 0 then
			card = Madcap.Funcs.mayhemize(card)
		end
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

local edit_uibox_ref = MadLib.edit_uibox_contents
function MadLib.edit_uibox_contents(contents, scale)
	local scale_mayhem = scale * (3/4)
	contents = edit_uibox_ref(contents, scale)
	for i=1,2 do
		contents.buttons[1].nodes[i].config.minw = contents.buttons[1].nodes[i].config.minw * 0.75
		contents.buttons[1].nodes[i].config.minh = contents.buttons[1].nodes[i].config.minh * 0.6
	end
	contents.dollars_chips = nil
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
