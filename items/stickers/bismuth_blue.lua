local fix_value = function(card) return math.max(1, (card.ability.extra.edit_factor or 1) * Madcap.Lists.BismuthValues.Blue) end
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
                local _chips = fix_value(card)
                return { 
                    message = localize{ type = 'variable', key = 'a_chips', vars = { _chips } },
                    chips   = _chips,
                    colour  = G.C.CHIPS,
                }
            end
        end,
    }
}
