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
            if (context.joker_main and next(context.poker_hands[card.ability.poker_hand])) or context.forcetrigger then return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult) end
        end,
        demicoloncompat = true,
    }
}
