return {
    categories = {
        'Subhands',
    },
    data = {
        object_type = "Joker",
        key     = 'solar_eclipse',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 6,
        pos     = MLIB.coords(5,7),
        config =  {
            extra = { x_chips = 1.15, subhand = 'Light' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_chips, card.ability.extra.subhand)
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.jokers and MadLib.context_has_subhand(context,'ml_sh_light'))
                or context.forcetrigger
            then
                return { xchips = card.ability.extra.x_chips, card = card }
            end
        end,
        in_pool = function(self, args) -- can play Light subhands
            return G.GAME.subhands and G.GAME.subhands['ml_sh_light']
        end,
        demicoloncompat = true,
    }
}
