Madcap.BismuthValues.XMult = 1.5
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
            return MadLib.collect_vars(number_format(Madcap.BismuthValues.XMult * (card.ability.extra and card.ability.extra.edit_factor or 1)))
        end,
        should_apply = false,
        apply = function(self, card, val)
        end,
        bismuth = true,
        calculate = function(self, card, context)
            if
                not context.repetition
                and ((context.joker_main and context.cardarea == G.jokers) or (context.main_scoring and context.cardarea == G.play))
            then
                local _xmult = Madcap.BismuthValues.XMult * (card.ability.extra and card.ability.extra.edit_factor or 1) 
                return {
                    message = localize{ type = 'variable', key = 'a_xmult', vars = { _xmult } },
                    x_mult  = _xmult,
                    colour  = G.C.MULT,
                }
            end
        end,
    }
}
