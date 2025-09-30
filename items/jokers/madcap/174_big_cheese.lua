return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'big_cheese',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 12,
        config = { 
            extra = { x_score = 0.9, luxury = 3, active = true } 
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.x_score),
                number_format(card.ability.extra.luxury),
                    card.ability.extra.active 
                        and localize("k_active_ex")
                        or localize("rgmc_inactive"))
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                card.ability.extra.active = true
                return {
                    message = localize('k_active_ex'),
                    colour  = G.C.GREEN
                }
            end
            if 
                context.joker_main
                and card.ability.extra.active
                and MadLib.context_has_subhand(context, 'ml_sh_high') 
            then
                card.ability.extra.active = false
                return { 
                    xscore  = card.ability.extra.x_score, 
                    rgmc_luxury_pts = card.ability.extra.luxury 
                }
            end
        end,
    },
}
