return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'aesthetic',
        atlas   = 'enhancements',
        pos     = MLIB.coords(2,2),
        overrides_base_rank     = true,
        replace_base_card       = true,
        specific_suit = "rgmc_aesthetic",
        specific_rank = "Ace",
        config  = { extra = { mult = 4 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult)
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end
        end,
    }
}
