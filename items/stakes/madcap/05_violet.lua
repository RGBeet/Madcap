return {
    data = {
        object_type     = "Stake",
        name            = "Violet Wager",
        key             = "wager_t5",
        applied_stakes  = { "rgmc_wager_t4" },
        atlas           = "stakes",
        pos             = { x = 4, y = 0 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 4, y = 0 },
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_faulty_in_shop = true
        end,
        colour = G.C.RGMC_VIOLET,
    }
}
