return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(0,2),
        atlas       = 'vouchers',
        key 		= "exceptional",
        cost 		= 11,
        requires 	= MadLib.get_voucher_reqs('rgmc_everyman'),
        config 		= { extra = 1.01 },
        redeem 		= function(self)
        end,
        loc_vars 	= function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra))
        end,
        calculate 	= function (self, card, context)
            if context.after then
                local commons = Madcap.Funcs.get_common_jokers()
                if commons > 0 then return MadLib.do_e_score(card.ability.extra, commons) end
            end
        end,
    }
}
