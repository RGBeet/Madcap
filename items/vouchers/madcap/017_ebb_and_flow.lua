return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(5,0),
        atlas   = 'vouchers',
        key 	= "ebb_and_flow",
        cost 	= 5,
        loc_vars = function(self, info_queue)
            return { vars = { G.GAME.subhand_minimum or 5 } }
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.set_subhand('high',true)
                Madcap.Funcs.set_subhand('low',true)
                return true
            end)
        end,
    }
}
