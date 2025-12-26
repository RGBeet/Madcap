return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'money_for_nothing',
        atlas   = 'jokers',
        pos     = MLIB.coords(12,1),
        rarity  = 2,
        cost    = 8,
        config = {
            extra = {
                ranks   = { '9', '5' },
                dollars = 4
            }
        },
        loc_vars = function(self, info_queue, card)
            local ranks = Madcap.Funcs.get_joker_ranks(card, { '9', '5' })
            return { vars = {
                localize(ranks[1], 'ranks'),
                localize(ranks[2], 'ranks'),
                number_format(card.ability.extra.dollars)
            }}
        end,
        calculate = function(self, card, context)
            if 
                (context.individual 
                and context.cardarea == G.play
                and not context.blueprint)
            then
                local ranks = Madcap.Funcs.get_joker_ranks(card, { '9', '5' })
                if MadLib.joker_check_rank(context.other_card, card, ranks[2]) then
                    local position = 0
                    local list = context.scoring_hand or {}
                    for i=1, #list do
                        if context.scoring_hand[i] == context.other_card then
                            position = i
                            break
                        end
                    end
                    for i=1, position-1 do
                        if MadLib.joker_check_rank(list[i], card, ranks[1]) then
                            return { dollars = card.ability.extra.dollars }
                        end
                    end
                end
            end
            if context.forcetrigger then
                return { dollars = card.ability.extra.dollars }
            end
        end,
        demicoloncompat = true
    }
}
