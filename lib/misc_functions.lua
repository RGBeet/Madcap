-- Used strictly by SMODS.calculate_main_scoring
function Madcap.Funcs.alter_score_order(card,scoring_hand,context,in_scoring)
	if not scoring_hand then return end

	-- Stereo
	local quantity = card:get_quantity_value()
	if quantity >= 2 then -- always score twice
		for i = 1, quantity-1 do
			SMODS.score_card(card, context)
		end
	end

    -- CONTINUUM: Scored 8s repeat all cards before it
    if
        #scoring_hand > 1               -- more than 1 card
        and card:get_id() == 8          -- scoring card is an 8
        and #SMODS.find_card('j_rgmc_continuum') > 0
    then -- 1 or more continuums

        local repeats = #SMODS.find_card('j_rgmc_continuum')
        local index, selection = 1, nil

        -- Score cards again until the original card is reached

        SMODS.score_card(card, context)

        for i=1, repeats do
            index = 1 -- go to start
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
    return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER
end

function Madcap.Funcs.is_choosing_card_special()
    return Madcap.Funcs.is_choosing_card()
	and (SMODS.OPENED_BOOSTER.config.center.kind == "CosmaTarot"
		or SMODS.OPENED_BOOSTER.config.center.kind == "SpatiaPlanet")
end

-- Is choosing a Celestial / Spectral pack. (Used for music!)
function Madcap.Funcs.is_choosing_celestial()
    return G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED and SMODS.OPENED_BOOSTER
end

function Madcap.Funcs.get_boss_status()
	if G.GAME.golden_gauntlet then
		return 2
	elseif not (G.GAME and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.defeated) then
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

function Madcap.Funcs.get_end_of_round(context)
    return context and context.end_of_round
        and not context.blueprint
        and not context.individual
        and not context.repetition
        and not context.retrigger_joker
end

-- General function for setting temporary stickers (which Madcap incorporates a lot of!)
function Card:set_temp_sticker(id,bool,tally)
    self.ability[id]                = bool
    self.ability[id .. '_tally']    = tally or 1
	SMODS.Stickers[id]:apply(self,bool)
end

-- Enables/disables special suits (cups/shields)
function Madcap.Funcs.set_special_suits(x)
    if G.GAME then G.GAME.Exotic = (x or false) end
    tell('Triggered Exotic System enabling.')
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

-- Decks: Initializes base values.
function Madcap.Funcs.init_deck(id,params)
    G.GAME.modifiers.rgmc_deck = {}
    G.GAME.modifiers.rgmc_deck[id] = true

    if params then
        for k,v in pairs(G.GAME.modifiers.rgmc_deck) do G.GAME.modifiers.rgmc_deck[k] = v end
    end
end

function Madcap.Funcs.add_anti_tag(t)
	add_tag(Tag('tag_rgmc_anti_'..t))
	return G.GAME.tags[#G.GAME.tags]
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

-- Adds Cherry Seals to hand
function Madcap.Funcs.modify_scoring_hand(scoring_hand)
	if next(SMODS.find_card('j_rgmc_cont2nuum')) then -- Has Cont2nuum - add all cards in hand to scoring cards
		MadLib.loop_func(G.hand.cards, function(v)
			table.insert(scoring_hand, v)
		end)
	end
	return scoring_hand
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

-- Returns the chips and mult for the planet hand (or hands)
function Madcap.Funcs.get_goldenhouse_chipmult(target)
    if not target then return 0, 0 end
    local chips, mult, changed = 0,0,false

    ----print(target)

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

local edit_card_destination_ref = MadLib.edit_card_destination
function MadLib.edit_card_destination(card,from,to)
	if not card then return to end
	if card.rgmc_coil and to == G.discard then
		card.rgmc_coil = nil
		return G.hand
	end
	return edit_card_destination_ref(card,from,to)
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

-- returns numerators and denominator, numerator cannot be greater than denominator
function Madcap.Funcs.fix_probabilities(numer, denom)
	return math.min(numer, denom), math.max(0.01,denom)
end



function Madcap.Funcs.get_card_key(card, _id)
    return SMODS.Ranks[card.base.value].key == _id
end

function Madcap.Funcs.card_in_list(_card,_list)
    return MadLib.list_matches_one(_list, function(v)
        return v == _card
    end)
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
				MadLib.compare_numbers(G.ARGS.score_intensity.earned_score, G.ARGS.score_intensity.required_score) > 0
				and MadLib.is_positive_number(G.ARGS.score_intensity.required_score) then
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
-- From Cryptid
Madcap.Funcs.safe_get = MadLib.safe_get

function Madcap.Funcs.get_default_attention_hold(text)
    return G.SETTINGS.GAMESPEED * (#text * 0.02 + 1.3)
end

function Madcap.Funcs.get_starting_deck_size()
	return 52
end

function Madcap.Funcs.pulse_flame(duration, intensity) -- duration is in seconds
	G.rgmc_flame_override 				= G.rgmc_flame_override or {}
	G.rgmc_flame_override["duration"] 	= duration or 0.01
	G.rgmc_flame_override["intensity"] 	= intensity or 2
end

function Madcap.Funcs.get_planet_vars(id)
    return {
        vars = {
            localize(id),
            G.GAME.hands[id].level,
            G.GAME.hands[id].l_mult,
            G.GAME.hands[id].l_chips,
			colours = { MadLib.get_level_color(G.GAME.hands[id].level) },
        },
    }
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

function Madcap.Funcs.booster_ease_bg(obj,color1,color2,cont)
	ease_background_colour_blind({ new_colour = color1, special_colour = color2, contrast = (cont or 2) })
end

function Madcap.Funcs.get_food_descale(value)
	return value
end

-- Has at least 1 card selected
function Madcap.Funcs.consumable_highlight_check(self,card)
	if not (G.hand and card) then return false end
	return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
end

local calculate_chips_ref = MadLib.calculate_chips
function MadLib.calculate_chips(value, args)
	local old_value = calculate_chips_ref(value, args)
	
	return old_value
end

local calculate_mult_ref = MadLib.calculate_mult
function MadLib.calculate_mult(value, args)
	local old_value = calculate_mult_ref(value, args)
	
	return old_value
end

Madcap.Lists.SpamJokers = {
	'j_rgmc_spam',
	'j_rgmc_spam_and_sauasge',
	'j_rgmc_empty_can',
	'j_rgpd_green_eggs_and_spam',
	'j_rgmc_lobster_thermidor',
}

function Card:is_spam_joker()
	return MadLib.list_matches_one(Madcap.Lists.SpamJokers, function(v)
		return self.config.center.key == v
	end)
end

function Madcap.Funcs.get_weighted_choice(choices)
    if not choices then return nil end
    -- Step 1: total weight
    local total_weight = 0
    for _, entry in ipairs(choices) do
        total_weight = total_weight + entry.weight
    end
    -- Step 2: random roll
    local roll = math.random(total_weight)
    -- Step 3: find which entry it lands on
    local cumulative = 0
    for _, entry in ipairs(choices) do
        cumulative = cumulative + entry.weight
        if roll <= cumulative then
            return entry.value
        end
    end
end

function Madcap.Funcs.get_cash_out_definition(config,scale)
	local all_nodes = {}

	local payouts = { { n=G.UIT.T, config={text = localize('b_cash_out') .. ':', scale = 1.2 * scale, colour = G.C.WHITE, shadow = true, juice = true } } }
	if config.dollars ~= 0 then
		payouts[#payouts + 1] = { n=G.UIT.T, config={text = localize('$') .. format_ui_value(config.dollars), scale = 1.2 * scale, colour = G.C.WHITE, shadow = true, juice = true }}
	end
	if config.rgmc_lp ~= 0 then
		if next(payouts) then separator = ", " end
		payouts[#payouts + 1] = { n=G.UIT.T, config={text = separator .. localize('£') .. format_ui_value(config.rgmc_lp), scale = 1.2*scale, colour = G.C.WHITE, shadow = true, juice = true }}
	end
	if not next(payouts) then
		payouts[#payouts + 1] = {n=G.UIT.T, config={text = "!", scale = 1.2 * scale, colour = G.C.WHITE, shadow = true, juice = true}}
	end

	return {n=G.UIT.ROOT, config={align = 'cm', colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={id = 'cash_out_button', align = "cm", padding = 0.1, minw = 7, r = 0.15, colour = G.C.ORANGE, shadow = true, hover = true, one_press = true, button = 'cash_out', focus_args = {snap_to = true}}, nodes=payouts}}}
end

function MadLib.get_sequence(n, base, add, e, bonus)
    local value, perma = base, 0
    for k = 1, n-1 do
        value = value + add + perma
        if k % e == 0 then perma = perma + (bonus or 1) end
    end
    return value
end

function Madcap.Funcs.subhands_in_effect()
	return MadLib.list_matches_one(G.GAME.subhands, function(v)
		return v.enabled
	end)
end

Madcap.Funcs.get_shop_level_cap = function(v)
	return MadLib.get_sequence(G.GAME.round_resets.ante, 4, 5, 2, 4)

end

function Madcap.Funcs.get_shop_shortage_activate(add)
	local cur_ante 		= G.GAME.round_resets.ante
	local ante_value	= MadLib.clamp(cur_ante + 1, 1, 10)
	local psr			= MadLib.get_sequence(G.GAME.round_resets.ante, 4, 2, 3)
	local ante_ratio 	= (G.GAME.ante.purchases + add) / psr
	local game_ratio	= (G.GAME.cards_bought + add) / psr
	local total_ratio 	= ante_ratio / game_ratio
	
	if total_ratio > 2 then return true end
end

function Madcap.Funcs.add_shortage_level(slvl)
	G.GAME.shortage_level = G.GAME.shortage_level + slvl
	tell('Shortage level is currently ' .. number_format(G.GAME.shortage_level) .. '.')
end

function Madcap.Funcs.get_shop_level_up_activate(add)
	return add == Madcap.Funcs.get_shop_level_cap()
end

function Madcap.Funcs.add_shop_level(slvl)
	G.GAME.shop_level = G.GAME.shop_level + slvl
	tell('Shop level is currently ' .. number_format(G.GAME.shop_level) .. '.')
end

function Madcap.Funcs.calculate_purchase(c)
	local quantity = c:get_quantity_value()
	tell('+' .. number_format(quantity) .. ' Purchase.')

	-- add the data
	G.GAME.cards_bought = (G.GAME.cards_bought or 0) + quantity
	G.GAME.ante.purchases = (G.GAME.ante.purchases or 0) + quantity

	if G.GAME.modifiers.rgmc_enable_shop_inflation then
		G.GAME.inflation = G.GAME.inflation + quantity
		tell('Inflation level is currently ' .. number_format(G.GAME.inflation) .. '.')
	end

	if G.GAME.modifiers.rgmc_enable_harder_shops and Madcap.Funcs.get_shop_level_up_activate(G.GAME.shop_level) then
		Madcap.Funcs.add_shop_level(0.5)
	end

	if G.GAME.modifiers.rgmc_enable_shop_shortages and Madcap.Funcs.get_shop_shortage_activate(quantity) then
		--G.GAME.shortage_level
		Madcap.Funcs.add_shortage_level(0.5)
	end
end

function Madcap.Funcs.get_num_stickers(card)
	local n = 0
	for k, _ in pairs(SMODS.Stickers) do
        if card.ability[k] == true then n = n + 1 end
    end
	return n
end

function Madcap.Funcs.get_stickers(card)
	local n = {}
	for k, _ in pairs(SMODS.Stickers) do
        if card.ability[k] == true then n[k] = true end
    end
	return n
end

--- EXPLODE
function Madcap.Funcs.get_aoe_cards(center,cards,range)
    local left, right  = math.max(index - range, 1), math.min(index + range, #cards)
    local list, index = {}, MadLib.get_item_index(center, cards)
    if index == -1 then return {} end
    for i=left, right do
        if i ~= index then table.insert(list, cards[i]) end
    end
    return list
end

function Madcap.Funcs.explodes(card)
    local enhancements = SMODS.get_enhancements(card)
    for key, _ in pairs(enhancements) do
        if G.P_CENTERS[key].explodes or key == 'm_rgmc_dynamite' then return true end
    end
end

function Madcap.Funcs.get_spatia_vars(subhand_list)
	local all_vars     = { }
	local all_colours  = { }

	MadLib.loop_func(subhand_list, function(sh)
	    local subhand 	= G.GAME.subhands and G.GAME.subhands[sh]
		table.insert(all_vars, subhand and subhand and subhand.level or 1)
		table.insert(all_vars, localize(sh))
		table.insert(all_vars, (subhand and subhand.l_mult
			or SubHands[sh].l_mult) + 1)
		table.insert(all_vars, (subhand and subhand.l_chips
			or SubHands[sh].l_chips) + 1)
		table.insert(all_colours, MadLib.get_level_color(subhand.level))
	end)
	all_vars['colours'] = all_colours
	return { vars = all_vars }
end

function Madcap.Funcs.get_moon_card_vars(sh)
	local subhand 	= G.GAME.subhands and G.GAME.subhands[sh]
	local current_level = subhand and subhand.level or 1
    return {
        vars = {
            current_level,
            localize(sh),
            (subhand and subhand.l_mult
				or SubHands[sh].l_mult) + 1,
            (subhand and subhand.l_chips
				or SubHands[sh].l_chips) + 1,
			colours = { MadLib.get_level_color(subhand.level), }
        }
    }
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

function Madcap.Funcs.card_level_subhand(card, sh, levels)
    if not G.GAME.subhands[sh] then return end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 2.0}, {
		handname	= localize(sh),
		chips 		= G.GAME.subhands[sh].chips,
		mult 		= G.GAME.subhands[sh].mult,
		level 		= G.GAME.subhands[sh].level,
		multiply	= true
	})
    Madcap.Funcs.level_up_subhand(card, sh, false, levels or 1)
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

function Madcap.Funcs.card_empower_subhand(card, sh, levels)
    if not G.GAME.subhands[sh] then return end
    local pt_bonus 	= Madcap.Funcs.calculate_potentia_bonus(G.GAME.subhands[sh].empower, 5)
    local nu_chips 	= MadLib.multiply(G.GAME.subhands[sh].chips, pt_bonus)
    local nu_mult 	= MadLib.multiply(G.GAME.subhands[sh].mult, pt_bonus)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 2.0}, {
		handname	= localize(sh),
		chips 		= nu_chips,
		mult 		= nu_mult,
		level 		= G.GAME.subhands[sh].empower,
		multiply	= true
	})
    Madcap.Funcs.empower_subhand(card, sh, false, levels or 1)
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

function Madcap.Funcs.use_moon_card(card)
    if not card.ability.subhand then return end
	Madcap.Funcs.card_level_subhand(card, card.ability.subhand, card.ability.levels or 1)
end

function Madcap.Funcs.use_potentia_card(card)
    if not card.ability.subhand then return end
	if #SMODS.find_card('j_rgmc_empowerer') > 0 then
		MadLib.loop_func(SMODS.find_card('j_rgmc_empowerer'), function(v)
			level_up_hand_ref(card, MadLib.get_random_poker_hand(), false, G.GAME.potentias_used)
		end)
	end
	Madcap.Funcs.card_empower_subhand(card, card.ability.subhand, card.ability.levels or 1)
end

function Madcap.Funcs.use_spatia_card(card)
	MadLib.loop_func(card.ability.subhands, function(v) Madcap.Funcs.card_level_subhand(card, v, card.ability.level_factor or 1) end)
    local hand = pseudorandom_element(Madcap.Lists.SpatiaWhitelist, pseudoseed('spatia' .. tostring(G.GAME.round_resets.ante)))
    Madcap.Funcs.card_level_hand(card, hand)
end

function Madcap.Funcs.get_potentia_vars(sh,lvl)
	local subhand = G.GAME.subhands and G.GAME.subhands[sh]
	local current_level = subhand and subhand.level 	or 1
	local empower_level = subhand and subhand.empower 	or 0
    return {
        vars = {
            current_level,
            (empower_level > 0) and (" + " .. empower_level .."") or "",
            localize(sh),
            lvl,
			colours = { MadLib.get_level_color(lvl) }
        },
    }
end

function Madcap.Funcs.check_eval_card(card,i)
	--G.GAME.blind_stats = G.GAME.blind_stats or {}
	if not SMODS.has_no_suit(card) then -- has a suit
		table.insert(G.GAME.blind_stats.suits, card.base.suit)
	end
	if not SMODS.has_no_rank(card) then -- has a rank
		table.insert(G.GAME.blind_stats.ranks, card.base.value)
	end
end


if Overloaded then
	Madcap.Funcs.get_joker_rank = Overloaded.Funcs.get_joker_rank
	Madcap.Funcs.get_joker_ranks = Overloaded.Funcs.get_joker_ranks
	Madcap.Funcs.get_joker_suit = Overloaded.Funcs.get_joker_suit
	Madcap.Funcs.get_joker_suits = Overloaded.Funcs.get_joker_suits
	Madcap.Funcs.get_joker_hand =  Overloaded.Funcs.get_joker_hand
	Madcap.Funcs.get_joker_hands =  Overloaded.Funcs.get_joker_hands
else
	local get_vals = function(card,default,x1) return (type(card.ability.extra) == 'table' and card.ability.extra[x1]) or card.ability[x1] or default end
	function Madcap.Funcs.get_joker_rank(card, default) return get_vals(card, default, 'rank', 'override_rank') end
	function Madcap.Funcs.get_joker_ranks(card, default) return get_vals(card, default, 'ranks', 'override_ranks') end
	function Madcap.Funcs.get_joker_suit(card, default) return get_vals(card, default, 'suit', 'override_suit') end
	function Madcap.Funcs.get_joker_suits(card, default) return get_vals(card, default, 'suits', 'override_suits') end
	function Madcap.Funcs.get_joker_hand(card, default) return get_vals(card, default, 'suit', 'override_hand') end
	function Madcap.Funcs.get_joker_hands(card, default) return get_vals(card, default, 'suits', 'override_hands') end
end