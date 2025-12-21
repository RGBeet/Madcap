local base_cm_mod_ref = MadLib.base_cm_mod
function MadLib.base_cm_mod(hand,poker_info,data)
    -- Goes before Pacdam, if installed
    --{text,disp_text,poker_hands,scoring_hand,non_loc_disp_text}
    data = data or {}
    local subhands = MadLib.get_subhands(poker_info[4])
    --[[
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

        hand_chips  = mod_chips(MadLib.multiply(hand_chips, x_chips))
        mult        = mod_mult(MadLib.multiply(mult, x_mult))
    end)
    ]]
    tell('Hand/Chips:' .. tostring(hand_chips) .. "," .. tostring(mult))
    return base_cm_mod_ref(hand, poker_info, data) -- just in case...
end

-- idk 2
function Madcap.Funcs.play_hand_after(scoring_hand)
    tell('Play Hand After')
    --MadLib.clear_hand_text()
end
