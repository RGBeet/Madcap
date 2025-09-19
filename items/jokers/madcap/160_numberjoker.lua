return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'numberjoker',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = { extra = { mult = 0, mult_mod = 2 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.mult_mod))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.discard
                and not (SMODS.has_no_rank(context.other_card) or context.other_card:is_face())
            then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = number_format(card.ability.extra.mult),
                    colour  = G.C.MULT
                }
            end
            
            if context.joker_main or context.forcetrigger then
                return { mult = lenient_bignum(card.ability.extra.mult) }
            end
            
            if context.after then
                card.ability.extra.mult = 0
                return {
                    message = localize('k_reset'),
                    colour = G.C.FILTER
                }
            end
        end,
        demicoloncompat = true
    },
}
