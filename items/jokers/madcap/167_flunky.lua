return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'flunky',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 7,
        config = { 
            extra = { x_score = 1.5, x_mult = 0.5 } 
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.x_score),
                number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            if 
                context.joker_main
                and MadLib.context_has_subhand(context, 'ml_sh_low') 
            then
                return { 
                    xscore  = card.ability.extra.x_score, 
                    xmult   = card.ability.extra.x_mult 
                }
            end
        end,
    },
}
