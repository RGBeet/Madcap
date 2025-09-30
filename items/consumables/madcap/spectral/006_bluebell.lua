return {
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "bluebell",
        atlas   = "spectrals",
        pos     = MLIB.coords(0,5),
        cost = 4,
        config  = { extra = { add = 2 } },
        in_pool = function(self)
            return G.GAME.temporary_hands and G.GAME.temporary_hands < 8
        end,
        can_use = function(self, card)
            return (G.GAME.temporary_hands + card.ability.extra.add) <= 8
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.add)
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.ease_temp_hands(card.ability.extra.add, false, false)
        end,
    }
}
