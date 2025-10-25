function Madcap.Funcs.impound_cards(cards)
    if not G.impound then
        tell('Impound area not active!')
        return false
    end
    local count = #cards
    local it = 1

    SMODS.calculate_context({ impoundin_cards = true, cards = cards })
    MadLib.loop_func(cards, function(v)
        draw_card(G.play,G.discard, it * 100 / count, 'down', false, v)
        it = it + 1
    end)
    
    return true
end

function Madcap.Funcs.impound_card(card)
    return Madcap.Funcs.impound_cards({ card })
end