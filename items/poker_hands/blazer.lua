return {
    categories = {
        'Poker Hands'
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_blazer",
        visible = false,
        chips = 100,
        mult = 10,
        l_chips = 50,
        l_mult = 1,
        example = {
            { "C_J", 	true },
            { "H_J", 	true },
            { "D_rgmc_KN",	true },
            { "D_Q", 	true },
            { "S_K", 	true },
        },
        evaluate = function(parts, hand)
            local minimum = 5
            if next(SMODS.find_card('j_four_fingers')) then minimum = 4 end -- four fingers compat
            if #hand < minimum  then return { } end -- must have ALL face cards

            local all_faces = MadLib.list_matches_all(hand, function(v)
                return (not SMODS.has_no_rank(v)) and v:is_face()
            end)
            local num_ranks = #MadLib.get_ranks_from_cards(hand)
            return (all_faces and num_ranks > 2) and { hand } or { }
        end
    }
}
