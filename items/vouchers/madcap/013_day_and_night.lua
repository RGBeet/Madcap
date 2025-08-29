return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(3,0),
        atlas   = 'vouchers',
        key 	= "day_and_night",
        cost 	= 6,
        loc_vars = function(self, info_queue)
            return { vars = { G.GAME.subhand_minimum or 5 } }
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.set_subhand('light',true)
                Madcap.Funcs.set_subhand('dark',true)
                return true
            end)
        end,
    }
}
