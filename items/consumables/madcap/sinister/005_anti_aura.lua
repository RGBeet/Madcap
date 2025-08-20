return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_aura',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,4),
        cost 	= 2,
        config	= { extra = { money = 2, rounds = 2} },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.rounds, card.ability.extra.money)
        end,
        can_use = function(self, card) -- at least one editioned playing card
            return MadLib.valid_table(MadLib.get_editioned_cards(G.playing_cards), 1)
        end,
        use 	= function(self, card, area, copier)
            play_sound('timpani')
            Madcap.Funcs.add_sinister('aura', self.config.extra.rounds or 2)
            ease_dollars(#MadLib.get_editioned_cards(G.playing_cards) * (self.config.extra.money or 2))
        end
    }
}
