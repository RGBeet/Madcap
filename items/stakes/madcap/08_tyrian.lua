return {
    data = {
        object_type     = "Stake",
        name            = "Tyrian Wager",
        key             = "wager_t8",
        applied_stakes  = { "rgmc_wager_t7" },
        atlas           = "stakes",
        pos             = { x = 2, y = 1 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 2, y = 1 },
        shiny = true,
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_boss_assists = true
        end,
        colour = G.C.RGMC_TYRIAN,
    }
}
