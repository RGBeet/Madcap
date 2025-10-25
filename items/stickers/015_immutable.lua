return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_immutable",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,4),
        badge_colour = HEX('4666DC'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(0))
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_immutable = true
        end,
    }
}
