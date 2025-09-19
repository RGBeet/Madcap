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
            if (context.joker_main 
                and MadLib.spectrum_played(context) 
                and MadLib.context_has_subhand(context,'ml_sh_enhanced')) 
                or context.forcetrigger 
            then
                return { xmult = card.ability.extra.x_mult }
            end
        end,
        in_pool = function(self, args) -- can play Dazzling subhands
            return G.GAME.subhands 
                and G.GAME.subhands['ml_sh_enhanced']
                and G.GAME.subhands['ml_sh_enhanced'].enabled
        end,
        demicoloncompat = true,
    }
}
