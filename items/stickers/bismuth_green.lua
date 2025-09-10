Madcap.BismuthValues.Repetitions = 1
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
            return MadLib.collect_vars(number_format(card.ability.retriggers) or '??')
        end,
        should_apply = false,
        apply = function(self, card, val)
        end,
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
                    repetitions = card.ability.retriggers,
                    card = card,
                }
            end
        end,
    }
}
