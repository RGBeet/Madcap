return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'coke_a_coal',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 7,
        config = { extra = { x_mult = 1.5 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'coke_a_coal')
            return MadLib.collect_vars(_numer, _denom, number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            if 
                context.individual
                and context.cardarea == G.hand
                and SMODS.has_enhancement(context.other_card, 'm_rgmc_ferrous')
            then
                return { xmult = card.ability.extra.x_mult }
            end
        end,
    },
}
