local calc_func = function(self, card, context)
    if
        (context.individual 
            and context.cardarea == G.play
            and MadLib.list_matches_one(MadLib.RankTypes['Square'], function(c)
                return MadLib.is_rank(context.other_card, c) 
            end))
        or context.forcetrigger 
    then
        return { mult = card.ability.extra.mult }
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            return context.other_card
                and MadLib.list_matches_one(MadLib.RankTypes['Square'], function(c)
                    return MadLib.is_rank(context.other_card, c) 
                end)
        end
        return calc_func_ref(self, card, context)
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'joker_squared',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,3),
        rarity  = 1,
        cost    = 5,
        config =  { extra = { mult = 5 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.mult))
        end,
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
