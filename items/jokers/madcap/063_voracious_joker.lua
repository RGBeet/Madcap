return {
    categories = {
        'New Suits',
    },
    data = {
        object_type = "Joker",
        key     = 'voracious_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,2),
        rarity  = 1,
        cost    = 4,
        config = {
            extra = { mult = 6, suit = 'rgmc_blooms' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.mult),
                localize(card.ability.extra.suit, 'suits_singular'),
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
