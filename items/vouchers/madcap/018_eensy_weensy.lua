return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(5,1),
        atlas   = 'vouchers',
        key 	= "eensy_weensy",
        cost 	= 7,
        requires = MadLib.get_voucher_reqs('rgmc_ebb_and_flow'),
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.evolve_subhand('low', 1)
                return true
            end)
        end,
    }
}
