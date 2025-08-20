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
