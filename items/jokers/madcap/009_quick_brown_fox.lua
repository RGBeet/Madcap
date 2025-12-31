local calc_func = function(self, card, context)
    if
        context.forcetrigger 
        or (context.cardarea == G.jokers and context.joker_main)
    then
        return { chips = MadLib.multiply((G.GAME and G.GAME.ante.unique_ranks or 0), card.ability.extra.chips) } 
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then -- Check
            return context.cardarea == G.jokers and context.joker_main
        end
        return calc_func_ref(self, card, context)
    end
end

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
            return MadLib.collect_vars(number_format(card.ability.extra.chips), number_format(MadLib.multiply(unique_ranks, card.ability.extra.chips)))
        end,
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
