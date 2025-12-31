Madcap.Lists.PentagonalNumbers = { 'Ace', MadLib.RankIds['1'], '5', MadLib.RankIds['12'], 'Queen' }

local calc_func = function(self, card, context)
    if
        (context.cardarea == G.play
        and context.other_card
        and MadLib.list_matches_one(Madcap.Lists.PentagonalNumbers, function(c)
            return MadLib.is_rank(context.other_card, c) 
        end)) or context.forcetrigger
    then
        return { chips = card.ability.extra.chips } 
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            return context.other_card
                and MadLib.list_matches_one(Madcap.Lists.PentagonalNumbers, function(c)
                    return MadLib.is_rank(context.other_card, c) 
                end)
        end
        return calc_func_ref(self, card, context)
    end
end

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
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}