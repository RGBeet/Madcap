local applied_stake = Pacdam and "rgmc_wager_t5p" or "rgmc_wager_t5" 
return {
    data = {
        object_type     = "Stake",
        name            = "Saffron Wager",
        key             = "wager_t6",
        applied_stakes  = { applied_stake },
        atlas           = "stakes",
        pos             = { x = 0, y = 1 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 0, y = 1 },
        modifiers = function()
            G.GAME.modifiers.rgmc_enable_card_impounding = true
            G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
        end,
        colour = G.C.RGMC_SAFFRON,
    }
}
