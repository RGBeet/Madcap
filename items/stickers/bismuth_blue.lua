Madcap.BismuthValues.Chips = 50
return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_blue",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,4),
        badge_colour = HEX("3867DD"),
        config  = { chips = 50 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(Madcap.BismuthValues.Chips * (card.ability.extra and card.ability.extra.edit_factor or 1)))
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
                local _chips = Madcap.BismuthValues.Chips * (card.ability.extra and card.ability.extra.edit_factor or 1)
                return { 
                    message = localize{ type = 'variable', key = 'a_chips', vars = { _chips } },
                    chips   = _chips,
                    colour  = G.C.CHIPS,
                }
            end
        end,
    }
}
