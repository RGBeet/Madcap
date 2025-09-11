function Madcap.Funcs.action_replay_check(card, repetitions)
    if card.ability.extra.triggered then return false end
    if SMODS.pseudorandom_probability(card, 'action_replay', 1, card.ability.extra.odds) then
        card.ability.immutable.accumulated_repetitions = card.ability.immutable.accumulated_repetitions + (repetitions or 1)
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = "+1",
            instant = false,
            colour = G.C.GREEN,
            sound = 'tarot2'
        });
        return true
    end
    return nil
end

return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'action_replay',
        atlas   = 'jokers',
        pos     = MLIB.coords(14,1),
        rarity  = 'rgmc_unusual',
        cost    = 15,
        config  = {
            extra = { odds = 3, active = false, triggered = false },
            immutable = { accumulated_repetitions = 0 }
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'action_replay')
            return MadLib.collect_vars(number_format(numer), 
                number_format(denom),
                number_format(denom*3),
                number_format(card.ability.immutable.accumulated_repetitions))
        end,
        calculate = function(self, card, context)
            if 
                context.before
                and card.ability.extra.active
                and SMODS.pseudorandom_probability(card, 'action_replay', 1, card.ability.extra.odds * 3)
            then
                --tell('Action Replay triggered!')
                card.ability.extra.triggered = true
                return { message = "!", colour = G.C.ATTENTION }
            end

            if 
                context.repetition
                and card.ability.extra.triggered
                and context.scoring_hand
                and context.other_card == context.scoring_hand[#context.scoring_hand]
            then
                local reps = card.ability.immutable.accumulated_repetitions + 1
                tell('Target card repeated ' .. tostring(reps) .. ' times.')
                card.ability.immutable.accumulated_repetitions = 0
                return {
                    message = localize('k_again_ex'),
                    repetitions = reps,
                    card = context.other_card
                }
            end

            if context.after then
                if card.ability.extra.triggered then
                    card.ability.extra.active = false
                elseif 
                    card.ability.immutable.accumulated_repetitions > 0 
                    and not card.ability.extra.active 
                then 
                    --tell('Now active!')
                    card.ability.extra.active = true
                end
                if card.ability.extra.triggered then
                    card.ability.extra.triggered = false
                end
            end
        end,
        demicoloncompat = false,
    }
}
