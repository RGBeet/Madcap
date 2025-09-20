Madcap.Lists.PentagonalNumbers = { 'Ace', MadLib.RankIds['1'], '5', MadLib.RankIds['12'], 'Queen' }

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
                (context.cardarea == G.play and context.other_card)
                or context.forcetrigger
            then
                local matches = MadLib.list_matches_one(Madcap.Lists.PentagonalNumbers, function(c)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[c].id)
                end)
                if matches then return { chips = card.ability.extra.chips } end
            end
        end,
        demicoloncompat = true,
    },
}