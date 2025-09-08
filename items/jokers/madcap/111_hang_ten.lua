return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'hang_ten',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
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
                if MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.ranks[1] or '10'].id) then
                    return not context.other_card.debuff
                        and { mult = card.ability.extra.mult }
                        or  { message = localize('k_debuffed'), colour = G.C.RED }
                end
                if 
                    MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.ranks[2] or '2'].id)
                    and context.other_card.debuff
                then
                    return { xmult = card.ability.extra.x_mult }
                end
            end
            -- Gives +10 Mult, and X0.8 Mult if holding at least one 2
            if context.forcetrigger then
                return { 
                    mult = card.ability.extra.mult,
                    xmult = MadLib.list_matches_one(G.hand.cards, function(v)
                        return MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.ranks[2] or '2'].id)
                    end) and 0.8 or nil
                }
            end
        end,
        demicoloncompat = true
    }
}
