return {
    categories = {
        'Suits' -- requires new suits to load
    },
    data = {
        object_type = "Joker",
        key     = 'pretentious_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,4),
        rarity  = 1,
        cost    = 4,
        config = {
            extra = { mult = 6, suit = 'rgmc_goblets' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.mult),
                localize(Madcap.Funcs.get_joker_suit(card, 'rgmc_goblets'), 'suits_singular'),
                { G.C.SUITS[Madcap.Funcs.get_joker_suit(card, 'rgmc_goblets')] })
        end,
        calculate = function(self, card, context)
            if
                (context.individual
                and context.cardarea == G.play
                and context.other_card:is_suit(Madcap.Funcs.get_joker_suit(card, 'rgmc_goblets')))
                or context.forcetrigger
            then
                return { mult = card.ability.extra.mult }
            end
        end,
        demicoloncompat = true,
    },
}
