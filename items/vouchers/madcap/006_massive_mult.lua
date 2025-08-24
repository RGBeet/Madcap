return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(1,1),
        atlas       = 'vouchers',
        key 		= "massive_mult",
        cost 		= 7,
        requires 	= MadLib.get_voucher_reqs('rgmc_big_bonus'),
        config 		= { extra = 2 },
        redeem 		= function(self)
        end,
        loc_vars 	= function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra))
        end,
        calculate 	= function (self, card, context)
            if
                context.cardarea == G.play
                and context.individual
                and context.other_card
                and MadLib.list_matches_one(Madcap.Lists.Enhancements.Mult, function(v,k)
                    return SMODS.has_enhancement(context.other_card, "m_"..v)
                end)
            then
                local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
                local _mult = card.ability.extra * to_number(G.GAME.hands[text].level)

                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddMult, context.other_card, _mult)
            end
        end
    }
}
