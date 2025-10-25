-- Subhand data
SubHands = {
    Light = {
        name       = 'ml_sh_light',
        priority   = 2,
        x_mult     = 1.05,
        x_chips    = 1.12,
        l_mult     = 0.05,
        l_chips    = 0.04,
        check_hand = function(hand) -- at least 5 light suits (wilds included)
            local light_cards   = MadLib.loop_func(hand, function(v) return v:has_light_suit() end)
            local dark_cards    = MadLib.loop_func(hand, function(v) return v:has_dark_suit() end)
            return light_cards >= (G.GAME.subhand_minimum or 5) and light_cards > 3 and light_cards > dark_cards
        end,
    },
    Dark = {
        name       = 'ml_sh_dark',
        priority   = 2,
        x_mult     = 1.12,
        x_chips    = 1.05,
        l_mult     = 0.04,
        l_chips    = 0.05,
        check_hand = function(hand) -- at least 5 light suits (wilds included)
            local light_cards   = MadLib.loop_func(hand, function(v) return v:has_light_suit() end)
            local dark_cards    = MadLib.loop_func(hand, function(v) return v:has_dark_suit() end)
            return dark_cards >= (G.GAME.subhand_minimum or 5) and dark_cards > 3 and light_cards < dark_cards
        end,
    },
    Balanced = {
        name       = 'ml_sh_balanced',
        priority   = 3,
        x_mult     = 1.10,
        x_chips    = 1.10,
        l_mult     = 0.05,
        l_chips    = 0.05,
        check_hand = function(hand) -- at least 5 light suits (wilds included)
            local light_cards   = MadLib.loop_func(hand, function(v) return v:has_light_suit() end)
            local dark_cards    = MadLib.loop_func(hand, function(v) return v:has_dark_suit() end)
            return #hand >= (G.GAME.subhand_minimum or 5) and light_cards == dark_cards
        end,
    },
    Dazzling = {
        name       = 'ml_sh_spectrum',
        priority   = 3,
        x_mult     = 1.10,
        x_chips    = 1.10,
        l_mult     = 0.05,
        l_chips    = 0.05,
        check_hand = function(hand) -- at least 5 unique enhancements (+ voucher unlocked)
            return MadLib.get_suit_count(hand) >= (G.GAME.subhand_minimum or 5) -- wip
        end,
    },
    High = {
        name       = 'ml_sh_high',
        priority   = 1,
        x_mult     = 1.10,
        x_chips    = 1.04,
        l_mult     = 0.05,
        l_chips    = 0.04,
        check_hand = function(hand) -- at least 5 ranks 2-6 + Ace (+ voucher unlocked)
            local high_cards   = MadLib.loop_func(hand, function(v) return v:has_high_rank() end)
            local low_cards    = MadLib.loop_func(hand, function(v) return v:has_low_rank() end)
            return #hand >= (G.GAME.subhand_minimum or 5) and high_cards > 3 and high_cards > low_cards
        end,
    },
    Low = {
        name       = 'ml_sh_low',
        priority   = 1,
        x_mult     = 1.04,
        x_chips    = 1.10,
        l_mult     = 0.04,
        l_chips    = 0.05,
        check_hand = function(hand) -- at least 5 ranks 7-K + Ace (+ voucher unlocked)
            local high_cards   = MadLib.loop_func(hand, function(v) return v:has_high_rank() end)
            local low_cards    = MadLib.loop_func(hand, function(v) return v:has_low_rank() end)
            return #hand >= (G.GAME.subhand_minimum or 5) and low_cards > 3 and high_cards < low_cards
        end,
    }
}

-- Levels up a chosen subhand
function Madcap.Funcs.level_up_subhand(card, hand, instant, amount, context)
	amount = amount or 1
	local basic_func = true
    G.GAME.subhands[hand].level = math.max(0, G.GAME.subhands[hand].level + amount)

	-- CRYPTID: Universum also applies to sub-hands?!
    if next(SMODS.find_card('j_cry-Universum')) then
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

-- Gets the local variables for Potentia card.
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



MadLib.clear_hand_text = function(pit,vol)
    tell('Clear Hand Text')
   update_hand_text({ sound = 'button', volume = vol or 0.7, pitch = pit or 1.1, delay = 0 },
            { mult = 0, chips = 0, handname = '', level = '' })
end

-- Sets subhand to TRUE (on) or FALSE (off) - if no state is provided, acts as a toggler.
function Madcap.Funcs.set_subhand(_sh,_state)
	if not (G.GAME.subhands and G.GAME.subhands[_sh]) then return false end
	G.GAME.subhands[_sh].enabled = _state or (not G.GAME.subhands[_sh].enabled)
    print(G.GAME.subhands or "NOTHING")

    return true
end

-- Gets a list of all
function MadLib.get_subhands(_cards)
    local subhand_list = {}
    MadLib.loop_table(SubHands, function(k,v)
        if not (G.GAME.subhands[v.name] and G.GAME.subhands[v.name].enabled) then return false end
        local result = v.check_hand(_cards)
        if not result then return false end
        subhand_list[#subhand_list+1] = v.name
        return true
    end)
    return subhand_list
end

-- Checks if the list has the desired subhand
function MadLib.has_subhand(list, name)
    return MadLib.list_matches_one(list, function(v) return v == name end)
end

-- Checks if the "context" has the desired subhand
function MadLib.context_has_subhand(context,name)
    return context.subhands and MadLib.has_subhand(context.subhands,name) or false
end

-- Gives the main value of the Potentia - relies on poker hand size
function Madcap.Funcs.get_potentia_bonus(hand, cards)
	if not hand then return 0 end
	local card_bonus = math.max(1, #(cards or {}) - (G.GAME.subhand_minimum or 5) + 1)
	return MadLib.round(1 + (G.GAME.subhands[hand].empower or 0) * (card_bonus/6), 2)
end

-- Calculates the total empower bonus (which relies on subhand mult/chips, as well as other things)
function Madcap.Funcs.calculate_empower_bonus(hand, cards)
	if not G.GAME.subhands or G.GAME.subhands[hand] then return 0 end
	local EP = Madcap.Funcs.get_potentia_bonus(hand, cards)
	return G.GAME.subhands[hand].chips * EP, G.GAME.subhands[hand].mult * EP
end

-- Empowers the chosen subhand
function Madcap.Funcs.empower_subhand(card, hand, instant, amount, context)
	amount = amount or 1
	local basic_func = true
	local empower_level = (G.GAME.subhands[hand].empower or 0)

    print(hand)
    print(G.GAME.subhands[hand])

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
			local nu_chips, nu_mult = 0, 0
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

-- Returns whether the subhand is visible (and active?)
function Madcap.Funcs.is_subhand_visible(subhand)
	return subhand and subhand.enabled
end

function create_UIBox_subhand_tip(sh)
	if not G.GAME.subhands[sh].example then return {n=G.UIT.R, config={align = "cm"},nodes = {}} end

	local cardarea = CardArea(2, 2, 3.5 * G.CARD_W, 0.75 * G.CARD_H, { card_limit = 5, type = 'title', highlight_limit = 0 })
	for k, v in ipairs(G.GAME.subhands[sh].example) do
		local card = Card(0,0, 0.5*G.CARD_W, 0.5*G.CARD_H, G.P_CARDS[v[1]], G.P_CENTERS[v.enhancement or 'c_base'])
		if v.edition then card:set_edition(v.edition, true, true) end
		if v.seal then card:set_seal(v.seal, true, true) end
		if v[2] then card:juice_up(0.3, 0.2) end
		if k == 1 then play_sound('paper1',0.95 + math.random()*0.1, 0.3) end
		ease_value(card.T, 'scale',v[2] and 0.25 or -0.15,nil,'REAL',true,0.2)
		--if v['akyrs_letter'] then card:set_letters(v['akyrs_letter']) card.ability.forced_letter_render = true end
		if v.is_null then card.is_null = true end
		cardarea:emplace(card)
	end

	return {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, r = 0.1}, nodes={
		{n=G.UIT.C, config={align = "cm"}, nodes={ {n=G.UIT.O, config={object = cardarea}}}}
	}}
end

-- Add subhand context with scoring hand context.
local eval_card_ref = eval_card
function eval_card(card, context)
    context.look_at_card = card
	if context.scoring_hand then context.subhands = MadLib.get_subhands(context.scoring_hand) end
	local ret, post_trig = eval_card_ref(card, context)
	return ret, post_trig
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
