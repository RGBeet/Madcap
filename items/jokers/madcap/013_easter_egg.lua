return {
    data = {
        object_type = "Joker",
        key     = 'easter_egg',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,2),
        rarity  = 1,
        cost    = 6,
        config =  {
            extra = { value = 2, value_mod = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.value, card.ability.extra.value_mod)
        end,
        calculate = function(self, card, context)

            -- At end of blind, increase value by value_mod
            if (context.end_of_round and context.cardarea == G.jokers) then
                card.ability.extra.value = lenient_bignum(card.ability.extra.value + card.ability.extra.value_mod)
                return {
                    message = "+" .. number_format(card.ability.extra.value_mod), -- Upgrade!
                    card = card,
                }
            end

            if (context.selling_self or context.forcetrigger) then
                tell('Editioning cards!')
                local shuffle = MadLib.shuffle_sort_list(G.hand.cards, card.ability.extra.value or 1, function(v)
                return not (v.edition)
                end, function(a, b)
                    return (a.edition and 1 or 0) < (b.edition and 1 or 0)
                end)

                MadLib.loop_func(shuffle, function(v,i)
                    local _edition = MadLib.get_weighted_edition()
                    tell('Edition is... ' .. tostring(_edition))
                    MadLib.simple_event(function()
                        v:set_edition(_edition, true)
                        v:juice_up(0.5, 0.7)
                        v.ability.rgmc_easter_egg = true
                        return true
                    end, 0.4, 'immediate')
                end)

                if context.forcetrigger then card.ability.extra.value = 0 end -- force trigger resets it >:)
            end
        end,
        demicoloncompat = true,
    },
}
