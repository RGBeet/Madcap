return {
    categories = {
        'Subhands',
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
                (context.cardarea == G.jokers 
                and context.joker_main
                and MadLib.context_has_subhand(context,'ml_sh_dark'))
                or context.forcetrigger
            then
                return { xmult = card.ability.extra.x_mult, card = card }
            end
        end,
        in_pool = function(self, args) -- can play Light subhands
            return G.GAME.subhands and G.GAME.subhands['ml_sh_dark']
        end,
        demicoloncompat = true,
    }
}
