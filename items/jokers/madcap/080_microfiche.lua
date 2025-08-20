return {
    categories = {
        'Small Ranks'
    },
    data = {
        object_type = "Joker",
        key     = 'microfiche',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,9),
        rarity  = 3,
        cost    = 8,
        config =  {
            extra = { x_mult = 1.0, xmult_mod  = 0.05 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.xmult_mod, card.ability.extra.x_mult)
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.individual and context.other_card
            then
                local rank = MadLib.get_value_from_id(context.other_card:get_id())
                --[[print(context.other_card:get_id())
                print(rank)
                print(rank and rank.nominal)]]
                local nominal = rank and rank.nominal or 3
                local irregular = MadLib.has_rank_in_list(MadLib.RankTypes.Irregular)
                -- Gain xmult
                if not irregular and nominal < 2 then return MadLib.get_simple_upgrade_data(MadLib.ScoreKeys.MultiMult, context.other_card, card.ability.extra.xmult_mod) end
            end
            if (context.joker_main or context.forcetrigger) and card.ability.extra.x_mult > 1 then return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult) end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
