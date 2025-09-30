return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'wolfram',
        atlas   = 'enhancements',
        pos     = MLIB.coords(0,1),
        config  = { extra = { mult = 3, gain = 3 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult, card.ability.extra.gain)
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return { mult = card.ability.extra.mult }
            end
            if context.playing_card_end_of_round and context.cardarea == G.hand then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                return {
                    message     = localize('k_upgrade_ex'),
                    colour      = G.C.MULT,
                    card        = card
                }
            end
        end,
        draw = function(self, card, layer)
            card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
        end
    }
}
