function Madcap.Funcs.get_blackjack(hand, score)
    score = score or 21
    local total = MadLib.get_hand_sum(hand)
    local ace_count = MadLib.loop_func(hand, function(v)
        return MadLib.is_rank(v, SMODS.Ranks['Ace'].id)
    end)
    while total > 21 and ace_count > 0 do
        total = total - 10
        ace_count = ace_count - 1
    end
    return total == score
end

return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'joker_noir',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 9,
        config = { 
            extra = { x_mult = 3, destroy = 1 } 
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local blackjack = Madcap.Funcs.get_blackjack(context.scoring_hand)  
                if blackjack == 21 then
                    return { xmult   = card.ability.extra.x_mult }
                elseif 
                    blackjack > 21
                    and not context.blueprint 
                    and not context.retrigger_joker
                    and G.hand
                then
                    MadLib.loop_func(MadLib.shuffle_sort_list(G.hand.cards, card.ability.extra.destroy, function(v)
                        return not SMODS.is_eternal(v)
                    end), function(v)
                        card.joker_noir_removed = true
                    end)
                end
            end

            if context.destroy_card and context.destroy_card.joker_noir_removed then
                return {
                    remove = true
                }
            end
        end,
    },
}
