return {
    categories = {
		'Poker Hands'
    },
    data = {
        object_type = "PokerHand",
        key     = "rgmc_pyramid_flush",
        visible = false,
        chips   = 160,
        mult    = 16,
        l_chips = 45,
        l_mult  = 4,
        example = {
            { 'S_K',    true },
            { 'S_8', 	true },
            { 'S_8', 	true },
            { 'S_4',    true },
            { 'S_4',    true },
            { 'S_4', 	true },
        },
        evaluate = function(parts, hand)
            if not (next(parts['_flush']) and next(parts['rgmc_pyramid_base'])) then return {} end
            return {SMODS.merge_lists(parts['rgmc_pyramid_base'], parts['_flush'])}
        end,
    }
}
