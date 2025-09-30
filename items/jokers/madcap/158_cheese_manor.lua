return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'cheese_manor',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = {
            extra = { poker_hand = 'High Card' }
        },
        loc_vars = function(self, info_queue, card)
            local hand_mult = (G.GAME.hands and G.GAME.hands[card.ability.extra.poker_hand]) 
                and math.max(1, G.GAME.hands[card.ability.extra.poker_hand].mult/2)
                or 1
                
            return MadLib.collect_vars(
                localize(card.ability.extra.poker_hand, 'poker_hands'),
                number_format(hand_mult))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                local hand_mult = (G.GAME.hands and G.GAME.hands[card.ability.extra.poker_hand]) 
                and math.max(1, G.GAME.hands[card.ability.extra.poker_hand].mult/2)
                or 1
                return { mult = hand_mult }
            end

            if context.after then
                MadLib.simple_event(function()
                    card.ability.extra.poker_hand = context.scoring_name 
                    return true
                end, 0, 'after')
            end
        end,
        demicoloncompat = true
    },
}
