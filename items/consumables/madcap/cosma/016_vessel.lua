return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "vessel",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,5),
        cost 	= 7,
        config	= { select = 2, extra = 1.25},
        can_use = function(self, card)
            return G.hand and #G.hand.cards > 0
        end,
        use = function (self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, nil, function(v)
                Madcap.Funcs.mayhemize(v, {
                    force_values 	= true,
                    min_mult 		= self.config.extra or 1.25,
                    max_mult 		= self.config.extra or 1.25
                }, false)
            end)
        end
    }
}
