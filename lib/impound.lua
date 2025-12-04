function Madcap.Funcs.impound_cards(cards)
    if not G.impound then
        tell('Impound area not active!')
        return false
    end
    local count = #cards
    local it = 1
    SMODS.calculate_context({ impounding_cards = true, cards = cards })
    MadLib.loop_func(cards, function(v)
        if v.area and v.area == G.deck then
            G.deck.config.card_limit = G.deck.config.card_limit - 1
            print("The deck")
        end
        draw_card(v.area, G.impound, nil, nil, nil, v)
        it = it + 1
    end)
    return true
end

function Madcap.Funcs.impound_card(card)
    return Madcap.Funcs.impound_cards({ card })
end