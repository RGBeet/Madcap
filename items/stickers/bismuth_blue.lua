return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_blue",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,4),
        badge_colour = HEX("3867DD"),
        config  = { chips = 50 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.chips) or '??')
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
                        key = 'a_chips',
                        vars = { card.ability.chips or 1 }
                    },
                    chips = card.ability.chips or 1,
                    colour = G.C.CHIPS,
                }
            end
        end,
    }
}
