return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(3,2),
        atlas   = 'vouchers',
        key 	= "kings_crown",
        cost 	= 5,
        loc_vars = function(self, info_queue)
            return { vars = { G.GAME.subhand_minimum or 5 } }
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.set_subhand('ml_sh_high',true)
                return true
            end)
        end,
    }
}
