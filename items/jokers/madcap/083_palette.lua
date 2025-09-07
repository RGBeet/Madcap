return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Joker",
        key     = 'palette',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,2),
        rarity  = 3,
        cost    = 8,
        config =  {
            extra = { x_chips = 2 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_chips)
        end,
        calculate = function(self, card, context)
            if (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_enhanced')) or context.forcetrigger then return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.x_chips) end
        end,
        in_pool = function(self, args) -- can play Dazzling subhands
            return G.GAME.subhands and G.GAME.subhands['ml_sh_enhanced']
        end,
        demicoloncompat = true,
    }
}
