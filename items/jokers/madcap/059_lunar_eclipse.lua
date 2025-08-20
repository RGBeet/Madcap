return {
    categories = {
        'Score Mechanic',
    },
    data = {
        object_type = "Joker",
        key     = 'lunar_eclipse',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 6,
        pos     = MLIB.coords(5,8),
        config =  {
            extra = { x_mult = 1.30, subhand = 'Dark' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_mult, card.ability.extra.subhand)
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_dark'))
                or context.forcetrigger
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
            end
        end,
        demicoloncompat = true,
    }
}
