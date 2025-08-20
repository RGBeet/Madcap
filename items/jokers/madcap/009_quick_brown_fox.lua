return {
    data = {
        object_type = "Joker",
        key     = 'quick_brown_fox',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,8),
        rarity  = 1,
        cost    = 5,
        config = {  extra = { chips = 7 } },
        loc_vars = function(self, info_queue, card)
            local amt = (G.GAME and G.GAME.MADCAP and G.GAME.ante.unique_ranks) or 0
            return MadLib.collect_vars(number_format(card.ability.extra.chips),
                    number_format(card.ability.extra.chips * amt))
        end,
        calculate = function(self, card, context)
            if
                context.forcetrigger or
                (context.cardarea == G.jokers and context.joker_main)
                and (to_big(card.ability.extra.chips) > to_big(0))
            then
                local amt = G.GAME.ante and G.GAME.ante.unique_ranks or 0
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips * amt)
            end
        end,
        demicoloncompat = true,
    },
}
