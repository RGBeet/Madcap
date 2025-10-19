return {
    data = {
        object_type     = "Stake",
        name            = "Ebony Wager",
        key             = "wager_t3",
        applied_stakes  = { "rgmc_wager_t2" },
        atlas           = "stakes",
        pos             = { x = 2, y = 0 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 2, y = 0 },
        modifiers = function()
            G.GAME.modifiers.enable_perishables_in_shop = true
        end,
        colour = G.C.RGMC_EBONY,
    }
}
