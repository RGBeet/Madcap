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
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(math.max(1, Madcap.Lists.BismuthValues.Yellow)))
        end,
        apply = function(self, card, val)
        end,
        bismuth = true,
        calculate = function(self, card, context)
            if
                not context.repetition
                and ((context.joker_main and context.cardarea == G.jokers) or (context.main_scoring and context.cardarea == G.play))
            then
                return {
                    dollars = math.max(1, Madcap.Lists.BismuthValues.Yellow),
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
