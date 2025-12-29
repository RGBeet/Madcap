return {
    data = {
        object_type = "Joker",
        key     = 'joker_in_binary',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 4,
        pos     = MLIB.coords(5,2),
        generate_ui = Madcap.Funcs.generate_special_ui,
        long_title = {
            'a.k.a. \"01001010 01101111',
            '01101011 01100101 01110010\"'
        },
        config = {
            extra = { chips = 32, ranks = { MadLib.RankIds['0'], MadLib.RankIds['1'] } }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), 
                localize(card.ability.extra.ranks[2], 'ranks'),
                number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.play and context.other_card)
                or context.forcetrigger
            then
                if
                    context.forcetrigger
                    or MadLib.is_rank(context.other_card, card.ability.extra.ranks[1] or MadLib.RankIds['0'])
                    or MadLib.is_rank(context.other_card, card.ability.extra.ranks[2] or MadLib.RankIds['1'])
                then
                    return { chips = card.ability.extra.chips }
                end
            end
        end,
        demicoloncompat = true,
    }
}
