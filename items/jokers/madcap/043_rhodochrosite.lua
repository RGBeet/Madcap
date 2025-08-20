return {
    data = {
        object_type = "Joker",
        key     = 'rhodochrosite',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,2),
        rarity  = 3,
        cost    = 8,
        config =  {
            active = false,
            extra = { mult = 6, chips = 30, suits = { "Diamonds", "Spades", "Clubs" } }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suits[1], 'suits_plural'),
                localize(card.ability.extra.suits[2], 'suits_plural'),
                localize(card.ability.extra.suits[3], 'suits_plural'),
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.chips),
            {
                G.C.SUITS[card.ability.extra.suits[1]],
                G.C.SUITS[card.ability.extra.suits[2]],
                G.C.SUITS[card.ability.extra.suits[3]]
            })
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.play
                and context.other_card
                and not context.after
                and not context.before
                and not context.blueprint
            then
                if -- clubs or spades activates
                    context.other_card:is_suit(card.ability.extra.suits[1]) -- Diamonds
                then
                    local active = nil -- needs a diamond suit to activate
                    for i=1,#context.scoring_hand do
                    -- if club or spade suit
                        if context.scoring_hand[i] == context.other_card then
                            break -- bruh it's the same damn card
                        else
                            active = (context.scoring_hand[i]:is_suit(card.ability.extra.suits[2])
                                    and card.ability.extra.suits[2])
                                    or (context.scoring_hand[i]:is_suit(card.ability.extra.suits[3])
                                    and card.ability.extra.suits[3])
                            if active then
                                break -- we are done here
                            end
                        end
                    end
                    if active == card.ability.extra.suits[2] then
                        return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
                    elseif active == card.ability.extra.suits[3] then
                        return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
                    end
                end
            end

            if context.forcetrigger then
                MadLib.simple_event(function()
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
                end, 0.3, 'immediate')
                MadLib.simple_event(function()
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
                end, 0.3, 'immediate')
            end
        end,
        demicoloncompat = true,
    }
}
