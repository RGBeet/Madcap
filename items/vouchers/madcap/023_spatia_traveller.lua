return {
    categories = {
        'Spatia Planets',
        'Potentia Crystals'
    },
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(8,2),
        atlas   = 'vouchers',
        key 	= "spatia_traveller",
        cost 	= 7,
        config 	= { extra = 2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours( number_format(card.ability.extra), { G.C.SET.SpatiaPlanet })
        end,
        redeem 	= function(self)
            MadLib.simple_event(function()
                G.GAME.spatia_rate = (G.GAME.spatia_rate or 1) * self.config.extra
                return true
            end)
        end,
    }
}
