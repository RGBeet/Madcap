return {
    data = {
        object_type = "Joker",
        key     = 'bball_pasta',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,1),
        rarity  = 1,
        cost    = 4,
        config =  {
            extra = {
                odds = 6,
                chips = 5,
                mult = 2,
                chip_mod = 5,
                mult_mod = 2
            }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vari_seala')
            return MadLib.collect_vars(
                    number_format(_numer),
                    number_format(_denom),
                    number_format(card.ability.extra.chip_mod),
                    number_format(card.ability.extra.mult_mod),
                    number_format(card.ability.extra.chips),
                    number_format(card.ability.extra.mult))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                return {
                    chips   = lenient_bignum(card.ability.extra.chips),
                    mult    = lenient_bignum(card.ability.extra.mult),
                }
            end
            if
                Madcap.Funcs.get_end_of_round(context)
                and SMODS.pseudorandom_probability(card, 'bball_pasta', 1, card.ability.extra.odds)
            then
                card.ability.extra.mult     = card.ability.extra.mult + card.ability.extra.mult_mod
                card.ability.extra.chips    = card.ability.extra.chips + card.ability.extra.chip_mod
                return { message = localize("k_upgrade_ex") }
            end
        end,
        demicoloncompat = true,
    },
}
