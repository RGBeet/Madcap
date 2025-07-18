--DEPRECATED
function Madcap.Funcs.display_full_hand_text(hand,text,disp_text)

    if #hand < 1 then
        return false
    end

    --tell('Display Full Hand Text')
    local new_mult  = G.GAME.hands[text].mult
    local new_chips = G.GAME.hands[text].chips

	local active = MadLib.get_subhands(hand)

    for i=1, #active do
        new_chips   = new_chips * active[i].x_chips
        new_mult    = new_mult * active[i].x_mult
    end

    --tell(tostring(new_chips) .. ", " .. tostring(new_mult))

    if Cryptid then
        new_chips   = Cryptid.ascend(new_chips)
        new_mult    = Cryptid.ascend(new_mult)
    end

    local hand_text_new = {
        handname    = disp_text,
        level       = G.GAME.hands[text].level,
        mult        = new_mult,
        chips       = new_chips
    }

    update_hand_text({ immediate = true, nopulse = nil, delay = 0 }, hand_text_new)

    return true
end

function Madcap.Funcs.play_hand_before(scoring_hand)
    tell('Play Hand Before')

    -- Handle subhands
	--local active = MadLib.get_subhands(scoring_hand)

	if #active > 0 then
        for i=1, #active do
            tell('Hand/Chips Before:' .. tostring(hand_chips) .. "," .. tostring(mult))
            if active[i].x_chips > 0 then
                tell(tostring(hand_chips) .. " + " .. tostring(active[i].x_chips) .. " = " .. tostring(hand_chips*active[i].x_chips))
                hand_chips  = mod_chips(hand_chips + active[i].x_chips)
                G.HUD:get_UIE_by_ID('hand_chips'):juice_up(0.3, 0.3)
            end

            if active[i].x_mult > 0 then
                tell(tostring(mult) .. " + " .. tostring(active[i].x_mult) .. " = " .. tostring(mult*active[i].x_mult))
                mult        = mult + active[i].x_mult
                G.HUD:get_UIE_by_ID('hand_mult'):juice_up(0.3, 0.3)
            end

            update_hand_text({ sound = 'chips2', delay = 3.0 }, { chips = hand_chips, mult = mult })
            tell('Hand/Chips After:' .. tostring(hand_chips) .. "," .. tostring(mult))
        end
	end
end

function Madcap.Funcs.do_full_hand_stuff(text,disp_text,scoring_hand)
    local new_chips = G.GAME.hands[text].chips
    local new_mult  = G.GAME.hands[text].mult
	local active    = MadLib.get_subhands(scoring_hand)

	if #active > 0 then
        for i=1, #active do
            G.E_MANAGER:add_event(Event({trigger = 'immediate', delay = 0.0,
            func = function()
                new_chips   = new_chips * active[i].x_chips
                new_mult    = new_mult * active[i].x_mult
                update_hand_text({sound = 'chips2'}, {
                    chips = new_chips,
                    mult = new_mult
                })
                G.HUD:get_UIE_by_ID('hand_chips'):juice_up(0.3, 0.3)
                G.HUD:get_UIE_by_ID('hand_mult'):juice_up(0.3, 0.3)
                play_sound('timpani', 0.8)
                delay(0.3)
                return true
                end,
            }))
        end
        delay(#active*2.0)

        if Cryptid then
            new_chips   = Cryptid.ascend(new_chips)
            new_mult    = Cryptid.ascend(new_mult)
        end
    end

    return {
        handname = disp_text,
        level  = G.GAME.hands[text].level,
        mult   = new_mult,
        chips  = new_chips
    }
end

function Madcap.Funcs.finalize_chips_mult(scoring_hand)
    tell("Do Full Hand Stuff")
	local active = MadLib.get_subhands(scoring_hand)

    if #active > 0 then
        local new_chips = hand_chips
        local new_mult  = mult

        for i=1, #active do
            new_chips   = new_chips * active[i].x_chips
            new_mult    = new_mult * active[i].x_mult

            hand_chips = mod_chips(new_chips)
            mult = mod_mult(new_mult)
        end
    end
end

-- idk 2
function Madcap.Funcs.play_hand_after(scoring_hand)
    tell('Play Hand After')
    --MadLib.clear_hand_text()
end
