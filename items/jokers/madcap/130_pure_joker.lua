return {
    categories = {
        'Unfinished Content',
        'New Suits',
        'Voids and Lanterns'
    },
    data = {
        object_type = "Joker",
        key     = 'pure_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(12,9),
        rarity  = 2,
        cost    = 6,
        config = {
            extra = { mult = 10, suit = 'rgmc_lanterns' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.mult),
                localize(card.ability.extra.suit, 'suits_plural'),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card:is_suit(card.ability.extra.suit)
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end
        end,
        demicoloncompat = true,
    }
}
