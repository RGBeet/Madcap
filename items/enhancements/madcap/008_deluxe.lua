return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'deluxe',
        atlas   = 'enhancements',
        pos     = MLIB.coords(2,0),
        config  = { extra = { luxury = 1, luxury_mod = 1, } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.luxury), number_format(card.ability.extra.luxury_mod))
        end,
        calculate = function(self, card, context)
            -- score
            if 
                context.cardarea == G.play 
                and context.main_scoring then
                return { rgmc_luxury_pts = card.ability.extra.luxury or 1 }
            end

            -- upgrade
            if context.playing_card_end_of_round and context.cardarea == G.hand then
                card.ability.extra.luxury = card.ability.extra.luxury + card.ability.extra.luxury_mod
                return {
                    message     = '+£'..number_format(card.ability.extra.luxury_mod),
                    colour      = G.C.RGMC_LUXURY,
                    card        = card
                }
            end
        end,
        draw = function(self, card, layer)
            card.children.center:draw_shader("voucher", nil, card.ARGS.send_to_shader)
        end
    }
}
