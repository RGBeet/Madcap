return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'beyond',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 11,
        config = { extra = { 
            rank        = 'rgmc_Infinity',
            poker_hand  = 'rgmc_infoak',
            x_mult      = 3,
            mult        = 15
        } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1] or '4', 'ranks'),
                localize(card.ability.extra.poker_hand, 'poker_hands'),
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.mult))
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                if 
                    next(context.poker_hands[card.ability.poker_hand])
                    or context.forcetrigger
                then 
                    return { xmult = card.ability.extra.x_mult }
                else
                    local infinities = MadLib.loop_func(context.scoring_hand or {}, function(v)
                        return MadLib.is_rank(v, SMODS.Ranks[card.ability.extra.rank or 'rgmc_Infinity'].id)
                    end)
                    if infinities > 0 then
                        return { mult = infinities * card.ability.extra.mult }
                    end
                end
            end
        end,
    },
}
