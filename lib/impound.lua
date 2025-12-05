function Madcap.Funcs.impound_cards(cards)
    if not G.impound then
        tell('Impound area not active!')
        return false
    end
    local count = #cards
    local it = 1
    SMODS.calculate_context({ impounding_cards = true, cards = cards })
    MadLib.loop_func(cards, function(v)
        local area = v.area
        MadLib.event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local c1 = area:remove_card(v)
                local c2 = copy_card(c1, nil, nil, nil, false)
                c1:remove()
                c1 = nil
                draw_card(area, G.impound, nil, nil, nil, c2)
                return true
            end
        })
        
        it = it + 1
    end)
    return true
end

function Madcap.Funcs.impound_card(card)
    return Madcap.Funcs.impound_cards({ card })
end