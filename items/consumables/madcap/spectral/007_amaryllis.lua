return {
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "amaryllis",
        atlas   = "spectrals",
        pos     = MLIB.coords(1,0),
        cost    = 4,
        config  = { extra = { add = 1 } },
        in_pool = function(self)
            return G.GAME.temporary_discards and G.GAME.temporary_discards < 8
        end,
        can_use = function(self, card)
            return (G.GAME.temporary_discards + card.ability.extra.add) <= 8
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.add)
        end,
        use = function(self, card, area, copier)
            attention_text({ scale = 0.7, text = words, maxw = 12, hold = Madcap.Funcs.get_default_attention_hold(localize("rgmc_temp_discards_plus")), align = 'cm', offset = {x = 0, y = -1}, major = G.play })
            G.GAME.temporary_discards = math.min(G.GAME.temporary_discards + card.ability.extra.add, 8)
        end,
    }
}
