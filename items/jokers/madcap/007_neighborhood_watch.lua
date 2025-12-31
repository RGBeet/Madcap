local calc_func = function(self, card, context)
    if context.setting_blind then
        card.ability.extra.money = 0
    end

    if context.end_of_round -- at end of round, check hand for target card
        and context.cardarea == G.hand
        and not context.repetition
        and not context.blueprint
        and context.other_card
        and MadLib.is_rank(context.other_card, G.GAME.current_round.rgmc_edwin_card.rank)
        and context.other_card:is_suit(G.GAME.current_round.rgmc_edwin_card.suit)
    then -- has both suit and rank 
        if context.other_card.debuff then -- don't count debuffed cards haha
            return { message = localize('k_debuffed'), colour = G.C.RED, card = context.other_card }
        else
            card.ability.extra.money = MadLib.add(card.ability.extra.money, card.ability.extra.money_mod)
            SMODS.scale_card(card, {
				ref_table       = card.ability.extra,
				ref_value       = "money",
				scalar_value    = "money_mod",
				message_key     = "a_chips",
				message_colour  = G.C.MONEY,
			})
        end
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            return context.end_of_round -- at end of round, check hand for target card
                and context.cardarea == G.hand
                and context.other_card
                and MadLib.is_rank(context.other_card, G.GAME.current_round.rgmc_edwin_card.rank)
                and context.other_card:is_suit(G.GAME.current_round.rgmc_edwin_card.suit)
        end
        if context.forcetrigger then -- add more cashout money
            card.ability.extra.money = MadLib.add(card.ability.extra.money, card.ability.extra.money_mod)
            SMODS.scale_card(card, {
				ref_table       = card.ability.extra,
				ref_value       = "money",
				scalar_value    = "money_mod",
				message_key     = "a_chips",
				message_colour  = G.C.MONEY,
			})
        end
        return calc_func_ref(self, card, context)
    end
end

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
        calculate = calc_func,
        demicoloncompat = true,
        demicoloncheck  = true
    },
}
