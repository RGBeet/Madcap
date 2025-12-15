return {
    categories = {
        'Enhancements',
        'Disenhancements',
        'Score'
    },
    data = {
        object_type = "Enhancement",
        key     = 'vino',
        atlas   = 'enhancements',
        pos     = MLIB.coords(1,0),
        config = { extra = { x_score = 0.8, odds = 4 } },
        replace_base_card   = true,
        no_suit             = true,
        no_rank             = true,
        always_scores       = true,
        disenhancement      = true,
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vino')
            local x_score = math.max(0,MadLib.round(card.ability.extra.x_score,2))
            return MadLib.collect_vars(number_format(x_score), number_format(x_score/2), number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            -- Scoring effect
            if context.cardarea == G.play and context.main_scoring then
                return { 
                    xscore          = card.ability.extra.x_score,
                    after_scoring   = true 
                }
            end

            -- Held in hand effect
            if
                context.cardarea == G.hand
                and context.main_scoring
                and SMODS.pseudorandom_probability(card, 'vino', 1, card.ability.extra.odds)
            then
                return { 
                    xscore          = MadLib.divide(card.ability.extra.x_score, 2),
                    after_scoring   = true 
                }
            end

            if
                context.ml_post_scoring
                and context.scoring_hand
                and context.other_card == card
            then
                MadLib.event({
                    func    = function()
                        --Madcap.Funcs.explode_card(card)
                        --target:start_dissolve()
                        return true
                    end,
                    trigger = 'after',
                    delay   = 1.0
                })
            end
        end,
    }
}
