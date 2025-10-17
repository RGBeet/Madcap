
return {
    categories = {
        'New Poker Hands'
    },
    data = {
        object_type = "Joker",
        key     = 'bolstered_joker',
        atlas   = 'jokers',
        rarity  = 1,
        cost    = 4,
        pos     = MLIB.coords(5,4),
        config =  {
            extra = { mult = 20, poker_hand = 'rgmc_pyramid' }
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
                return { mult = card.ability.extra.mult, card = card }
            end
        end,
        in_pool = function(self, args) -- can play at least 6 cards
            return G.hand and G.hand.config.highlighted_limit > 5
        end,
        demicoloncompat = true,
    }
}
