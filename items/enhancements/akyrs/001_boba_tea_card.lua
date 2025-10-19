return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'boba_tea_card',
        atlas   = 'enhancements',
        pos     = MLIB.coords(2,3),
        config  = { extra = { x_score = 1.1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_score)
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return { xscore = card.ability.extra.x_score, card = card }
            end
        end,
    }
}
