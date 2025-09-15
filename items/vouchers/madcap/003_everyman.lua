return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(0,2),
        atlas       = 'vouchers',
        key 		= "everyman",
        cost 		= 6,
        config 		= { extra = 1.1 },
        redeem 		= function(self)
        end,
        loc_vars 	= function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra))
        end,
        calculate 	= function (self, card, context)
            if 
                context.other_joker
                and context.other_joker.config.center.rarity == 1 -- common
            then
                return { 
                    xscore          = self.config.extra,
                    message_card    = context.other_joker
                }
            end
        end,
    }
}
