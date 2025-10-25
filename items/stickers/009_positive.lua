return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_positive",
        atlas       = 'stickers',
        pos         = MLIB.coords(1,3),
        badge_colour = HEX('EDB658'),
        config      = { card_limit = 1 },
        loc_vars = function(self, info_queue, card)
            local key = 'rgmc_positive'
            if card.ability and card.ability.consumeable and card.area ~= G.hand then
                key = 'rgmc_positive_consumable'
            elseif card.ability and (card.ability.set == "Default" or card.ability.set == "Enhanced" or (card.ability.consumeable and card.area and card.area == G.hand)) then
                key = 'rgmc_positive_card'
            end
            return { key = key ,vars = { self.config.card_limit } }
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_positive = true
        end,
        calculate = function(self, card, context)
        end,
    }
}
