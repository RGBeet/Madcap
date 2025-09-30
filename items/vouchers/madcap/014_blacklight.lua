return {
    categories = {
        'Subhands'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(3,1),
        atlas   = 'vouchers',
        key 	= "blacklight",
        cost 	= 5,
        loc_vars = function(self, info_queue)
            return { vars = { G.GAME.subhand_minimum or 5 } }
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                Madcap.Funcs.set_subhand('ml_sh_dark',true)
                return true
            end)
        end,
    }
}
