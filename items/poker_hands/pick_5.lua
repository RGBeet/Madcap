return {
    categories = {
        'Poker Hands',
        'Spatia Planets'
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_pick_five",
        visible = false,
        chips = 100,
        mult = 10,
        l_chips = 40,
        l_mult = 4,
        example = {
            { "C_2", true },
            { "H_4", true },
            { "D_7", true },
            { "D_9", true },
            { "S_Q", true },
        },
        evaluate = function(parts, hand)
            if #hand ~= 5 or not G.GAME.pick_5 then return { } end -- must have 5+ face cards
            local pass = true
            local hand_data, pick5_data = {}, MadLib.deep_copy(G.GAME.pick_5)
            MadLib.loop_func(hand, function(v,i)
                hand_data[i] = { rank = v.base.value, suit = v.base.suit }
            end)
            MadLib.loop_func({ hand_data, pick5_data }, function(t)
                table.sort(t, function(a,b)
                    if a.rank ~= b.rank then
                        return a.rank > b.rank
                    else
                        return a.suit > b.suit
                    end
                end)
            end)
            local index = 0
            --tell("HAND DATA:")
            --print(hand_data)
            --tell("PICK 5 DATA:")
            --print(pick5_data)
            if not (hand_data and #hand_data < 5 and pick5_data and #pick5_data < 5) then return { } end
            while pass and index < 5 do
                if  hand_data[index].rank ~= pick5_data[index].rank or hand_data[index].suit ~= pick5_data[index].suit then
                    pass = false
                end
                index = index + 1
            end
            return pass and { hand } or { }
        end,
    }
}
