local base_cm_mod_ref = MadLib.base_cm_mod
function MadLib.base_cm_mod(hand,poker_info,data)
    -- Goes before Pacdam, if installed
    --{text,disp_text,poker_hands,scoring_hand,non_loc_disp_text}
    data = data or {}
    local subhands = MadLib.get_subhands(poker_info[4])
    tell('Hand/Chips Before:' .. tostring(hand_chips) .. "," .. tostring(mult))

    -- Do subhand shtuff
	MadLib.loop_func(subhands, function(a)
        local sh = G.GAME.subhands[a]
        local x_chips   = (sh.chips > 0 and sh.chips) or 1
        local x_mult    = (sh.mult > 0 and sh.mult) or 1

        if sh.empower > 0 then
            x_chips     = x_chips ^ (1 + 0.02 * sh.empower)
            x_mult      = x_mult ^ (1 + 0.02 * sh.empower)
        end

        hand_chips  = mod_chips(hand_chips * x_chips)
        mult        = mod_mult(mult * x_mult)
    end)

    tell('Hand/Chips After:' .. tostring(hand_chips) .. "," .. tostring(mult))
    return base_cm_mod_ref(hand, poker_info, data) -- just in case...
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
