return {
    categories = {
        'Poker Hands',
        'New Ranks',
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_infoak_flush",
        visible = false,
        chips = 180,
        mult = 18,
        l_chips = 60,
        l_mult = 6,
        example = {
            { "D_IN", 	true },
            { "D_IN", 	true },
            { "D_IN",	true },
            { "D_IN", 	true },
            { "D_IN", 	true },
        },
        evaluate = function(parts, hand)
            local infinity = false
            return (infinity and parts['_flush']) and { hand } or {}
        end,
        generate_ui = 0
    }
}
