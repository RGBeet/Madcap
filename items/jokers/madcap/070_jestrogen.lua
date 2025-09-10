return {
    categories = {
        'Stickers' -- immutable
    },
    data = {
        object_type = "Joker",
        key     = 'jestrogen',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,9),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = {
                poker_hands = { 'Flush', MadLib.SpectrumId },
                rank = "Queen",
                repetitions = 1
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.poker_hands[1], 'poker_hands'),
                localize(card.ability.extra.poker_hands[2], 'poker_hands'),
                localize(card.ability.extra.ranks, 'ranks'),
                number_format(card.ability.extra.repetitions))
        end,
        calculate = function(self, card, context)
            if 
                context.cardarea == G.play
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id)
            then
            end
        end,
        demicoloncompat = false,
    }
}
