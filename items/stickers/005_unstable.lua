
return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_unstable",
        atlas   = 'stickers',
        pos     = MLIB.coords(0,4),
        badge_colour = HEX('8CCE4E'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(0))
        end,
        calculate = function(self, card, context)
            if
                context.end_of_round
                and not context.repetition
                and not context.individual
            then
               -- ???
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_unstable = true
        end,
    }
}
