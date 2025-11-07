if JokerDisplay then
    local jod = JokerDisplay.Definitions
    tell("LOADING JOKERDISPLAY VALUES FOR MADCAP")

    jod['j_rgmc_vari_seala'] = {
        text = {
            {
                { text = "HELLO!" },
            }
        },
        text_config = { colour = G.C.WHITE },
        calc_function = function(card)
            -- Loop throgh cards
            local count =  0
            if G.play then
                local text, _, scoring_hand = JokerDisplay.evaluate_hand()
                    if text ~= 'Unknown' then count = MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v) return v.seal; end) end
                else
                count = 0
            end
            tell('Vari-Seala count is ' .. number_format(count) .. '.')
            card.joker_display_values.count     = count
            local numerator, denominator        = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vari_seala')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }
end