return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(5,3),
        atlas   = 'vouchers',
        key 	= "median",
        cost 	= 7,
        requires = MadLib.get_voucher_reqs('rgmc_ebb_and_flow','rgmc_eensy_weensy','rgmc_extra_large'),
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.evolve_subhand('high', 1)
                Madcap.Funcs.evolve_subhand('low', 1)
                return true
            end)
        end,
    }
}
