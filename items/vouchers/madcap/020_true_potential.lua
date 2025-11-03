return {
    categories = {
        'Spatia Planets',
        'Potentia Crystals'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(4,3),
        atlas   = 'vouchers',
        key 	= "true_potential",
        cost 	= 9,
        config 	= { extra = 2 },
        requires = MadLib.get_voucher_reqs('rgmc_spatia_traveler'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours( number_format(card.ability.extra), { G.C.SET.SpatiaPlanet })
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                G.GAME.potentia_rate = self.config.extra
                return true
            end)
        end,
    }
}
