if MadLib.SpectrumId == 'na' then return {} end

return {
    categories = {
        'Poker Hands',
        'Spectrum'
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_pyramid_spectrum",
        visible = false,
        chips = 170,
        mult = 16,
        l_chips = 50,
        l_mult = 4,
        example = {
            { 'D_K',    true },
            { 'H_8',    true },
            { 'C_8', 	true },
            { 'S_4', 	true },
            { 'rgmc_GOB_4', 	true },
            { 'rgmc_TOW_4', 	true },
        },
        evaluate = function(parts, hand)
            if not (spectrum_part and next(parts[spectrum_part]) and next(parts['rgmc_pyramid_base'])) then return {} end
            return { SMODS.merge_lists(parts[spectrum_part], parts['rgmc_pyramid_base']) }
        end,
    }
}
