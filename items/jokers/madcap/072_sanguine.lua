return {
    categories = {
        'New Suits' -- goblets, daggers
    },
    data = {
        object_type = "Joker",
        key     = 'sanguine',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,2),
        rarity  = 2,
        cost    = 8,
        config = {
            extra = { suits = {'rgmc_goblets', 'rgmc_daggers' }, x_mult = 2.5 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(localize(card.ability.extra.suits[1], 'suits_singular'), localize(card.ability.extra.suits[2], 'suits_singular'), card.ability.extra.x_mult, { G.C.SUITS[card.ability.extra.suits[1]], G.C.SUITS[card.ability.extra.suits[2]]})
        end,
        calculate = function(self, card, context)
            if (context.joker_main and context.scoring_hand) or context.forcetrigger then
                local pass = context.forcetrigger
                if not pass and context.scoring_hand then
                    pass = MadLib.list_matches_one(context.scoring_hand, function(v)
                        return v:is_suit(card.ability.extra.suits[1])
                    end) and MadLib.list_matches_one(context.scoring_hand, function(v)
                        return v:is_suit(card.ability.extra.suits[2])
                    end)
                end
                if pass then return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult) end
            end
        end
    }
}
