return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_medium',
        atlas   = 'sinister',
        pos 	= MLIB.coords(1,4),
        cost 	= 2,
        config	= { extra = { rounds = 2, slots = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.rounds, card.ability.extra.slots)
        end,
        can_use = function(self, card)
            return true
        end,
        use 	= function(self, card, area, copier)
            Madcap.Funcs.add_sinister('medium', self.config.extra.rounds or 2, 'consumeable', self.config.extra.slots or 1)
        end
    }
}
