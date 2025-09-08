return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'raining_sevens',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = { numerator = 1, numerator_mod = 1, rank = '7', goal = 3 },
            immutable = { cards_scored = 0 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(card.ability.extra.numerator_mod),
                number_format(card.ability.extra.goal),
                localize(card.ability.extra.rank or '7', 'ranks'),
                number_format(card.ability.extra.numerator_mod*2),
                number_format(card.ability.extra.numerator))
        end,
        calculate = function(self, card, context)
            -- Gimme numerator
            if 
                context.mod_probability 
                and not context.blueprint 
                and not context.repetition 
            then
                return { numerator = context.numerator + card.ability.numerator }
            end
            -- Up the numerator
            if 
                (context.individual 
                and context.cardarea == G.play 
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank or '7'].id) 
                and not context.blueprint)
                or context.forcetrigger
            then
                card.ability.immutable.cards_scored = card.ability.immutable.cards_scored + 1
                if card.ability.immutable.cards_scored >= card.ability.extra.goal then
                    SMODS.scale_card(card, {
                        ref_table   = card.ability.extra,
                        ref_value   = "numerator",
                        scalar_value = "numerator_mod",
                        scaling_message = {
                            message = "+" .. number_format(card.ability.card.ability.numerator_mod),
                            colour = G.C.GREEN
                        }
                    })
                end
            end
            -- Down the numerator
            if 
                context.pseudorandom_result 
                and context.result 
            then
                local decrement = card.ability.extra.numerator_mod * 2
                decrement = (card.ability.extra.numerator - decrement) > 0 and decrement or card.ability.extra.numerator
                card.ability.extra.numerator = card.ability.extra.numerator - decrement
                return {
                    message = "-" .. number_format(decrement),
                    colour  = G.C.RED
                }
            end
        end,
        demicoloncompat = true,
    }
}
