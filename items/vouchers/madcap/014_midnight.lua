return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(3,2),
        atlas   = 'vouchers',
        key 	= "midnight",
        cost 	= 8,
        loc_vars = function(self, info_queue)
            return { vars = { G.GAME.subhand_minimum or 5 } }
        end,
        requires = MadLib.get_voucher_reqs('rgmc_day_and_night'),
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.set_subhand('dark',true)
                Madcap.Funcs.evolve_subhand('dark', 1)
                return true
            end)
        end,
    }
}
