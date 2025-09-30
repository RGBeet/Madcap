local fix_value = function(card) return math.max(1, (card.ability.extra.edit_factor or 1) * Madcap.Lists.BismuthValues.Green) end
return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_green",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,1),
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
                and (
                    (context.joker_main and context.cardarea == G.jokers)
                    or (context.main_scoring and context.cardarea == G.play)
                )
            then
                return {
                    message = localize("k_again_ex"),
                    repetitions = fix_value(card),
                    card = card,
                }
            end
        end,
    }
}
