return {
    categories = {
        'Subhands',
    },
    data = {
        object_type = "Joker",
        key     = 'flamboyant_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 6,
        pos     = MLIB.coords(6,1),
        config =  {
            extra = { chips = 70, type = 'Dazzling' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.chips, card.ability.extra.type)
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_enhanced'))
                or context.forcetrigger
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end
        end,
        in_pool = function(self, args) -- can play Dazzling subhands
            return G.GAME.subhands and G.GAME.subhands['ml_sh_enhanced']
        end,
        demicoloncompat = true,
    }
}
