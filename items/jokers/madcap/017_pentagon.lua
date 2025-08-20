return {
    data = {
        object_type = "Joker",
        atlas   = 'jokers',
        key     = 'pentagon',
        pos     = MLIB.coords(1,6),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { chips = 21, }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.play
                and context.individual
            then
                local rank = context.other_card:get_id()
                if MadLib.is_pentagonal(tonumber(rank))
                    or rank == 'Queen'
                then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
                end
            end
        end,
        demicoloncompat = true,
    },
}
