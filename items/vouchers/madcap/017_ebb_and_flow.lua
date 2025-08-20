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
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.set_subhand('high',true)
                Madcap.Funcs.set_subhand('low',true)
                return true
            end)
        end,
    }
}
