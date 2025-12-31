-- thorium joker conversions
Madcap.Funcs.TwinkleTansfer = function(fc,tc)
    local edition = fc.edition
    fc:set_edition(nil,true,true)
    tc:set_edition(edition,true,true)
    fc:set_rgmc_twinkling(false)
    tc:set_rgmc_twinkling(true)
    fc:juice_up(0.5, 0.7)
    tc:juice_up(0.5, 0.7)
    play_sound('rgmc_contagion', 1, 0.6)
end

return {
    data = {
        object_type = "Joker",
        key     = 'twinkle_of_contagion',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,5),
        rarity  = 2,
        cost    = 6,
        config  = {
            extra = { twinkles = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.twinkles))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.cardarea == G.play
                    and context.individual
                    and context.other_card
                    and (context.other_card.edition and context.other_card.ability['rgmc_twinkling'])
            end
            if context.forcetrigger then
                local from_cards = MadLib.shuffle_sort_list(G.hand.cards, card.ability.extra.twinkles or 1, function(v)
                    return v.edition and v.edition.polychrome and v.ability['rgmc_twinkling']
                end)

                if #from_cards < 1 then return false end -- terminate if no polychrome twinklings

                MadLib.loop_func(from_cards, function(v1)
                    local tc = MadLib.shuffle_sort_list(G.hand.cards, 1, function(v2)
                        return not (v.edition or v.ability['rgmc_twinkling'])
                    end)

                    if tc then
                        MadLib.simple_event(function()
                            twinkle_transfer(context.other_card,tc)
                            return true
                        end, 0.1, 'after')
                    end
                end)
            end
            if context.first_hand_drawn then
                local targets = MadLib.shuffle_sort_list(G.hand.cards, card.ability.extra.twinkles or 1, function(v) return true end)
                MadLib.loop_func(targets, function(v,i)
                    MadLib.simple_event(function()
                        v:set_edition({ polychrome = true })
                        v:set_rgmc_twinkling(true)
                        v:juice_up(0.5, 0.7)
                        play_sound('rgmc_contagion', math.min(1+i*0.1, 2), 0.6)
                        return true
                    end, math.max(0.6-i*0.05,0.1), 'after')
                end)
            end
            if
                context.cardarea == G.play
                and context.individual
                and context.other_card
                and (context.other_card.edition and context.other_card.ability['rgmc_twinkling']) -- twinkling
            then
                local tc = MadLib.shuffle_sort_list(G.hand.cards, 1, function(v)
                    return not (v.edition or v.ability.twinkling)
                end)
                if tc then
                    local fc = context.other_card
                    MadLib.simple_event(function()
                        tell('do the thing')
                        twinkle_transfer(fc,tc[1])
                        return true
                    end, 0.1, 'after')
                end
            end
        end,
        demicoloncompat = true,
        quasicoloncheck = true,
    },
}
