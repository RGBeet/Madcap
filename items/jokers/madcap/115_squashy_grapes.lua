return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'squashy_grapes',
        atlas   = 'jokers',
        pos     = MLIB.coords(11,4),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { x_mult = 3, xmult_loss = 0.1 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_mult, card.ability.extra.xmult_loss)
        end,
        calculate = function(self, card, context)
            if 
                (context.after and not context.blueprint)
                or context.forcetrigger 
            then
                if card.ability.extra.x_mult - card.ability.extra.xmult_loss <= 1 then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    -- See note about SMODS Scaling Manipulation on the wiki
                    card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.xmult_loss
                    return {
                        message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.xmult_loss } },
                        colour = G.C.RED
                    }
                end
            end
            if context.joker_main then
                return { xmult = card.ability.extra.x_mult }
            end
        end,
        demicoloncompat = true
    }
}
