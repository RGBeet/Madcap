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
        chips = 200,
        mult = 18,
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
            local spectrum_part = parts[MadLib.SpectrumId..'spectrum']
            if not (spectrum_part and next(spectrum_part) and next(parts['rgmc_pyramid_base'])) then return {} end
            return { SMODS.merge_lists(spectrum_part, parts['rgmc_pyramid_base']) }
        end,
    }
}
