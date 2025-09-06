-- Hand must contain at least three different suits.
return {
    data = {
        object_type = 'Blind',
        key     = 'final_hoop',
        atlas   = "blinds",
        pos     = MLIB.coords(16),
        dollars = 8,
        boss_colour = HEX('712B9F'),
        config = { extra = { min_suits = 3 } },
        in_pool = function(self)
            return MadLib.get_num_suits(G.playing_cards) > 3 or Madcap.Data.devmode
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(self.config.extra.min_suits or 3)
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            local trigger = not G.GAME.blind.disabled and (MadLib.get_num_suits(cards) < self.config.extra.min_suits) or false
            return trigger
        end,
    }
}
