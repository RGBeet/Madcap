return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_unlucky",
        atlas       = 'stickers',
        pos         = MLIB.coords(3,2),
        badge_colour = HEX('C172A4'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(G.GAME.rgmc_lucky_numerator or 1))
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_unlucky = true
        end,
        calculate = function(self, card, context)
            if
                context.mod_probability
                and not context.blueprint
                and not context.repetition
            then
                local denom = type(context.denominator) == 'number' and denom or 2
                return {
                    numerator = context.numerator,
                    denominator = denom + (G.GAME.rgmc_lucky_numerator or 1)
                }
            end
        end
    }
}
