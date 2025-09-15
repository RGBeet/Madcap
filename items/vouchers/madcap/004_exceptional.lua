return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(0,3),
        atlas       = 'vouchers',
        key 		= "exceptional",
        cost 		= 11,
        requires 	= MadLib.get_voucher_reqs('rgmc_everyman'),
        config 		= { extra = 1.02 },
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
                    escore          = self.config.extra,
                    message_card    = context.other_joker
                }
            end
        end,
    }
}
