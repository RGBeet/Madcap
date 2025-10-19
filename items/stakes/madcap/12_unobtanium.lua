return {
    data = {
        object_type     = "Stake",
        name            = "Unobtainium Wager",
        key             = "wager_t12",
        applied_stakes  = { "rgmc_wager_t11" },
        atlas           = "stakes",
        pos             = { x = 1, y = 2 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 1, y = 2 },
        shiny = true,
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_unobtanium = true
            G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
        end,
        colour = G.C.RGMC_UNOBTANIUM,
    }
}
