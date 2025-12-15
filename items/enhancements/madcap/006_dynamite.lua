return {
    categories = {
        'Enhancements',
        'Disenhancements',
        'Score'
    },
    data = {
        object_type = "Enhancement",
        key     = 'dynamite',
        atlas   = 'enhancements',
        pos     = MLIB.coords(1,1),
        config = { 
            extra = { 
                x_score = 1.4, 
                x_mult = 2, 
                odds = 6, 
            }
        },
        disenhancement      = true,
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'dynamite')
            local x_score = math.max(0,card.ability.extra.x_score)
            return MadLib.collect_vars(number_format(MadLib.round(x_score,2)), number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return { 
                    xscore          = card.ability.extra.x_score,
                    after_scoring   = true 
                }
            end
            if 
                context.destroy_card 
                and context.cardarea == G.play 
                and context.destroy_card == card
                and context.ml_post_scoring
            then
                card.to_explodinate = true
                return { remove = true }
            end
        end,
    }
}
