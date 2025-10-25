--[[
    Madcap Mode adds the following:
    > +1 voucher in regular shop
    > +1 booster in regular shop
    > Altered blind reqs (check!)
    > Mayhem (for sure)
    > Black Market (?) for "better deals"
    At end of Boss Blind, gain 2 Luxury Points
]]

return {
    data = {
        object_type     = "Stake",
        name            = "Crimson Wager",
        key             = "wager_t1",
        applied_stakes  = { "stake_white" },
        atlas           = "stakes",
        pos             = { x = 0, y = 0 },
        sticker_atlas   = "stake_stickers",
        sticker_pos     = { x = 0, y = 0 },
        modifiers = function()
            G.GAME.modifiers.scaling            = 1     -- ???
            G.GAME.modifiers.rgmc_stake         = true  -- you are doing a madcap stake
            G.GAME.modifiers.madcap_stickers    = true  -- you are doing a madcap stake
            
            -- Madcap fixes
            G.GAME.starting_params.vouchers_in_shop     = G.GAME.starting_params.vouchers_in_shop + 1
            G.GAME.starting_params.dollars              = G.GAME.starting_params.dollars - 1
            G.GAME.starting_params.consumable_slots     = G.GAME.starting_params.consumable_slots + 1
            
        end,
        colour = G.C.RGMC_CRIMSON,
    }
}
