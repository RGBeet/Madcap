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
            return MadLib.collect_vars(number_format(math.max(1, Madcap.Lists.BismuthValues.Red)))
        end,
        bismuth = true,
        calculate = function(self, card, context)
            if
                not context.repetition
                and ((context.joker_main and context.cardarea == G.jokers) or (context.main_scoring and context.cardarea == G.play))
            then
                return { x_mult = math.max(1, Madcap.Lists.BismuthValues.Red) }
            end
        end,
    }
}
