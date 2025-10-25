return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_twinkling",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,3),
        badge_colour = HEX('15BE59'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(0))
        end,
        calculate = function(self, card, context)
            if
                context.end_of_round
                and not context.repetition
                and not context.individual
            then

            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_twinkling = true
        end,
    }
}
