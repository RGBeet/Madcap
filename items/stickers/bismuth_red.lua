local fix_value = function(card) return math.max(1, (card.ability.extra.edit_factor or 1) * Madcap.Lists.BismuthValues.Red) end
return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_red",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,0),
        badge_colour = HEX("C95B86"),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(fix_value(card)))
        end,
        config = { extra = { edit_factor = 1 } },
        should_apply = false,
        bismuth = true,
        calculate = function(self, card, context)
            if
                not context.repetition
                and ((context.joker_main and context.cardarea == G.jokers) or (context.main_scoring and context.cardarea == G.play))
            then
                local _xmult = fix_value(card)
                return {
                    message = localize{ type = 'variable', key = 'a_xmult', vars = { _xmult } },
                    x_mult  = _xmult,
                    colour  = G.C.MULT,
                }
            end
        end,
    }
}
