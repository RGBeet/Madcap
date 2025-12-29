return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'hang_ten',
        atlas   = 'jokers',
        pos     = MLIB.coords(11,0),
        rarity  = 1,
        cost    = 7,
        config = {
            extra = { ranks = { '10', '2' } , mult = 10, x_mult = 0.8 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult,
                localize(card.ability.extra.ranks[1] or '10', 'ranks'),
                card.ability.extra.x_mult,
                localize(card.ability.extra.ranks[2] or '2', 'ranks'))
        end,
        calculate = function(self, card, context)
            if 
                context.individual 
                and context.cardarea == G.hand 
                and not context.end_of_round
            then
                if MadLib.is_rank(context.other_card, card.ability.extra.ranks[1] or '10') then
                    return not context.other_card.debuff
                        and { mult = card.ability.extra.mult }
                        or  { message = localize('k_debuffed'), colour = G.C.RED }
                end
                if 
                    MadLib.is_rank(context.other_card, card.ability.extra.ranks[2] or '2')
                    and context.other_card.debuff
                then
                    return { xmult = card.ability.extra.x_mult }
                end
            end
        end,
        demicoloncompat = false
    }
}
