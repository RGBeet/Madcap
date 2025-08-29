return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(3,3),
        atlas   = 'vouchers',
        key 	= "twilight",
        cost 	= 11,
        loc_vars = function(self, info_queue)
            return { vars = { G.GAME.subhand_minimum or 5 } }
        end,
        requires = MadLib.get_voucher_reqs('rgmc_day_and_night','rgmc_midday','rgmc_midnight'),
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.evolve_subhand('dark', 1)
                Madcap.Funcs.evolve_subhand('light', 1)
                return true
            end)
        end,
    }
}
