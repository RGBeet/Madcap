return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_stereo",
        atlas       = 'stickers',
        pos         = MLIB.coords(2,1),
        badge_colour = HEX('EBAC40'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(0))
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_stereo = true
        end,
        applied = function(self, card)
            card.count_double = true
        end,
        removed = function(self, card)
            card.count_double = nil
        end,
    }
}
