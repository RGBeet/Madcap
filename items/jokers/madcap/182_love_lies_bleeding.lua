return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'love_lies_bleeding',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_unusual',
        cost    = 16,
        config = { 
            extra = { 
                e_mult      = 0.01,
                suit        = 'rgmc_daggers',
                rank        = 'Jack'
            },
        },
        loc_vars = function(self, info_queue, card)
            local daggers = MadLib.loop_func(G.hand and G.hand.cards or {}, function(v)
                return v:is_suit(card.ability.extra.suit or 'rgmc_daggers')
            end)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.rank or 'Jack','ranks'),
                localize(card.ability.extra.suit or 'rgmc_daggers', 'suits_plural'),
                number_format(card.ability.extra.e_mult),
                number_format(daggers * (1 + card.ability.extra.e_mult)),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id)
            then
                local daggers = MadLib.loop_func(G.hand and G.hand.cards or {}, function(v)
                    return v:is_suit(card.ability.extra.suit or 'rgmc_daggers')
                end)
                return { emult = daggers * (1 + card.ability.extra.e_mult) }
            end
        end,
    },
}
