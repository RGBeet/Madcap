return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key 	= 'anti_talisman',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,3),
        cost 	= 2,
        config	= { extra = { rounds = 2, money = 10  } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.rounds, card.ability.extra.money)
        end,
        can_use = function(self, card)
            return true -- always
        end,
        use 	= function(self, card, area, copier)
            play_sound('timpani')
            Madcap.Funcs.add_sinister('talisman', self.config.extra.rounds or 2, 'money', self.config.extra.money or 10)
        end
    }
}
