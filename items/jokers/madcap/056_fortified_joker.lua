
return {
    categories = {
        'New Poker Hands'
    },
    data = {
        object_type = "Joker",
        key     = 'fortified_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 4,
        pos     = MLIB.coords(5,5),
        config =  {
            extra = { chips = 90, poker_hand = 'rgmc_pyramid' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.mult, localize(card.ability.extra.poker_hand, 'poker_hands'))
        end,
        calculate = function(self, card, context)
            if
                (context.joker_main
                and next(context.poker_hands[card.ability.extra.poker_hand]))
                or context.forcetrigger
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
            end
        end,
        demicoloncompat = true,
    }
}
