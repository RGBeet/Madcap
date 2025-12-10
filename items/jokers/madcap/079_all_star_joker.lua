return {
    data = {
        object_type = "Joker",
        key     = 'all_star_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,8),
        rarity  = 3,
        cost    = 9,
        config = {
            extra = { money = 0, money_mod = 3 },
            immutable = { total_sum = 24 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.immutable.total_sum, card.ability.extra.money_mod, card.ability.extra.money)
        end,
        calc_dollar_bonus = function(self, card)
            if MadLib.is_positive_number(card.ability.extra.money) then
                local cash = lenient_bignum(card.ability.extra.money)
                card.ability.extra.money = 0
                return cash
            end
        end,
        calculate = function(self, card, context)
            if (context.before and MadLib.get_hand_sum(context.scoring_hand) == card.ability.immutable.total_sum) then
                MadLib.loop_func(G.jokers.cards, function(v)
                    MadLib.simple_event(function()
                        play_sound('tarot2', 1, 0.4)
                        v:juice_up(0.1, 0.3)
                        return true
                    end, 1.0, 'after')
                end)
                MadLib.simple_event(function()
                    play_sound('rgmc_all_star', 1, 0.4)
                    card:juice_up(0.2, 0.5)
                    --card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Hey Now!", colour = G.C.MONEY})
                    return true
                end, 3.5, 'after')
                return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.AddMoney, card, card.ability.extra.money_mod * #G.jokers.cards)
            end
            if context.forcetrigger then return MadLib.get_add_money_data(card) end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
