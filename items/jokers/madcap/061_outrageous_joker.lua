return {
    categories = {
        'Subhands',
    },
    data = {
        object_type = "Joker",
        key     = 'outrageous_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 6,
        pos     = MLIB.coords(6,0),
        config =  {
            extra = { mult = 18, type = 'Dazzling' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult, card.ability.extra.type)
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_enhanced'))
                or context.forcetrigger
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end
        end,
        demicoloncompat = true,
    }
}
