return {
    data = {
        object_type     = "Stake",
        name            = "Platinum Wager",
        key             = "wager_t9",
        applied_stakes  = { "rgmc_wager_t8" },
        atlas           = "stakes",
        pos             = { x = 3, y = 1 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 3, y = 1 },
        shiny = true,
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_boss_gauntlet = true
        end,
        colour = G.C.RGMC_PLATINUM,
    }
}
