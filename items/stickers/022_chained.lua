return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_chained",
        atlas       = 'stickers',
        pos         = MLIB.coords(6,1),
        badge_colour = HEX('6B8569'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(G.GAME.rgmc_lucky_numerator or 1))
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_lucky = true
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
