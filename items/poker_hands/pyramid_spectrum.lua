local Bunco     = next(SMODS.find_mod('Bunco'))
local Paperback = next(SMODS.find_mod('Paperback'))
local RGMadcap  = next(SMODS.find_mod('RGMadcap'))
local Framework = next(SMODS.find_mod('SpectrumFramework'))

local spectrum_part = (Bunco and 'bunc_spectrum')
    or (Paperback and 'paperback_spectrum')
    or (Framework and 'spectrum_spectrum') -- would really reccomend at least installing this
    or nil

if not spectrum_part then return {} end -- don't even try

return {
    categories = {
        'Poker Hands',
        'Spectrum'
    },
    data = {
        object_type = "PokerHand",
        key = "rgmc_pyramid_spectrum",
        visible = false,
        chips = 100,
        mult = 10,
        l_chips = 50,
        l_mult = 1,
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
