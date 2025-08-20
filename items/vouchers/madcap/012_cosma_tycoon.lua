return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(2,3),
        atlas   = 'vouchers',
        key 	= "cosma_tycoon",
        cost 	= 9,
        requires 	= MadLib.get_voucher_reqs('rgmc_cosma_merchant'),
        config 	= { extra = 4 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours( number_format(card.ability.extra), { G.C.SET.CosmaTarot })
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                G.GAME.cosma_rate = (G.GAME.cosma_rate or 6) * math.floor(self.config.extra/2)
                return true
            end)
        end,
    }
}
