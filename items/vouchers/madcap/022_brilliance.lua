return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(4,1),
        atlas   = 'vouchers',
        key 	= "brilliance",
        cost 	= 9,
        requires = MadLib.get_voucher_reqs('rgmc_radiance'),
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.evolve_subhand('dazzling', 1)
                return true
            end)
        end,
    }
}
