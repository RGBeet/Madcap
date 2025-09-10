return {
    categories = {
        'Unfinished Content',
        'OP Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'banana_split',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = { 
            extra = { 
                odds = 100,
                x_mult = 3.5
            } 
        },
        loc_vars = function(self, info_queue, card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'banana_split')
            return { vars = { card.ability.extra.x_mult, numerator, denominator } }
        end,
        calculate = function(self, card, context)
            
            if 
                (context.end_of_round and context.game_over == false)
                and context.main_eval 
                and not context.blueprint 
            then
                if SMODS.pseudorandom_probability(card, 'banana_split', 1, card.ability.extra.odds) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return { message = localize('k_eaten_ex') }
                else
                    return { message = localize('k_safe_ex') }
                end
            end

            if context.initial_scoring_step then
                return { xmult = card.ability.extra.x_mult }
            end
        end,
    }
}
