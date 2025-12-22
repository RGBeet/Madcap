-- Used in case High Card is blacklisted
return {
    categories = {
        'Poker Hands'
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_nohand",
        visible = false,
        chips = 1,
        mult = 1,
        l_chips = 1,
        l_mult = 1,
        example = {
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
        },
        evaluate = function(parts, hand)
            return parts._highest
        end
    }
}
