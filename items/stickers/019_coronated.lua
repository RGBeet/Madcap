-- If on Joker/consumable, draw extra card to hand?
return {
    data = {
        object_type     = "Sticker",
        key             = "rgmc_coronated",
        atlas           = 'stickers',
        pos             = MLIB.coords(3,4),
        badge_colour    = HEX('D89134'),
        should_apply    = false,
        apply = function(self, card, val)
            card.ability.rgmc_coronated = true
        end,
    }
}
