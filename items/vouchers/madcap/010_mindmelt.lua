return {
    categories = {
        'Mayhem'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(2,1),
        atlas   = 'vouchers',
        key 	= "mindmelt",
        cost 	= 9,
        requires = MadLib.get_voucher_reqs('rgmc_manifest'),
        config  = { extra = { antes = 2, mayhem = 4 }, immutable = { max_antes = 25 } },
        loc_vars 	= function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(Madcap.Funcs.clamp_mayhem(card.ability.extra.mayhem)),
                number_format(MadLib.clamp(card.ability.extra.antes, 1, card.ability.immutable.max_antes))
            )
        end,
        redeem 		= function(self)
            Madcap.Funcs.ease_mayhem(Madcap.Funcs.clamp_mayhem(self.config.extra.mayhem or 1))
            ease_ante(self.config.extra.antes or 1)
        end,
    }
}
