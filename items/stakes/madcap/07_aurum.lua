return {
    data = {
        object_type     = "Stake",
        name            = "Aurum Wager",
        key             = "wager_t7",
        applied_stakes  = { "rgmc_wager_t6" },
        atlas           = "stakes",
        pos             = { x = 1, y = 1 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 1, y = 1 },
        shiny = true,
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_harder_shops = true
        end,
        colour = G.C.RGMC_AURUM,
    }
}
