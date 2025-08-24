Madcap.Metals = {
    held = {
        'm_gold',
        'm_steel',
        'm_rgmc_ferrous',
        'm_rgmc_wolfram'
    },
    score = {
        'm_rgmc_ferrous',
        'm_rgmc_wolfram',
        'm_rgmc_plumbum'
    }
}

return {
    data = {
        object_type = "Joker",
        key     = 'metallurgist',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,3),
        rarity  = 2,
        cost    = 6,
        config =  {
            extra = { retriggers = 1 },
            immutable = { max_retriggers = 40 }
        },
        loc_vars = function(self, info_queue, card)
            local metals = {}
            MadLib.loop_table(Madcap.Metals, function(k,v)
                MadLib.loop_func(Madcap.Metals[k], function(v) table.insert(metals, v) end)
            end)
            for i=1, #metals do
                if G.P_CENTERS[metals[i]] then info_queue[#info_queue + 1] = G.P_CENTERS[metals[i]] end
            end
            return Madcap.BlankVar
        end,
        calculate = function(self, card, context)
            if context.repetition then
                local pass = nil
                pass = (context.cardarea == G.hand and MadLib.has_enhancement_in_list(context.other_card, Madcap.Metals.held))
                    or (context.cardarea == G.play and MadLib.has_enhancement_in_list(context.other_card, Madcap.Metals.score))
                if pass then -- passes the test
                    MadLib.simple_event(function()
                        play_sound('rgmc_wrench', 1, 0.4)
                        return true
                    end, 0.2, 'after', false)
                    return MadLib.get_retrigger_data(context.other_card, lenient_bignum(math.min(card.ability.extra.retriggers, card.ability.immutable.max_retriggers)))
                end
            end
        end,
        demicoloncompat = false,
    }
}
