return {
    categories = {
        'Poker Hands',
        'New Ranks',
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_noak",
        visible = false,
        chips = 90,
        mult = 8,
        l_chips = 10,
        l_mult = 4,
        example = {
            { "C_0", 	true },
            { "H_0", 	true },
            { "T_0",	true },
            { "D_SU", 	true },
            { "S_SU", 	true },
        },
        evaluate = function(parts, hand)
            local noak = 0
            for _,v in pairs(hand) do
                noak = noak + v.base.nominal
            end
            return ( noak == 0 and #hand > 4 ) and { hand } or {}
        end,
    }
}
