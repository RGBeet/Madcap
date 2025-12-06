return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_negative",
        atlas       = 'stickers',
        pos         = MLIB.coords(1,4),
        badge_colour = HEX('43437C'),
	    config = { extra = { slot = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(self.config.extra.slot))
        end,
        should_apply = false,
        apply = function(self, card, val)
            if card.area == G.jokers or card.area == G.consumeables then
                if card.area and not val then
                    card.area.config.card_limit = card.area.config.card_limit + 1
                    tell('Bruno Mars 1')
                end
                card:remove_from_deck()
                card.ability.rgmc_negative = val
                card:add_to_deck()
            else
                card.ability.rgmc_negative = val
            end
        end,
    }
}
