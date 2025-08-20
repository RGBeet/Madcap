 return {
    categories = {
         'New Ranks'
    },
    data = {
        object_type = "Joker",
        key     = 'cavalier',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,3),
        rarity  = 2,
        cost    = 6,
        config =  {
            extra = { rank = 'rgmc_Knight', x_chips = 2, }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.rank,'ranks'),
                number_format(card.ability.extra.x_chips))
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.hand and context.other_card and not context.end_of_round) -- held cards
                or context.forcetrigger
            then
                if Madcap.Funcs.get_card_key(context.other_card, card.ability.extra.rank) then
                    return notcontext.other_card.debuff
                        and MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiChips, card, card.ability.extra.x_chips)
                        or MadLib.get_debuff_data(card)
                end
            end
        end,
        demicoloncompat = true,
    },
}
