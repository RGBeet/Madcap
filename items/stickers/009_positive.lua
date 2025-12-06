return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_positive",
        atlas       = 'stickers',
        pos         = MLIB.coords(1,3),
        badge_colour = HEX('EDB658'),
	    config = { extra = { slot = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(math.abs(self.config.extra.slot)))
        end,
        get_rate = function(self, card)
            if G.GAME.modifiers.enable_perishables_in_shop then return 0.25 end
            return 0.08
        end,
        apply = function(self, card, val)
            if card.area == G.jokers or card.area == G.consumeables then
                if card.area and not val then
                    card.area.config.card_limit = card.area.config.card_limit + 1
                    tell('Bruno Mars 2')
                end
                card:remove_from_deck()
                card.ability.rgmc_positive = val
                card:add_to_deck()
            else
                card.ability.rgmc_positive = val
            end
        end,
    }
}