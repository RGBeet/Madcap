return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_unity",
        atlas       = 'stickers',
        pos         = MLIB.coords(4,4),
        badge_colour = HEX('574C8F'),
        loc_vars = function(self, info_queue, card)
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_unity = val or true
        end,
        calculate = function(self, card, context)
            if
                context.mod_probability
                and not context.blueprint
                and not context.repetition
            then
                return { numerator = context.numerator + (G.GAME.rgmc_lucky_numerator or 1), context.denominator }
            end
        end
    }
}
