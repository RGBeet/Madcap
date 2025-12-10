return {
    data = {
        object_type = "Joker",
        key     = 'neighborhood_watch',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,6),
        rarity  = 1,
        cost    = 4,
        config =  {
            extra = { money_mod = 2, money = 0, },
        },
        loc_vars = function(self, info_queue, card)
            local vars = MadLib.collect_vars_colours(
                    number_format(card.ability.extra.money_mod),
                    localize(Madcap.Funcs.safe_get(G.GAME, "current_round", "rgmc_edwin_card", "rank") or "5", "ranks"),
                    localize(G.GAME.current_round.rgmc_edwin_card
                        and G.GAME.current_round.rgmc_edwin_card.suit
                        or "Diamonds", "suits_plural"),
                    { G.C.SUITS[G.GAME.current_round.rgmc_edwin_card and G.GAME.current_round.rgmc_edwin_card.suit or "Diamonds"] })
            return vars
        end,
        calc_dollar_bonus = function(self, card)
            return MadLib.get_calc_bonus(card.ability.extra.money)
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                card.ability.extra.money = 0
            end

            if context.end_of_round -- at end of round, check hand for target card
                and context.cardarea == G.hand
                and not context.repetition
                and not context.blueprint
                and context.other_card
                and MadLib.is_rank(context.other_card, G.GAME.current_round.rgmc_edwin_card.id)
                and context.other_card:is_suit(G.GAME.current_round.rgmc_edwin_card.suit)
            then -- has both suit and rank
                if context.other_card.debuff then -- don't count debuffed cards haha
                    return MadLib.get_debuff_data(card) --TODO: remove this
                else
                    card.ability.extra.money = MadLib.add(card.ability.extra.money, card.ability.extra.money_mod)
                    card_eval_status_text(card, "extra", nil, nil, nil, { message = "Edwin!" })
                    return nil, true
                end
            end
        end,
        demicoloncompat = true,
    },
}
