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
        calculate = function(self, card, context)
            if
                ((context.cardarea == G.play and context.other_card)
                or context.forcetrigger)
                and MadLib.list_matches_one(MadLib.RankTypes['Square'], function(c)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[c].id) 
                end)
            then
                return { mult = card.ability.extra.mult }
            end
        end,
        demicoloncompat = true,
    },
}
