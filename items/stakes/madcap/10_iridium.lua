return {
    data = {
        object_type     = "Stake",
        name            = "Iridium Wager",
        key             = "wager_t10",
        applied_stakes  = { "rgmc_wager_t9" },
        atlas           = "stakes",
        pos             = { x = 4, y = 1 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 4, y = 1 },
        shiny = true,
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_shop_inflation = true
        end,
        colour = G.C.RGMC_IRIDIUM,
    }
}
