return {
    data = {
        object_type     = "Stake",
        name            = "Jade Wager",
        key             = "wager_t2",
        applied_stakes  = { "rgmc_wager_t1" },
        atlas           = "stakes",
        pos             = { x = 1, y = 0 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 1, y = 0 },
        modifiers = function()
            G.GAME.modifiers.enable_eternals_in_shop = true -- eternals now!
        end,
        colour = G.C.RGMC_JADE,
    }
}
