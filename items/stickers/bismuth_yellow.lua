local fix_value = function(card) return math.max(1, (card.ability.extra.edit_factor or 1) * Madcap.Lists.BismuthValues.Yellow) end
return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_yellow",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,2),
        badge_colour = HEX("3867DD"),
        config  = { draw = 1 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(fix_value(card))
        end,
        config = { extra = { edit_factor = 1 } },
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
                    dollars = to_big(fix_value(card)),
                    card = card,
                    func = function() -- This is for timing purposes, this goes after the dollar modification
                        MadLib.event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        })
                    end
                }
            end
        end,
    }
}
