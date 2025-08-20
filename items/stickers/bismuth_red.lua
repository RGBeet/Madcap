return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_red",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,0),
        badge_colour = HEX("C95B86"),
        config  = { mult = 15 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.mult) or '??')
        end,
        should_apply = false,
        apply = function(self, card, val)
        end,
        bismuth = true,
        calculate = function(self, card, context)
            if
                not context.repetition
                and (
                    (context.joker_main and context.cardarea == G.jokers)
                    or (context.main_scoring and context.cardarea == G.play)
                )
            then
                return {
                    message = localize{
                        type = 'variable',
                        key = 'a_mult',
                        vars = { card.ability.mult or 1 }
                    },
                    x_mult = card.ability.mult or 1,
                    colour = G.C.MULT,
                }
            end
        end,
    }
}
