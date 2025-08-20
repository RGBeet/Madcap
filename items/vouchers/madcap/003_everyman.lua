return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(0,3),
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
            if context.after then
                local commons = Madcap.Funcs.get_common_jokers()
                if commons > 0 then return MadLib.do_x_score(card.ability.extra, commons) end
            end
        end,
    }
}
