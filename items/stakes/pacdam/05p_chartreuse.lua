return {
    data = {
        object_type     = "Stake",
        name            = "Chartreuse Wager",
        key             = "wager_t5p",
        applied_stakes  = { "rgmc_wager_t5" },
        atlas           = "stakes",
        pos             = { x = 0, y = 0 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 0, y = 0 },
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_withering_in_shop = true
        end,
        colour = G.C.RGMC_CHARTREUSE,
    }
}
