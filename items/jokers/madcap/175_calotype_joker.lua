return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'calotype_joker',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 10,
        config = { 
            extra = { odds = 31, base_odds = 31 } 
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'calotype_joker')
            return MadLib.collect_vars(number_format(numer),
                number_format(denom))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and not context.blueprint
                and context.cardarea == G.play
                and (context.other_card
                and not context.other_card.edition ~= nil
                and not (context.other_card.edition ~= nil and context.other_card.edition.negative))
            then
                if SMODS.pseudorandom_probability(card, 'calotype_joker', 1, card.ability.extra.odds) then
                    card.ability.extra.odds = card.ability.extra.base_odds
                    MadLib.simple_event(function()
                        context.other_card:set_edition({ negative = true }, true)
                        return true
                    end, 1.0, 'after')
                    return {
                        message = localize('k_reset'),
                        colour  = G.C.FILTER
                    }
                else
                    card.ability.extra.odds = card.ability.extra.odds - 1
                end
            end
        end,
    },
}
