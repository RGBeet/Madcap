return {
    categories = {
        'Unreleased',
        'Suits' -- requires new suits to load
    },
    data = {
        object_type = "Joker",
        key     = 'point_and_click',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = {
            extra = { suit = 'rgmc_daggers' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suit, 'suits_singular'),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            if context.destroy_card then
                if 
                    not (context.blueprint or context.retrigger_joker)
                    and #context.full_hand == 1 
                    and context.destroy_card == context.full_hand[1] 
                    and context.full_hand[1]:is_suit(card.ability.extra.suit)
                    and G.GAME.current_round.hands_played == 0 
                then
                    local target = MadLib.shuffle_sort_list(G.hand.cards, 1, function(v)
                        return not SMODS.is_eternal(v)
                    end)

                    MadLib.loop_func(target, function(v)
                        v.point_and_click_removed = true
                    end)
                end
            end

            if context.destroy_card and context.destroy_card.point_and_click_removed then
                return { remove = true }
            end
        end,
        demicoloncompat = true,
    },
}
