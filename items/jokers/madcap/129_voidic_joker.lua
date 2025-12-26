return {
    categories = {
        'New Suits',
        'Voids and Lanterns'
    },
    data = {
        object_type = "Joker",
        key     = 'voidic_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(12,8),
        rarity  = 2,
        cost    = 6,
        config = {
            extra = { mult = 10, suit = 'rgmc_voids' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.mult),
                localize(Madcap.Funcs.get_joker_suit(card, 'rgmc_voids'), 'suits_plural'),
                { G.C.SUITS[Madcap.Funcs.get_joker_suit(card, 'rgmc_voids')] })
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card:is_suit(Madcap.Funcs.get_joker_suit(card, 'rgmc_voids'))
            then
                return { mult = card.ability.extra.mult, card = card }
            end
        end,
        demicoloncompat = true,
    }
}
