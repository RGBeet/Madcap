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
            return MadLib.collect_vars(localize(card.ability.extra.rank, 'ranks'), math.min(card.ability.extra.repetitions, card.ability.immutable.max_repetitions))
        end,
        calculate = function(self, card, context)
            -- do held hand shit
            if context.individual and context.cardarea == G.hand and context.other_card and not context.end_of_round then
                if MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank].id) then
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
