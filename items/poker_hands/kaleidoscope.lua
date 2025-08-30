return {
    categories = {
        'Poker Hands',
        'Enhancements'
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_kaleidoscope",
        visible = false,
        chips = 80,
        mult = 6,
        l_chips = 15,
        l_mult = 4,
        example = {
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
            { "S_A", true, enhancement = "m_rgmc_bismuth" },
        },
        evaluate = function(parts, hand)
            local bismuths = {}
            return MadLib.loop_func(hand, function(v,i)
                if v.config.center_key ~= "m_rgmc_bismuth" then return false end
                table.insert(bismuths,v)
                return true
            end) >= 5 and { bismuths } or {}
        end,
    }
}
