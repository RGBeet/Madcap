return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_invisible",
        atlas       = 'stickers',
        pos         = MLIB.coords(2,0),
        badge_colour = HEX('8B75AD'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(0))
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_invisible = true
        end,
        applied = function(self, card)
        end,
        removed = function(self, card)
        end,
    }
}
