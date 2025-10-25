return {
    categories = {
        'Unusual',
        'Mayhem'
    },
    data = {
        object_type = "Joker",
        key     = 'cat_planet',
        atlas   = 'jokers',
        pos     = MLIB.coords(9,0),
        rarity  = 'rgmc_unusual',
        cost    = 13,
        config = { },
        loc_vars = function(self, info_queue, card)
            return { vars = {} }
        end,
        calculate = function(self, card, context)
            -- When using planets (and some Spectrals), gain Mayhem.
            if (context.using_consumeable and context.consumeable and (context.consumeable.ability.set == 'Planet' or context.consumeable.ability.set == 'Spectral')) or context.forcetrigger then
                -- get the target to grab
                local target = nil
                if context.forcetrigger then
                    local planets = MadLib.get_list_matches(G.consumeables.cards, function(v)
                    return (v.ability.set == "Planet" or v.ability.set == "Spectral")
                        and not (v.getting_sliced or v.ability.eternal)
                    end)
                    target = pseudorandom_element(planets, pseudoseed("rgmc_cat_planet"))
                else
                    target = context.consumeable
                end
                -- Acquire the chips/mult, convert to mayhem.
                local chips, mult, changed = Madcap.Funcs.get_goldenhouse_chipmult(target)
                if changed then
                    local mayhem = (chips/20 + mult/4) * 5
                    MadLib.simple_event(function()
                        Madcap.Funcs.ease_mayhem(mayhem)
                        play_sound('rgmc_meow3', 1, 0.5)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                            message = "+" .. number_format(mayhem),
                            colour = G.C.RGMC_UNUSUAL
                        })
                        return true
                    end, 0.4, 'immediate')
                end
            end
        end,
        demicoloncompat = true
    }
}
