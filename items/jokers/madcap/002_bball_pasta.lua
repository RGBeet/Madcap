local calc_func = function(self, card, context)
    if context.joker_main or context.forcetrigger then
        return {
            chips   = lenient_bignum(card.ability.extra.chips),
            mult    = lenient_bignum(card.ability.extra.mult),
        }
    end
    if
        (Madcap.Funcs.get_end_of_round(context) -- TODO: fix. Easier way of saying end of round w/o game over
        and SMODS.pseudorandom_probability(card, 'bball_pasta', 1, card.ability.extra.odds)) -- 1 in 4 chance
    then
        SMODS.scale_card(card, {
			ref_table       = card.ability.extra,
			ref_value       = "chips",
			scalar_value    = "chip_mod",
			message_key     = "a_chips",
			message_colour  = G.C.CHIPS,
		})
        SMODS.scale_card(card, {
			ref_table       = card.ability.extra,
			ref_value       = "mult",
			scalar_value    = "mult_mod",
			message_key     = "a_mult",
			message_colour  = G.C.MULT,
		})
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then -- Check
            return context.joker_main
        end
        return calc_func_ref(self, card, context)
    end
end

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
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
