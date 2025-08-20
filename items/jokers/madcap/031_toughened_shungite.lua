-- thorium joker conversions
return {
    data = {
        object_type = "Joker",
        key     = 'toughened_shungite',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,0),
        rarity  = 2,
        cost    = 7,
        config =  {
            extra = { odds = 4, chips = 0, chip_mod = 15, suit = 'rgmc_towers' }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vari_seala')
            return MadLib.collect_vars(
                    number_format(_numer),
                    number_format(_denom),
                    number_format(card.ability.extra.chip_mod),
                    number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            -- scaling
            if
                context.cardarea == G.play
                and context.individual
            then
                if
                    context.other_card:is_suit(card.ability.extra.suit)
                    and SMODS.pseudorandom_probability(card, 'toughened_shungite', 1, card.ability.extra.odds)
                then
                    return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
                end
            end

            -- give the mult
            if
                (context.joker_main or context.forcetrigger)
                and MadLib.is_positive(card.ability.extra.chips)
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chips)
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
}
