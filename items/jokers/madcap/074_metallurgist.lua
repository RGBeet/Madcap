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
            extra = { repetitions = 1 },
            immutable = { max_repetitions = 40 }
        },
        loc_vars = function(self, info_queue, card)
            local metals = {}
            local total_repetitions = math.min(card.ability.extra.repetitions, card.ability.immutable.max_repetitions)
            MadLib.loop_table(Madcap.Metals, function(k,v)
                MadLib.loop_func(Madcap.Metals[k], function(v) table.insert(metals, v) end)
            end)
            MadLib.loop_func(metals, function(v)
                 if G.P_CENTERS[v] then info_queue[#info_queue + 1] = G.P_CENTERS[v] end
            end)
            return MadLib.collect_vars(card.ability.extra.repetitions)
        end,
        calculate = function(self, card, context)
            if context.repetition then
                local total_repetitions = math.min(card.ability.extra.repetitions, card.ability.immutable.max_repetitions)
                local pass = nil
                pass = (context.cardarea == G.hand and MadLib.has_enhancement_in_list(context.other_card, Madcap.Metals.held))
                    or (context.cardarea == G.play and MadLib.has_enhancement_in_list(context.other_card, Madcap.Metals.score))
                if pass then -- passes the test
                    MadLib.simple_event(function()
                        play_sound('rgmc_wrench', 1, 0.4)
                        return true
                    end, 0.2, 'after', false)
                    return { repetitions = total_repetitions }
                end
            end
        end,
        demicoloncompat = false,
    }
}
