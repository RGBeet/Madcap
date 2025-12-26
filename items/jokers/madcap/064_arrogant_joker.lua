return {
    categories = {
        'New Suits',
    },
    data = {
        object_type = "Joker",
        key     = 'arrogant_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,3),
        rarity  = 1,
        cost    = 4,
        config = {
            extra = { mult = 6, suit = 'rgmc_daggers' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.mult),
                localize(Madcap.Funcs.get_joker_suit(card, 'rgmc_daggers'), 'suits_singular'),
                { G.C.SUITS[Madcap.Funcs.get_joker_suit(card, 'rgmc_daggers')] })
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card:is_suit(Madcap.Funcs.get_joker_suit(card, 'rgmc_daggers'))
            then
                return { mult = card.ability.extra.mult }
            end
        end,
        in_pool = function(self, args)
            return G.GAME.Exotic
        end,
        demicoloncompat = true,
    }
}
