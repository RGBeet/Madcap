return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'plumbum',
        atlas   = 'enhancements',
        pos     = MLIB.coords(2,1),
        config  = { extra = { x_mult = 3 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_mult)
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
            end
        end,
        draw = function(self, card, layer)
            card.children.center:draw_shader("voucher", nil, card.ARGS.send_to_shader)
        end
    }
}
