return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'ferrous',
        atlas   = 'enhancements',
        pos     = MLIB.coords(0,0),
        config  = { extra = { chips = 15, gain = 15 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.gain)
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end
            if context.playing_card_end_of_round and context.cardarea == G.hand then
                return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.gain)
            end
        end,
        draw = function(self, card, layer)
            card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
        end
    }
}
