function Madcap.Funcs.get_jokeonde_cards(card, context)
    local unscoring_cards = {}
    MadLib.loop_func(context.full_hand, function(v)
        if v.ability.rgmc_jokeonde then
            table.insert(unscoring_cards,v)
            v.ability.rgmc_jokeonde = nil
        end
    end)
    local shuffled = MadLib.shuffle_sort_list(unscoring_cards, math.min(card.ability.extra.amount, #unscoring_cards), function(v)
        return true
    end, function(a,b)
        return not a.edition
    end)
    return shuffled
end

return {
    data = {
        object_type = "Joker",
        key     = 'la_jokeonde',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,4),
        rarity  = 3,
        cost    = 9,
        config =  {
            extra = { amount = 1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.amount or 1)
        end,
        calculate = function(self, card, context)

            if context.before then
                local unscoring_cards = MadLib.get_list_matches(G.play.cards, function(v)
                    return not MadLib.list_matches_one(context.scoring_hand, function(v2)
                        return v2 == v
                    end)
                end)
                MadLib.loop_func(unscoring_cards, function(v)
                    v.ability.rgmc_jokeonde = true
                end)
            end
            -- check if jokeonde would do anything
            if context.checktrigger then
                return context.full_hand 
                    and MadLib.compare_numbers(G.GAME.chips, G.GAME.blind.chips) >= 0
                    and (#Madcap.Funcs.get_jokeonde_cards(card, context) > 0)
            end
            if
                context.final_scoring_step
                and context.full_hand
                and MadLib.compare_numbers(G.GAME.chips, G.GAME.blind.chips) >= 0
            then
                MadLib.loop_func(Madcap.Funcs.get_jokeonde_cards(card, context), function(v)
                    MadLib.simple_event(function()
                        v:set_edition(MadLib.get_weighted_edition(), true)
                        v:juice_up(0.5, 0.7)
                        return true
                    end, 0.4, 'after')
                end)
            end
        end,
        demicoloncompat = true,
    }
}
