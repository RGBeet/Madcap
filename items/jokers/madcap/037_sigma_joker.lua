return {
    data = {
        object_type = "Joker",
        key     = 'sigma_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,6),
        rarity  = 2,
        cost    = 6,
        config =  {
            extra = { rank = 'rgmc_Sum', xchip_mod = 0.1 }
        },
        loc_vars = function(self, info_queue, card)

            -- not highlighted
            local sigma_sum

            if G.hand then
                local selected = MadLib.get_list_matches(G.hand.cards, function(v)
                    return Madcap.Funcs.card_in_list(v,G.hand.highlighted)
                end)
                sigma_sum = selected and to_big(Madcap.Funcs.get_sigma_value(selected))
            end

            local final_xchips = 1 + ((sigma_sum or 0) * card.ability.extra.xchip_mod)
            return MadLib.collect_vars(
                localize(card.ability.extra.rank,'ranks'),
                number_format(card.ability.extra.xchip_mod),
                "~"..number_format(final_xchips))
        end,
        calculate = function(self, card, context)

            -- held in hand stuff
            if
                context.individual
                and not context.end_of_round
                and context.cardarea == G.hand
                and context.other_card
                and Madcap.Funcs.get_card_key(context.other_card, "rgmc_Sum")
            then
                return not context.other_card.debuff
                    and do_sigma_joker(self,card,context)
                    or MadLib.get_debuff_data(card)
            end

            if context.forcetrigger then
                return do_sigma_joker(self,card,context)
            end
        end,
        demicoloncompat = true,
    },
}
