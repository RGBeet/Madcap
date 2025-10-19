return {
    data = {
        object_type     = "Stake",
        name            = "Vibranium Wager",
        key             = "wager_t11",
        applied_stakes  = { "rgmc_wager_t10" },
        atlas           = "stakes",
        pos             = { x = 0, y = 2 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 0, y = 2 },
        shiny = true,
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_shop_shortages = true
        end,
        colour = G.C.RGMC_VIBRANIUM,
    }
}
