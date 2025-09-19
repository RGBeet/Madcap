return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Joker",
        key     = 'penumbral',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,0),
        rarity  = 3,
        cost    = 8,
        config =  {
            extra = { x_mult = 2.5 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_mult)
        end,
        calculate = function(self, card, context)
            if (context.joker_main
                and MadLib.spectrum_played(context) 
                and MadLib.context_has_subhand(context,'ml_sh_dark')) 
                or context.forcetrigger 
            then
                return { xmult = card.ability.extra.x_mult }
            end
        end,
        in_pool = function(self, args) -- can play Dark subhands
            return G.GAME.subhands
                and G.GAME.subhands['ml_sh_dark']
                and G.GAME.subhands['ml_sh_dark'].enabled
        end,
        demicoloncompat = true,
    }
}
