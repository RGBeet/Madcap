return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "phoenix",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,5),
        cost 	= 5,
        config	= { select = 2, extra = 0.2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select), number_format(card.ability.extra))
        end,
        can_use = function(self, card)
            return G.hand and G.hand.cards and #G.hand.cards > 1
        end,
        use = function (self, card, area, copier)
            Madcap.Funcs.use_cosma(self, card, area, copier, self.config.select or 2, function(v)
                return true -- must have suit
            end, function(v)
                local _value = v.base.nominal/2
                v.ability.perma_chips   = (v.ability.perma_chips or 0) - _value
                v.ability.perma_mult 	= (v.ability.perma_mult or 0) + _value * (card.ability.extra or 0.2)
            end)
        end
    }
}
