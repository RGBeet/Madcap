return {
    categories = {
        'Poker Hands',
        'New Ranks',
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_infoak",
        visible = false,
        chips = 150,
        mult = 15,
        l_chips = 50,
        l_mult = 5,
        example = {
            { "H_IN", 	true },
            { "S_IN", 	true },
            { "rgmc_DAG_IN", true },
            { "rgmc_BLO_IN", true },
            { "rgmc_LAN_IN", true },
        },
        evaluate = function(parts, hand)
            local infinity = 0
            for _,v in pairs(hand) do
                if v:get_id() == 'rgmc_infinity' then
                    infinity = infinity + 1
                end
            end
            return (infinity > 4) and { hand } or {}
        end,
    }
}
