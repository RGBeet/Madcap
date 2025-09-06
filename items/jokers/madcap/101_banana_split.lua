return {
    categories = {
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
                odds = 1000,
                x_mult = 5
            } 
        },
        loc_vars = function(self, info_queue, card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vremade_cavendish')
            return { vars = { card.ability.extra.Xmult, numerator, denominator } }
        end,
        calculate = function(self, card, context)
            if 
                (context.end_of_round and context.game_over == false)
                and context.main_eval 
                and not context.blueprint 
            then
                if SMODS.pseudorandom_probability(card, 'banana_split', 1, card.ability.extra.odds) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return { message = localize('k_extinct_ex') }
                else
                    return { message = localize('k_safe_ex') }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
        in_pool = function(self, args)
            return G.GAME.pool_flags.gros_michel_extinct
        end
    }
}
