return {
    data = {
        object_type = "Joker",
        key     = 'toga_rubber_duck',
        atlas   = 'toga_jokers',
        pos     = MLIB.coords(0,1),
        rarity  = 1,
        cost    = 6,
        config =  {
            extra = {
                mult_mod        = 1,
                mult            = 0
            },
            immutable = {
                score           = 0,
                stockpile       = 0,
            }
        },
        calculate = function(self, card, context)

            if context.forcetrigger_before then -- demicolon shenanigans?
                card.ability.immutable.stockpile = card.ability.immutable.stockpile + 1
            end

            if
                context.before
                and context.scoring_name
            then
                card.ability.extra.active_hand = context.scoring_name
                level_up_hand(context.blueprint_card or card, card.ability.extra.active_hand, nil, 1 + card.ability.immutable.stockpile)
            end

            if
                context.after
                and card.ability.extra.active_hand ~= nil
            then
                level_up_hand(context.blueprint_card or card, card.ability.extra.active_hand, nil, -(1 + card.ability.immutable.stockpile))
                card.ability.extra.active_hand      = nil
                card.ability.immutable.stockpile    = 0
            end
        end,
        loc_vars = function(self, info_queue, card)
            local score = math.min(card.ability.immutable.score, 1e300)
            return MadLib.collect_vars(number_format(card.ability.extra.mult_mod), number_format(card.ability.extra.mult), number_format(score))
        end,
        demicoloncompat = false,
    }
}
