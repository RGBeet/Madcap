return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = "Sticker",
        key     = "rgmc_bismuth_purple",
        atlas   = 'stickers',
        pos     = MLIB.coords(2,3),
        badge_colour = HEX("3867DD"),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(math.max(1, Madcap.Lists.BismuthValues.Purple)))
        end,
        should_apply = false,
        bismuth = true,
        calculate = function(self, card, context)
            if
                not context.repetition
                and ((context.joker_main and context.cardarea == G.jokers) or (context.main_scoring and context.cardarea == G.play))
            then
                return { xscore = math.max(1, Madcap.Lists.BismuthValues.Purple) }
            end
        end,
    }
}
