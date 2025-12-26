return {
    categories = {
        'New Suits' -- goblets, daggers
    },
    data = {
        object_type = "Joker",
        key     = 'stonebound',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,2),
        rarity  = 2,
        cost    = 8,
        config = {
            extra = { suits = {'rgmc_towers', 'rgmc_blooms' }, chips = 75 }
        },
        loc_vars = function(self, info_queue, card)
            local suits = Madcap.Funcs.get_joker_suits(card, { 'rgmc_towers', 'rgmc_blooms' })
            return MadLib.collect_vars_colours(localize(suits[1], 'suits_singular'),
                localize(suits[2], 'suits_singular'),
                card.ability.extra.chips,
                { G.C.SUITS[suits[1]], G.C.SUITS[suits[2]]})
        end,
        calculate = function(self, card, context)
            if (context.joker_main and context.scoring_hand) or context.forcetrigger then
                local pass = context.forcetrigger
                local suits = Madcap.Funcs.get_joker_suits(card, { 'rgmc_towers', 'rgmc_blooms' })
                if not pass and context.scoring_hand then
                    pass = MadLib.list_matches_one(context.scoring_hand, function(v)
                        return v:is_suit(suits[1])
                    end) and MadLib.list_matches_one(context.scoring_hand, function(v)
                        return v:is_suit(suits[2])
                    end)
                end
                if pass then return { chips = card.ability.extra.chips } end
            end
        end,
        in_pool = function(self, args)
            return G.GAME.Exotic
        end,
        demicoloncompat = true,
    }
}
