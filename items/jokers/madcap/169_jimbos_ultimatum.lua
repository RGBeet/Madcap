function MadLib.get_highest_rank(cards)
    local highest_nominal = -9999
    local highest_rank = nil
    
    for i=1, #cards do
        if not SMODS.has_no_rank(cards[i]) then
            local rank = SMODS.Ranks[cards[i]:get_id()]
            local nominal = rank.base.nominal + rank.base.face_nominal
            
            if nominal > highest_nominal then
                highest_nominal = nominal
                highest_rank    = rank.key
            end
        end
    end

    return highest_rank, highest_nominal
end

function MadLib.get_lowest_rank(cards)
    local lowest_nominal = 9999
    local lowest_rank = nil
    
    for i=1, #cards do
        if not SMODS.has_no_rank(cards[i]) then
            local rank = SMODS.Ranks[cards[i]:get_id()]
            local nominal = rank.base.nominal + rank.base.face_nominal
            
            if nominal < highest_nominal then
                lowest_nominal = nominal
                lowest_rank    = rank.key
            end
        end
    end

    return lowest_rank, lowest_nominal
end

return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'jimbos_ultimatum',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 7,
        config = { 
            extra = { odds = 3 } 
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'jimbos_ultimatum')
            return MadLib.collect_vars(
                number_format(numer),
                number_format(denom))
        end,
        calculate = function(self, card, context)
            if 
                context.before
                and not (context.blueprint or context.retrigger_joker)
                and #context.full_hand == 1
                and G.GAME.current_round.hands_played == 0
                and (G.hand and #G.hand.cards > 0)
            then
                local rank = SMODS.pseudorandom_probability(card, 'jimbos_ultimatum', 1, card.ability.extra.odds)
                    and MadLib.get_highest_rank(G.hand.cards)
                    or MadLib.get_lowest_rank(G.hand.cards)
                
                MadLib.simple_event(function()
                    context.full_hand[1]:flip()
                    return true
                end, 1.0, 'after')
                MadLib.simple_event(function()
                    assert(SMODS.change_base(context.full_hand[1], _, rank))
                    context.full_hand[1]:juice_up()
                    return true
                end, 0.0, 'after')
                MadLib.simple_event(function()
                    context.full_hand[1]:flip()
                    return true
                end, 1.0, 'after')
            end
        end,
    },
}
