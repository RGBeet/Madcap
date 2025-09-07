-- thorium joker conversions
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
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vari_seala')
            return MadLib.collect_vars(
                    number_format(_numer),
                    number_format(_denom),
                    number_format(card.ability.extra.mult_mod),
                    number_format(card.ability.extra.mult))
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
                    return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult_mod)
                end
            end

            -- give the mult
            if
                (context.joker_main or context.forcetrigger)
                and MadLib.is_positive(card.ability.extra.mult)
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, card, card.ability.extra.mult)
            end

            -- reset at end of ante
            if
                context.end_of_round
                and not context.individual
                and not context.repetition
                and G.GAME.round % Madcap.Funcs.get_blinds_per_ante() == 0
            then
                return MadLib.get_simple_reset_data(MadLib.ScoreKeys.AddMult, card, 'mult')
            end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    },
    in_pool = function(self, args) -- "Exotic suits" enabled
        return G.GAME.Exotic
    end
}
