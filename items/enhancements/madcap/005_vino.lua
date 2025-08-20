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
        config = { extra = { x_score = 0.9, active = false } },
        replace_base_card   = true,
        no_suit             = true,
        no_rank             = true,
        always_scores       = true,
        disenhancement      = true,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_sore)
        end,
        calculate = function(self, card, context)
            -- when scoring and wins...
            if context.cardarea == G.play and context.main_scoring then
                card.ability.extra.active = true
                local score = card.ability.extra and card.ability.extra.score or 0.8
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiScore, card, score)
            end
            if context.after and card.ability.extra.active then
                if MadLib.meets_blind_requirements() then
                    -- change into bismuth
                    MadLib.flip_cards(stoned, function(v)
                        v:set_ability(G.P_CENTERS['m_rgmc_bismuth'])
                    end, nil, function(v)
                        MadLib.simple_event(function()
                            v:juice_up()
                            return true
                        end)
                    end)
                else
                    card.ability.extra.active = false
                end
            end
        end,
    }
}
