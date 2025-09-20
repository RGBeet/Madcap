return {
    categories = {
        'Poker Hands'
    },
    data = {
        object_type = "Joker",
        key     = 'formation',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,7),
        rarity  = 3,
        cost    = 9,
        config =  {
            extra = { x_mult = 2.5, poker_hand = 'rgnc_pyramid' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.x_mult, card.ability.extra.type)
        end,
        calculate = function(self, card, context)
            if 
                (context.joker_main
                    and next(context.poker_hands[card.ability.poker_hand])) 
                or context.forcetrigger 
            then 
                return { xmult = card.ability.extra.x_mult }
            end
        end,
        in_pool = function(self, args) -- can play at least 6 cards
            return G.hand and G.hand.config.highlighted_limit > 5
        end,
        demicoloncompat = true,
    }
}
