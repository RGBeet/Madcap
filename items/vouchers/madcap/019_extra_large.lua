return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(5,2),
        atlas   = 'vouchers',
        key 	= "extra_large",
        cost 	= 7,
        loc_vars = function(self, info_queue)
            return { vars = { G.GAME.subhand_minimum or 5 } }
        end,
        requires = MadLib.get_voucher_reqs('rgmc_ebb_and_flow'),
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.evolve_subhand('high', 1)
                return true
            end)
        end,
    }
}
