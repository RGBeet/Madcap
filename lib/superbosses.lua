local select_blind_ref = G.FUNCS.select_blind
G.FUNCS.select_blind = function(e)
    G.GAME.rgmc_ui_should_recalculate = true
    return select_blind_ref(e)
end

Madcap.func_always_true = function() return true end

Madcap.Lists.AssistBosses = {
	['bl_ox'] 		= function()
		return true -- return if $ > 0
	end,
	['bl_hook'] 	= function()
		return true -- return if hand size > 1
	end,
	['bl_mouth'] 	= function()
		return true -- return if hands > 1
	end,
	['bl_fish'] 	= Madcap.func_always_true,
	['bl_club'] 	= function()
		return true -- return if enough clubs
	end,
	['bl_manacle'] 	= function()
		return true -- return if hand size > 2
	end,
	['bl_tooth'] 	= Madcap.func_always_true,
	['bl_wall'] 	= Madcap.func_always_true,
	['bl_house'] 	= Madcap.func_always_true,
	['bl_mark'] 	= function()
		return true -- return if enough face cards
	end,
	['bl_wheel'] 	= Madcap.func_always_true,
	['bl_arm'] 		= function()
		return true -- return if at least one poker hand is above 1
	end,
	['bl_psychic'] 	= function()
		return true -- return if selection size > 4
	end,
	['bl_goad'] 	= function()
		return true -- return if enough spades
	end,
	['bl_water'] 	= function()
		return true -- return if discards > 0
	end,
	['bl_eye'] 		= function()
		return true -- return if hands > 1
	end,
	['bl_plant'] 	= function()
		return true -- return if enough face cards (at least 25%)
	end,
	['bl_needle'] 	= function()
		return true -- return if hands > 1
	end,
	['bl_head'] 	= function()
		return true -- return if enough hearts
	end,
	['bl_window'] 	= function()
		return true -- return if enough diamonds
	end,
	['bl_serpent'] 	= function()
		return true -- return if discards > 0
	end,
	['bl_pillar'] 	= Madcap.func_always_true,
	['bl_flint'] 	= Madcap.func_always_true,
}
function get_new_assist_boss()

	return 0
end

local set_blind_ref = Blind.set_blind
function Blind:set_blind(blind, initial, silent)
    if
		(G.GAME.blind and G.GAME.blind.in_blind and not G.GAME.blind.defeated)
		and G.GAME.blind.debuff.rgmc_cannot_be_overridden
		and not (G.GAME.blind.debuff.rgmc_can_be_replaced_by and G.GAME.blind.debuff.rgmc_can_be_replaced_by[blind.key])
    then
        -- you cannot
    else
		delay(0.5)
		MadLib.simple_event(function()
			Madcap.Funcs.recalculate_blind_ui()
			return true
		end, 0.0, 'after')
        return set_blind_ref(self, blind, initial, silent)
    end
end

local check_blind_key = function(k)
	if k == nil then
		print('Key is NIL!')
		return
	end
	local s = G.P_BLINDS[k]
	--print(tostring(k) .. ' is ' .. (s ~= nil and 'valid' or 'invalid'))
	return s
end

function Madcap.Funcs.get_ante_blind_chips(self)
	local values = G.GAME.current_blind_values or {}

    for key, _ in pairs(G.GAME.round_resets.blind_choices) do
        local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[key]]
        local blind_key = bl.key
        if blind_key ~= self.key then
			values[#values+1] = SMODS.get_blind_amount(G.GAME.round_resets.ante) * (bl.mult or 1)
		end
    end

    return values
end

function Madcap.Funcs.build_up_blind_chips(chip_values)
	print(chip_values)
	local ease_values = {}
	for i=1,#chip_values do
		ease_values[i] = G.GAME.blind.chips
		for j=1,i do ease_values[i] = ease_values[i] + chip_values[j] end
	end

	local i = 0
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		func = function()
			MadLib.loop_func(ease_values, function(v,i)
				MadLib.simple_event(function()
					i = i + 1
					play_sound('timpani', 1 - (i-1)*0.1)
					play_sound('tarot2', 0.76, 0.4)
					G.GAME.blind.chips = v
					G.GAME.blind.chip_text = number_format(v)
					G.HUD_blind:get_UIE_by_ID("HUD_blind_count"):juice_up()
					return true
				end, 1.5, 'after')
			end)
		return true
	end }))
end

function Madcap.Funcs.assist_set_blind(k, self, reset, silent)
	local s = check_blind_key(k)
	if not s then return end
	if s.set_blind then
		s:set_blind(reset or false, silent or false)
	elseif s.name == "The Eye" and not reset then
		MadLib.loop_table(G.GAME.blind.hands, function(k,_)
			G.GAME.blind.hands[k] = false
		end)
	elseif s.name == "The Mouth" and not reset then
		G.GAME.blind.only_hand = false
	elseif s.name == "The Fish" and not reset then
		G.GAME.blind.prepped = nil
	elseif s.name == "The Water" and not reset then
		G.GAME.blind.discards_sub = G.GAME.current_round.discards_left
		ease_discard(-G.GAME.blind.discards_sub)
	elseif s.name == "The Needle" and not reset then
		G.GAME.blind.hands_sub = G.GAME.round_resets.hands - 1
		ease_hands_played(-G.GAME.blind.hands_sub)
	elseif s.name == "The Manacle" and not reset then
		G.hand:change_size(-1)
	elseif s.name == "Amber Acorn" and not reset and #G.jokers.cards > 0 then
		G.jokers:unhighlight_all()
		for k, v in ipairs(G.jokers.cards) do v:flip() end
		if #G.jokers.cards > 1 then
			MadLib.event({
				trigger = "after",
				delay = 0.2,
				func = function()
					local shf = {0.85,1.15,1}
					for i=1,3 do
						MadLib.event({
							func = function()
								G.jokers:shuffle("aajk")
								play_sound("cardSlide1", 0.85 + shf[i])
								return true
							end,
						})
						delay(i < 3 and 0.15 or 0.5)
					end
				end
			})
		end
	end

	local cardareas_to_check = { G.playing_cards, G.jokers }
	-- if thing then?
	MadLib.loop_func(cardareas_to_check, function(list)
		MadLib.loop_func(list, function(v)
			local pass = Madcap.Funcs.assist_debuff_card(k, self, v)
			--print('DEBUFF PASS IS ' .. (pass and 'TRUE' or 'FALSE') )
		end)
	end)

end

function Madcap.Funcs.assist_blind_defeat(k, self)
	local s = check_blind_key(k)
	if not s then return end
	if s.defeat then
		s:defeat(true)
	elseif s.name == "The Manacle" and not self.disabled then
		G.hand:change_size(1)
	end
end

function Madcap.Funcs.assist_blind_disable(k, self)
	local s = check_blind_key(k)
	if s.disable then
		s:disable(silent)
	elseif s.name == "The Water" then
		ease_discard(G.GAME.blind.discards_sub)
	elseif s.name == "The Wheel" or s.name == "The House" or s.name == "The Mark" or s.name == "The Fish" then
		for i = 1, #G.hand.cards do
			if G.hand.cards[i].facing == "back" then G.hand.cards[i]:flip() end
		end
		for k, v in pairs(G.playing_cards) do v.ability.wheel_flipped = nil end
	elseif s.name == "The Needle" then
		ease_hands_played(G.GAME.blind.hands_sub)
	elseif s.name == "The Wall" then
		G.GAME.blind.chips = G.GAME.blind.chips / 2
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	elseif s.name == "Cerulean Bell" then
		for k, v in ipairs(G.playing_cards) do v.ability.forced_selection = nil end
	elseif s.name == "The Manacle" then
		G.hand:change_size(1)
		G.FUNCS.draw_from_deck_to_hand(1)
	elseif s.name == "Violet Vessel" then
		G.GAME.blind.chips = G.GAME.blind.chips / 3
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	end
end

function Madcap.Funcs.assist_blind_press_play(k, self)
	local s = check_blind_key(k)
	if not s then return end
	if s.press_play then
		s:press_play(self)
	elseif s.name == "The Hook" then
		MadLib.event({
			func = function()
				local any_selected = nil
				local _cards = {}
				for k, v in ipairs(G.hand.cards) do _cards[#_cards + 1] = v end
				for i = 1, 2 do
					if G.hand.cards[i] then
						local selected_card, card_key = pseudorandom_element(_cards, pseudoseed("gauntlet"))
						G.hand:add_to_highlighted(selected_card, true)
						table.remove(_cards, card_key)
						any_selected = true
						play_sound("card1", 1)
					end
				end
				if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
				return true
			end
		})
		G.GAME.blind.triggered = true
		delay(0.7)
	elseif s.name == "Crimson Heart" then
		if G.jokers.cards[1] then
			G.GAME.blind.triggered = true
			G.GAME.blind.prepped = true
		end
	elseif s.name == "The Fish" then
		G.GAME.blind.prepped = true
	elseif s.name == "The Tooth" then
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				for i = 1, #G.play.cards do
					G.E_MANAGER:add_event(Event({
						func = function()
							G.play.cards[i]:juice_up()
							return true
						end,
					}))
					ease_dollars(-1)
					delay(0.23)
				end
				return true
			end,
		}))
		G.GAME.blind.triggered = true
	end
end

function Madcap.Funcs.reset_assist_blind(a)
	if not G.HUD_blind:get_UIE_by_ID('rgmc_blinds_container') then return end
	MadLib.simple_event(function()
		local target = G.HUD_blind:get_UIE_by_ID('rgmc_blinds_container').children[2].config
		target.object = rgmc_get_blind_icon(G.P_BLINDS[G.GAME.rgmc_bonus_blind] or G.P_BLINDS.bl_small)
		target.object:juice_up()
		play_sound('timpani',1.2)
		play_sound('tarot2', 0.76, 0.4)
		return true
	end, 1.0, 'after')
	--G.P_BLINDS[G.GAME.rgmc_bonus_blind] or G.P_BLINDS.bl_small
end

function Madcap.Funcs.multiblind_get_locvars(k, self)
	return { localize('rgmc_debuff_multiblind') }
end

function Madcap.Funcs.assist_blind_calculate(k, self, card, context)
	local s = check_blind_key(k)
	if not s then return end
	if s.calculate then
		---print(k .. "!!!")
		return s:calculate(self, card, context)
	end
end

function Madcap.Funcs.assist_blind_modify_hand(k, self, cards, poker_hands, text, mult, hand_chips)
	local s = check_blind_key(k)
	if not s then return end
	local new_mult = mult
	local new_chips = hand_chips
	local trigger = false
	if s.modify_hand then
		local this_trigger = false
		new_mult, new_chips, this_trigger = s:modify_hand(cards, poker_hands, text, new_mult, new_chips)
		trigger = trigger or this_trigger
	elseif s.name == "The Flint" then
		G.GAME.blind.triggered = true
		new_mult = math.max(math.floor(new_mult * 0.5 + 0.5), 1)
		new_chips = math.max(math.floor(new_chips * 0.5 + 0.5), 0)
		trigger = true
	end
	return new_mult or mult, new_chips or hand_chips, trigger
end

function Madcap.Funcs.assist_debuff_card(k, self, card, from_blind)
	local s = check_blind_key(k)
	if not s then return end
	print(k)
	if s.debuff.suit and card:is_suit(s.debuff.suit, true) then
		card:set_debuff(true)
		if card.debuff then card.debuffed_by_blind = true end
		return true
	end
	if s.debuff.is_face ==' face' and card:is_face(true) then
		card:set_debuff(true)
		if card.debuff then card.debuffed_by_blind = true end
		return true
	end
	if s.name == 'The Pillar' and card.ability.played_this_ante then
		card:set_debuff(true)
		if card.debuff then card.debuffed_by_blind = true end
		return true
	end
	if s.debuff.value and s.debuff.value == card.base.value then
		card:set_debuff(true)
		if card.debuff then card.debuffed_by_blind = true end
		return true
	end
	if s.debuff.nominal and s.debuff.nominal == card.base.nominal then
		card:set_debuff(true)
		if card.debuff then card.debuffed_by_blind = true end
		return true
	end
    if s.name == 'Crimson Heart' and not s.disabled and card.area == G.jokers then
        if card.ability.crimson_heart_chosen then
            card:set_debuff(true);
            if card.debuff then card.debuffed_by_blind = true end
		return true
        end
    elseif s.name == 'Verdant Leaf' and not s.disabled and card.area ~= G.jokers then
		card:set_debuff(true)
		if card.debuff then card.debuffed_by_blind = true end
		return true
	end
    card:set_debuff(false)
	return false
end

function Madcap.Funcs.get_assist_debuff_text(blk, self, loc)
	local s = check_blind_key(blk)
	if not s then return "???" end
	if not G.GAME.blind.debuff_boss then
		return localize("rgmc_debuff_"..(loc or 'gauntlet'))
	end
	local loc_vars = nil
	if G.GAME.blind.debuff_boss.name == "The Ox" then
		loc_vars = { localize(G.GAME.current_round.most_played_poker_hand, "poker_hands") }
	end
	local loc_target = localize({ type = "raw_descriptions", key = G.GAME.blind.debuff_boss.key, set = "Blind", vars = loc_vars })
	local loc_debuff_text = ""
	for k, v in ipairs(loc_target) do
		loc_debuff_text = loc_debuff_text .. v .. (k <= #loc_target and " " or "")
	end
	local disp_text = (G.GAME.blind.debuff_boss.name == "The Wheel" and G.GAME.probabilities.normal or "") .. loc_debuff_text
	if (G.GAME.blind.debuff_boss.name == "The Mouth") and G.GAME.blind.only_hand then
		disp_text = disp_text .. " [" .. localize(G.GAME.blind.only_hand, "poker_hands") .. "]"
	end
	return disp_text
end

function Madcap.Funcs.assist_blind_debuff_hand(k, self, cards, hand, handname, check)
	local s = check_blind_key(k)
	if not s then return end
	if s.debuff_hand and s:debuff_hand(cards, hand, handname, check) then
		G.GAME.blind.debuff_boss = s
		return true
	elseif s.debuff then
		G.GAME.blind.triggered = false
		if s.debuff.hand and next(hand[s.debuff.hand]) then
			G.GAME.blind.triggered = true
			G.GAME.blind.debuff_boss = s
			return true
		elseif s.debuff.h_size_ge and #cards < s.debuff.h_size_ge then
			G.GAME.blind.triggered = true
			G.GAME.blind.debuff_boss = s
			return true
		elseif s.debuff.h_size_le and #cards > s.debuff.h_size_le then
			G.GAME.blind.triggered = true
			G.GAME.blind.debuff_boss = s
			return true
		elseif s.name == "The Eye" then
			G.GAME.blind.hands = G.GAME.blind.hands or {}
			if G.GAME.blind.hands[handname] then
				G.GAME.blind.triggered = true
				G.GAME.blind.debuff_boss = s
				return true
			elseif not check then
				G.GAME.blind.hands[handname] = true
			end
		elseif s.name == "The Mouth" then
			if s.only_hand and s.only_hand ~= handname then
				G.GAME.blind.triggered = true
				G.GAME.blind.debuff_boss = s
				return true
			elseif not check then
				s.only_hand = handname
			end
		elseif s.name == "The Arm" then
			G.GAME.blind.triggered = false
			if to_big(G.GAME.hands[handname].level) > to_big(1) then
				G.GAME.blind.triggered = true
				if not check then
					level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -1)
					G.GAME.blind:wiggle()
				end
			end
		elseif s.name == "The Ox" then
			G.GAME.blind.triggered = false
			if handname == G.GAME.current_round.most_played_poker_hand then
				G.GAME.blind.triggered = true
				if not check then
					ease_dollars(-G.GAME.dollars, true)
					G.GAME.blind:wiggle()
				end
			end
		end
		return false
	end
end

function Madcap.Funcs.assist_drawn_to_hand(k, self)
	local s = check_blind_key(k)
	if not s then return end
	if s.drawn_to_hand then
		s:drawn_to_hand()
	elseif s.name == "Cerulean Bell" then
		local any_forced = nil
		for k, v in ipairs(G.hand.cards) do
			if v.ability.forced_selection then any_forced = true end
		end
		if not any_forced then
			G.hand:unhighlight_all()
			local forced_card = pseudorandom_element(G.hand.cards, pseudoseed("rgmc_final_gauntlet"))
			forced_card.ability.forced_selection = true
			G.hand:add_to_highlighted(forced_card)
		end
	elseif s.name == "Crimson Heart" and G.GAME.blind.prepped and G.jokers.cards[1] then
		local jokers = {}
		for i = 1, #G.jokers.cards do
			if not G.jokers.cards[i].debuff or #G.jokers.cards < 2 then jokers[#jokers + 1] = G.jokers.cards[i] end
			G.jokers.cards[i]:set_debuff(false)
		end
		local _card = pseudorandom_element(jokers, pseudoseed("rgmc_final_gauntlet"))
		if _card then
			_card:set_debuff(true)
			_card:juice_up()
			G.GAME.blind:wiggle()
		end
	end
end

function Madcap.Funcs.assist_stay_flipped(k, self, area, card)
	local s = check_blind_key(k)
	if not s then return end
	if s.stay_flipped and s:stay_flipped(area, card) then
		return true
	elseif area == G.hand then
		if
			s.name == "The Wheel"
			and SMODS.pseudorandom_probability(self, "rgmc_final_gauntlet", 1, 7, "Golden Gauntlet")
		then
			return true
		elseif
			s.name == "The House"
			and G.GAME.current_round.hands_played == 0
			and G.GAME.current_round.discards_used == 0
		then
			return true
		elseif s.name == "The Mark" and card:is_face(true) then
			return true
		elseif s.name == "The Fish" and G.GAME.blind.prepped then
			return true
		end
	end
end

function Madcap.Funcs.get_multistage_boss_win()
    if not G.GAME.multi_stage_boss then return nil end
    local thing = false

    if G.GAME.golden_gauntlet ~= nil and type(G.GAME.golden_gauntlet) == 'table' then
        thing = (G.GAME.golden_gauntlet.current + 1) >= G.GAME.golden_gauntlet.max
        print("Golden Gauntlet is finished? " .. tostring(thing))
    end

    return thing
end

function Madcap.Funcs.multistage_boss_round_end(add)
    if not G.GAME.multi_stage_boss then return false end

    local reset = false
    local function _reset(anim)
		G.GAME.chips = 0
		G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
		G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
		G.GAME.current_round.hands_played = 0
		G.GAME.current_round.discards_used = 0
		for k, v in pairs(G.GAME.hands) do
			v.played_this_round = 0
		end

		G.GAME.blind:set_text()

        MadLib.simple_event(function()
			G.STATE = G.STATES.DRAW_TO_HAND
			G.deck:shuffle('nr'..G.GAME.round_resets.ante)
			G.deck:hard_set_T()
			G.STATE_COMPLETE = false
            return true
        end, 0, 'immediate')
        if anim then
            MadLib.simple_event(function()
                --if G.GAME.rgmc_bonus_blind then G.GAME.rgmc_bonus_blind:set_text() end
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                SMODS.juice_up_blind()
                play_sound('timpani')
                return true
            end, 0, 'after')
        end
	end

    if G.GAME.golden_gauntlet ~= nil and type(G.GAME.golden_gauntlet) == 'table' then
        G.GAME.golden_gauntlet.current = G.GAME.golden_gauntlet.current + 1
        print("Golden Gauntlet " .. tostring(G.GAME.golden_gauntlet.current) .. " / " .. tostring(G.GAME.golden_gauntlet.max))

        if G.GAME.golden_gauntlet.current < G.GAME.golden_gauntlet.max then
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.25)
            _reset(true)
        end

		G.GAME.rgmc_ui_should_recalculate = true
		G.GAME.rgmc_bonus_blind = get_new_assist_boss()
		Madcap.Funcs.reset_assist_blind()

		MadLib.simple_event(function()
			Madcap.Funcs.assist_set_blind(G.GAME.rgmc_bonus_blind, G.GAME.blind, true, false)
			Madcap.Funcs.recalculate_blind_ui()
			return true
		end, 0, 'after')

        return true
    end
end

Madcap.Lists.MultiblindBlinds = {
	'rgmc_final_gauntlet',
	'rgmc_final_id'
}

function Madcap.Funcs.golden_gauntlet_reset()
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			for i, v in ipairs({'blind', 'rgmc_bonus_blind'}) do
				if MadLib.list_matches_one(Madcap.Lists.MultiblindBlinds, function(v2) return v2 == G.GAME[v].name end) then SMODS.juice_up_blind(v) end
			end
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
				play_sound('tarot2', 0.76, 0.4); _reset();return true end}))
			play_sound('tarot2', 1, 0.4)
			G.GAME.rgmc_bonus_blind = get_new_boss()
			Madcap.Funcs.reset_assist_blind()
			return true
		end
	}))
	delay(0.8)

    --[[
	-- literally just copypasted an entire set_blind chunk (i can't run the rest of it)
	for i, v in ipairs({'blind', 'rgmc_bonus_blind'}) do
		local self = G.GAME[v]
		local obj = self.config.blind
		self.disabled = false
		if self.name == 'The Eye' and not reset then
			obj = G.P_BLINDS['bl_small']	-- nuke obj to avoid smods ownership
			self.hands = {}
			for _, v in ipairs(G.handlist) do
				self.hands[v] = false
			end
		end

        if not self.name == 'rgmc_final_gauntlet' and obj.set_blind and type(obj.set_blind) == 'function' then
			obj:set_blind()
		elseif self.name == 'The Mouth' and not reset then
			self.only_hand = false
		elseif self.name == 'The Fish' and not reset then
			self.prepped = nil
		elseif self.name == 'The Water' and not reset then
			self.discards_sub = G.GAME.current_round.discards_left
			ease_discard(-self.discards_sub)
		elseif self.name == 'The Needle' and not reset then
			self.hands_sub = G.GAME.round_resets.hands - 1
			ease_hands_played(-self.hands_sub)
		elseif self.name == 'The Manacle' and not reset then
			G.hand:change_size(-1)
		elseif self.name == 'Amber Acorn' and not reset and #G.jokers.cards > 0 then
			G.jokers:unhighlight_all()
			for k, v in ipairs(G.jokers.cards) do
				if v.facing == 'front' then
					v:flip()
				end
			end
			if #G.jokers.cards > 1 then
				G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
					G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end }))
					delay(0.15)
					G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end }))
					delay(0.15)
					G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end }))
					delay(0.5)
				return true end }))
			end
		end
	end
	for _, v in ipairs(G.playing_cards) do G.GAME.blind:debuff_card(v) end
	for _, v in ipairs(G.jokers.cards) do if not reset then G.GAME.blind:debuff_card(v, true) end; end]]

	G.GAME.blind:alert_debuff(true)
	if G.GAME.rgmc_bonus_blind then
		G.GAME.rgmc_bonus_blind:alert_debuff(true)
	end

	-- TARGET: setting_blind effects
	delay(0.4)
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			G.STATE = G.STATES.DRAW_TO_HAND
			G.deck:shuffle('nr'..G.GAME.round_resets.ante)
			G.deck:hard_set_T()
			G.STATE_COMPLETE = false
			return true
		end
	}))
end
