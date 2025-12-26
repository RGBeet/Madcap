return {
    data = {
        object_type = "Joker",
        key     = 'plentiful_ametrine',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,9),
        rarity  = 2,
        cost    = 6,
        config =  {
            extra = { odds = 4, mult = 0, mult_mod = 4, suit = 'rgmc_goblets' }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'plentiful_ametrine')
            return MadLib.collect_vars_colours(
                number_format(_numer),
                number_format(_denom),
                number_format(card.ability.extra.mult_mod),
                number_format(card.ability.extra.mult),
                localize(Madcap.Funcs.get_joker_suit(card, 'rgmc_goblets'), 'suits_singular'),
                { G.C.SUITS[Madcap.Funcs.get_joker_suit(card, 'rgmc_goblets')] })
        end,
        calculate = function(self, card, context)
            -- scaling
            if
                context.cardarea == G.play
                and context.individual
            then
                if
                    context.other_card:is_suit(card.ability.extra.suit)
                    and SMODS.pseudorandom_probability(card, 'plentiful_ametrine', 1, card.ability.extra.odds)
                then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour  = G.C.MULT
                    }
                end
            end

            -- give the mult
            if
                (context.joker_main or context.forcetrigger)
                and card.ability.extra.mult > 0
            then
                return { mult = card.ability.extra.mult }
            end

            -- reset at end of ante
            if context.new_ante then
                card.ability.extra.mult = 0
                return {
                    message = localize('k_reset'),
                    colour  = G.C.FILTER
                }
            end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    },
    in_pool = function(self, args) -- "Exotic suits" enabled
        return G.GAME.Exotic
    end
}
