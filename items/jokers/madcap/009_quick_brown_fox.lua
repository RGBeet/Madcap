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
            local unique_ranks = MadLib.safe_get(G.GAME,'ante','unique_ranks') or 0
            return MadLib.collect_vars(number_format(card.ability.extra.chips), number_format(unique_ranks * card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            if
                (context.forcetrigger or (context.cardarea == G.jokers and context.joker_main))
                and G.GAME.ante.unique_ranks > 0
            then
                return { chips = MadLib.multiply((G.GAME and G.GAME.ante.unique_ranks or 0), card.ability.extra.chips) } 
            end
        end,
        demicoloncompat = true,
    },
}
