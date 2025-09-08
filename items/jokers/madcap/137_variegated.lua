return {
    categories = {
        'Unfinished Content',
        'Enhancements'
    },
    data = {
        object_type = "Joker",
        key     = 'variegated',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 7,
        config =  {
            extra = { x_mult = 2 }
        },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_rgmc_bismuth
            return MadLib.collect_vars(number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            -- Retrigger held/scored
            if 
                context.individual 
                and context.cardarea == G.hand
                and not context.blueprint
                and SMODS.has_enhancement(context.other_card, 'm_rgmc_bismuth')
            then
                if MadLib.list_matches_one(context.scoring_hand, function(v)
                    return v.config.center ~= G.P_CENTERS.c_base
                        and v.config.center ~= G.P_CENTERS.m_rgmc_bismuth
                end) then
                    return { xmult = card.ability.extra.x_mult }
                end
            end
        end,
        demicoloncompat = false,
    }
}
