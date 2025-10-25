return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_weakened",
        atlas   = 'stickers',
        pos     = MLIB.coords(0,3),
        badge_colour = HEX('D85D5D'),
        loc_vars = function(self, info_queue, card)
            return { key = 'rgmc_weakened' .. (card.ability.rgmc_weakened_active and '_active' or '') }
        end,
        calculate = function(self, card, context)
            if
                context.setting_blind
                and not G.GAME.blind.disabled
                and G.GAME.blind.boss
            then
                SMODS.debuff_card(card, true, 'rgmc_weakened')
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_weakened = true
        end,
    }
}
