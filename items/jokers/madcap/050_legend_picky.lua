return {
    data = {
        object_type = "Joker",
        key     = 'legend_picky',
        atlas   = 'jokers_legendary',
        pos        = MLIB.legend(0, false),
        soul_pos   = MLIB.legend(0, true),
        rarity     = 4,
        cost       = 15,
        config =  {
            extra = { x_mult = 1.75, x_xmult = 1.25 },
            immutable = { antes_completed = 0 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                    number_format(card.ability.extra.x_mult),
                    number_format(card.ability.extra.x_xmult*100 - 100),
                    number_format(card.ability.immutable.antes_completed))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.cardarea == G.jokers and context.joker_main
            end
            if
                not context.individual
                and context.end_of_round and G.GAME.blind.boss
                and not (context.blueprint or context.repetition)
                and not (G.GAME.blind.config and G.GAME.blind.config.bonus)
            then
                card.ability.immutable.antes_completed = card.ability.immutable.antes_completed + 1
                card.ability.extra.x_mult = card.ability.extra.x_mult * card.ability.extra.x_xmult -- add on 25%!
                MadLib.simple_event(function()
                    card:juice_up(0.5, 0.7)
                    return true
                end, 0.4, 'immediate')
                return {
                    message = localize({
                        type    = "variable",
                        key     = 'a_xmult',
                        vars    = { number_format(card.ability.extra.x_mult) },
                        card    = card
                    }),
                }
            end
            if context.forcetrigger or (context.cardarea == G.jokers and context.joker_main) then
                return { xmult = card.ability.extra.x_mult, card = card }
            end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
