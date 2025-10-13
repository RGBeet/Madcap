-- Ease temporary hands
function Madcap.Funcs.ease_temp_hands(mod, silent, instant)
    local _mod = function(mod)
        if math.abs(math.max(G.GAME.temporary_hands, mod)) == 0 then return end
        local hand_UI = G.HUD:get_UIE_by_ID('temp_hand_UI_count')
        mod = mod or 0
        mod = math.max(-G.GAME.temporary_hands, mod)
        local text = '+'
        local col = G.C.GREEN
        if mod < 0 then
            text = ''
            col = G.C.RED
        end
        --Ease from current chips to the new number of chips
        G.GAME.temporary_hands = G.GAME.temporary_hands + mod
        attention_text({
          text = text..mod,
          scale = 0.8*0.8,
          hold = 0.7,
          cover = hand_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        hand_UI.config.object:update()
        G.HUD:recalculate()
        --Play a chip sound
        if not silent then play_sound('chips2', 1.2) end
    end
    if instant then
        _mod(mod or 1)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod or 1)
            return true
        end
        }))
    end
end

function Madcap.Funcs.ease_temp_discards(mod, silent, instant)
    local _mod = function(mod)
        if math.abs(math.max(G.GAME.temporary_discards, mod)) == 0 then return end
        local discard_UI = G.HUD:get_UIE_by_ID('temp_discard_UI_count')
        mod = mod or 0
        mod = math.max(-G.GAME.temporary_discards, mod)
        local text = '+'
        local col = G.C.GREEN
        if mod < 0 then
            text = ''
            col = G.C.RED
        end
        --Ease from current chips to the new number of chips
        G.GAME.temporary_discards = G.GAME.temporary_discards + mod
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
          text = text..mod,
          scale = 0.8*0.8,
          hold = 0.7,
          cover = discard_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        discard_UI.config.object:update()
        G.HUD:recalculate()
        --Play a chip sound
        if not silent then play_sound('chips2', 1.2) end
    end
    if instant then
        _mod(mod or 1)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod or 1)
            return true
        end
        }))
    end
end

function Madcap.Funcs.use_temp_discards(mod, instant, silent)
	mod = mod or 1
	Madcap.Funcs.ease_temp_discards(-mod)
	ease_discard(mod, instant, silent)
end

function Madcap.Funcs.use_temp_hands(mod, instant, silent)
	mod = mod or 1
	Madcap.Funcs.ease_temp_hands(-mod)
	ease_discard(mod, instant, silent)
end

-- temporary discard addition
local ease_discard_ref = ease_discard
function ease_discard(mod, instant, silent)
	ease_discard_ref(mod,instant,silent)
    if G.GAME.current_round.discards_left + mod == 0 and G.GAME.temporary_discards > 0 then
        Madcap.Funcs.use_temp_discards(1, false, false)
    end
end

-- temporary hand addition
local ease_hands_played_ref = ease_hands_played
function ease_hands_played(mod, instant)
	ease_hands_played_ref(mod,instant)
    if G.GAME.current_round.hands_left + mod == 0 and G.GAME.temporary_hands > 0 then
        Madcap.Funcs.use_temp_hands(1, false, false)
    end
end
