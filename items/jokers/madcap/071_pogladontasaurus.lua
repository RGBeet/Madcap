return {
    data = {
        object_type = "Joker",
        key     = 'pogladontasaurus',
        atlas   = 'jokers',
        rarity  = 2,
        cost    = 6,
        pos     = MLIB.coords(7,0),
        config = {
            extra = { repetitions = 2, rank = "4", },
            immutable = { max_repetitions = 20, active = false }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(MadLib.get_rank_locvar(card, '4'),
                math.min(card.ability.extra.repetitions,
                card.ability.immutable.max_repetitions))
        end,
        calculate = function(self, card, context)
            -- do held hand shit
            if 
                context.individual
                and context.cardarea == G.hand
                and context.other_card
                and not context.end_of_round
            then
                if MadLib.joker_check_rank(context.other_card, card, '4') then
                    card.ability.immutable.active = true
                    return {
                        repetitions = math.min(card.ability.extra.repetitions, card.ability.immutable.max_repetitions),
                        card = card
                    }
                end
            end
        end,
        demicoloncompat = false, -- TODO: add later
    }
}
