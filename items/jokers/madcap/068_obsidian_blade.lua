return {
    categories = {
        'New Suits'
    },
    data = {
        object_type = "Joker",
        key     = 'obsidian_blade',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,7),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = { odds = 4, x_mult = 1, xmult_mod = 0.2, suit = 'rgmc_daggers' }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suit, 'suits_singular'),
                number_format(_numer),
                number_format(_denom),
                number_format(card.ability.extra.xmult_mod),
                number_format(card.ability.extra.x_mult),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)
            -- upgrade
            if context.cardarea == G.play and context.individual and context.other_card:is_suit(card.ability.extra.suit) and SMODS.pseudorandom_probability(card, 'obsidian_blade', 1, card.ability.extra.odds) then return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.xmult_mod) end
            -- score
            if (context.cardarea == G.jokers and context.joker_main and card.ability.extra.x_mult ~= 1 and card.ability.extra.x_mult > 0) or context.forcetrigger then return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult) end
            -- reset at end of ante
            if not context.individual and context.end_of_round and G.GAME.blind.boss and not (context.blueprint or context.repetition) then return MadLib.get_simple_reset_data(MadLib.ScoreKeys.MultiMult, card, 'x_mult', 1) end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
