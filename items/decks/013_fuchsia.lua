return {
    categories = {
        'Decks',
        'Temp Hands'
    },
    data = {
        object_type = "Back",
        key     = "fuchsia",
        atlas   = 'decks',
        pos     = MLIB.coords(2,4),
        config  = { hands = 2, discards = -2, temp_hands = 4, temp_discards = 4},
        loc_vars = function(self, info_queue, back)
            return { vars = { self.config.lp_start, self.config.lp_boss_bonus } }
        end,
        apply = function(self, back)
            Madcap.Funcs.init_deck('argentum')
            G.GAME.starting_params.temp_hands       = 5
            G.GAME.starting_params.temp_discards    = 5
        end,
    }
}
