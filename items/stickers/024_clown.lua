return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_clown",
        atlas   = 'stickers',
        pos     = MLIB.coords(3,0),
        badge_colour = HEX('F13938'),
        loc_vars = function(self, info_queue, card)
            return Madcap.BlankVar
        end,
        calculate = function(self, card, context)
            -- funny clown moment
            if context.main_scoring  and context.cardarea == G.play and not context.repetition and not context.individual then
                MadLib.event({
                    trigger = 'after',
                    func = function()
                        play_sound('rgmc_clown_ow', 1.2, 0.4)
                        card:juice_up(0.3,0.3)
                        return true
                    end
                })
            end
        end,
    }
}
