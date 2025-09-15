return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(1,0),
        atlas       = 'vouchers',
        key 		= "big_bonus",
        cost 		= 5,
        config 		= { extra = 8 },
        redeem 		= function(self)
        end,
        loc_vars 	= function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra))
        end,
        calculate = function (self, card, context)
            if -- the scored enhancement is on the chip enhancement list
                context.cardarea == G.play
                and context.individual
                and context.other_card
                and MadLib.list_matches_one(Madcap.Lists.Enhancements.Chips, function(v,k)
                    return SMODS.has_enhancement(context.other_card, "m_"..v)
                end)
            then
                local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
                return { chips = card.ability.extra * to_number(G.GAME.hands[text].level) }
            end
        end
    }
}
