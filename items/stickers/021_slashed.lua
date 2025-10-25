return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_slashed",
        atlas       = 'stickers',
        pos         = MLIB.coords(6,0),
        badge_colour = HEX('857872'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(G.GAME.rgmc_lucky_numerator or 1))
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_slashed = true
        end
    }
}
