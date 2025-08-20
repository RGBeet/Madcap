return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(2,2),
        atlas   = 'vouchers',
        key 	= "cosma_merchant",
        cost 	= 9,
        config 	= { extra = 2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours( number_format(card.ability.extra), { G.C.SET.CosmaTarot })
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                G.GAME.cosma_rate = (G.GAME.cosma_rate or 3) * self.config.extra
                return true
            end)
        end,
    }
}
