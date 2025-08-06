--[[

    Poker sub-hands add variety and versatility to poker hands
    without creating clutter.

    Rather than making light and dark spectrum variants of each
    Spectrum poker hands.

    Multiple subhands can apply to one hand (e.g. High Dark Straight)

]]

function Card:has_high_rank()
    return SMODS.has_no_rank(self) and SMODS.Ranks[self:get_id()].nominal > 6
end

function Card:has_low_rank()
    return SMODS.has_no_rank(self) and SMODS.Ranks[self:get_id()].nominal <= 6
end

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
            return #hand >= (G.GAME.subhand_minimum or 5) and light_cards > dark_cards
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
            return #hand >= (G.GAME.subhand_minimum or 5) and light_cards < dark_cards
        end,
    },
    Balanced = {
        name       = 'ml_sh_balanced',
        priority   = 2,
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
        name       = 'ml_sh_enhanced',
        priority   = 3,
        x_mult     = 1.10,
        x_chips    = 1.10,
        l_mult     = 0.05,
        l_chips    = 0.05,
        check_hand = function(hand) -- at least 5 unique enhancements (+ voucher unlocked)
            local enha = {}
            local unique = MadLib.loop_func(hand, function(v)
                if not enha[v.config.center.key] then 
                    enha[v.config.center.key] = true
                    return true
                end
                return false
            end)
            --tell(tostring(unique) .. ' unique entries.')
            return unique >= (G.GAME.subhand_minimum or 5) -- wip
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
            return #hand >= (G.GAME.subhand_minimum or 5) and high_cards < low_cards
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
            return #hand >= (G.GAME.subhand_minimum or 5) and high_cards > low_cards
        end,
    }
}

MadLib.clear_hand_text = function(pit,vol)
    tell('Clear Hand Text')
   update_hand_text({ sound = 'button', volume = vol or 0.7, pitch = pit or 1.1, delay = 0 },
            { mult = 0, chips = 0, handname = '', level = '' })
end

-- Sets subhand to TRUE (on) or FALSE (off) - if no state is provided, acts as a toggler.
function Madcap.Funcs.set_subhand(_sh,_state)
	if not G.GAME.subhands[_sh] then return false end
	G.GAME.subhands[_sh].enabled = _state or (not G.GAME.subhands[_sh].enabled)
	return true
end

function Madcap.Funcs.set_subhand_voucher_level(_sh,_lvl)
	if not G.GAME.subhands[_sh] then return false end
	G.GAME.subhands[_sh].voucher = _lvl or 0
	return true
end

function Madcap.Funcs.empower_subhand(_sh,_lvl)
	if not G.GAME.subhands[_sh] then return false end
	G.GAME.subhands[_sh].empower = _lvl or 0
	return true
end

-- Levels up the subhand
MadLib.level_up_subhand = function(card, subhand, instant, amount)
    tell('Level Up Subhand')
    -- if no amount, assume it's just 1 level up
    amount = to_big(amount or 1) -- to_big to avoid crash

	if not instant then
        -- update the UI before setting the new values
		update_hand_text({
            sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3
        }, {
            handname = localize(subhand.prefix),
            level    = G.GAME.subhands[subhand].level,
            chips    = G.GAME.subhands[subhand].chips,
            mult     = G.GAME.subhands[subhand].mult
        })
	end

	-- set the values
    local lchips    = G.GAME.subhands[subhand].level * G.GAME.subhands[subhand].level_chips
    local lmult     = G.GAME.subhands[subhand].level * G.GAME.subhands[subhand].level_mult
    G.GAME.subhands[subhand].level    = math.max(G.GAME.subhands[subhand].level + amount, 0)
    G.GAME.subhands[subhand].chips    = math.max(G.GAME.subhands[subhand].chips + lchips, 0)
    G.GAME.subhands[subhand].mult     = math.max(G.GAME.subhands[subhand].chips + lmult, 0)

    -- Animation type stuff
    if (G.SETTINGS.FASTFORWARD or 0) > 0 then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = true
				return true
            end
        }))
        update_hand_text({ sound = 'button',  volume = 0.7,  pitch = 0.9,  delay = 0 }, {
            level   = G.GAME.subhands[subhand].level,
            chips   = G.GAME.subhands[subhand].chips,
            mult    = G.GAME.subhands[subhand].mult,
            StatusText = true
        })
    else
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.2,
            func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = true
				return true
            end
        }))
        update_hand_text({ delay = 0 }, { mult = G.GAME.subhands[subhand].mult, StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.9,
            func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true
            end
        }))
        update_hand_text({ delay = 0 }, { chips   = G.GAME.subhands[subhand].chips, StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.9,
            func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = nil
				return true
            end
        }))
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, { level = G.GAME.subhands[subhand].level })
		MadLib.clear_hand_text()
    end
end

function MadLib.get_subhands(_cards)
    --print("Cards equals:")
    --print(#_cards)
    local subhand_list = {}
    for k,v in pairs(SubHands) do
        local result = v.check_hand(_cards)
        if result then
        subhand_list[#subhand_list+1] = v.name
        end
	end
    --print("Subhand lists:")
    --print(subhand_list)
    return subhand_list
end

function MadLib.context_has_subhand(context,name)
    return context.subhands and MadLib.has_subhand(context.subhands,name) or false
end

function MadLib.has_subhand(list,name)
    for i, v in ipairs(list) do
        if v == name then
            return true
        end
    end
    return false
end

-- Assumes subhands is a list of PASSED subhand types.

function MadLib.calculate_chips(_chips,sh)
    --tell("Calculate Chips")
    local final_chips = _chips
    if sh then
        for i=1, #sh do
            local _xchips = G.GAME.subhands[sh[i]].chips
            final_chips = final_chips * _xchips
            tell("Chips x" .. tostring(_xchips))
        end
    end
    --if not sh then tell("I don't see any subhands...") end
    if Cryptid then final_chips = Cryptid.ascend(final_chips) end
    --tell('Final chips is ' .. tostring(final_chips))
    return final_chips
end

function MadLib.calculate_mult(_mult,sh)
    --tell("Calculate Mult")
    local final_mult = _mult
    if sh then
        for i=1, #sh do
            local _xmult = G.GAME.subhands[sh[i]].mult
            final_mult = final_mult * _xmult
            tell("Mult x" .. tostring(_xmult))
        end
    end
    --if not sh then tell("I don't see any subhands...") end
    if Cryptid then final_mult = Cryptid.ascend(final_mult) end
    --tell('Final mult is ' .. tostring(final_mult))
    return final_mult
end

local poker_hand_info_ref = G.FUNCS.get_poker_hand_info
function G.FUNCS.get_poker_hand_info(_cards)
	local text, loc_disp_text, poker_hands, scoring_hand, disp_text = poker_hand_info_ref(_cards)

	local active = MadLib.get_subhands(scoring_hand)
    --print(number_format(#active) .. ' subhands.')
	if #active > 0 then
        local changed = G.GAME.total_selected and G.GAME.total_selected ~= #scoring_hand
        local scoring = hand_chips ~= nil
        local prefix = ''

        for i=1, #active do
            prefix = prefix .. ' '.. localize(active[i])
        end
        loc_disp_text = prefix .. ' ' .. loc_disp_text
        G.GAME.total_selected = #scoring_hand
    end

    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end

--[[
local evaluate_play_ref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(self, e)
    evaluate_play_ref(self, e)
end
]]
