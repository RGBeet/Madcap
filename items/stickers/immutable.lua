function Card:set_rgmc_immutable(bool,tally)
    self:set_temp_sticker('rgmc_immutable',bool,tally or 3)
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_immutable",
        atlas   = 'stickers',
        pos     = MLIB.coords(3,0),
        badge_colour = HEX('4666DC'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars()
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_immutable = true
        end,
    }
}
