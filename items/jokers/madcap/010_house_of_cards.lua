return {
    data = {
        object_type = "Joker",
        key     = 'house_of_cards',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,9),
        rarity  = 1,
        cost    = 3,
        config = {
            immutable = { odds = 6, increase = 0 }, -- if this was mutable, it would ruin the card
            extra = {
                chip_mod = 6,
                chips = 0
            }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1 + card.ability.immutable.increase, card.ability.immutable.odds, 'house_of_cards')
            return MadLib.collect_vars(number_format(card.ability.extra.chip_mod),
                number_format(_numer),
                number_format(_denom),
                number_format(card.ability.extra.chips),
                number_format(1))
        end,
        calculate = function(self, card, context)

            if context.discard then
                MadLib.event({
                    func = function()
                        card:juice_up()
                        if card.ability.immutable.increase < card.ability.immutable.odds then
                            card.ability.immutable.increase = card.ability.immutable.increase + 1
                        end
                        return true
                    end
                })
            end

            if -- upgrade!
                context.cardarea == G.jokers
                and (context.before or context.forcetrigger)
            then
                return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddChips, card, card.ability.extra.chip_mod)
            end

            if  -- the cards :)
                context.joker_main -- playing the hand
                and (to_big(card.ability.extra.chips) > to_big(0))
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips,card,card.ability.extra.chips)
            end

            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                if SMODS.pseudorandom_probability(card, 'house_of_cards', 1 + card.ability.immutable.increase, card.ability.immutable.odds) then
                    tell('Reset')
                    card.ability.immutable.increase = 0
                    return MadLib.get_simple_reset_data(MadLib.ScoreKeys.AddChips, card, 'chips')
                else
                    return MadLib.get_safe_data(card)
                end
            end
        end,
        perishable_compat   = false,
        demicoloncompat     = true,
    },
}
