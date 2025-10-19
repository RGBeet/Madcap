return {
    data = {
        object_type     = "Stake",
        name            = "Indigo Wager",
        key             = "wager_t4",
        applied_stakes  = { "rgmc_wager_t3" },
        atlas           = "stakes",
        pos             = { x = 3, y = 0 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 3, y = 0 },
        modifiers = function()
            G.GAME.modifiers.enable_rentals_in_shop = true
        end,
        colour = G.C.RGMC_INDIGO,
    }
}
