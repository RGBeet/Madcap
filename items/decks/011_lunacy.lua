return {
    categories = {
        'Decks',
        'Mayhem'
    },
    data = {
        object_type = "Back",
        key     = "lunacy",
        atlas   = 'deck_lunacy',
        pos     = MLIB.coords(0,0),
        config = { finisher_frequency = 3, ante_win = 12 },
        loc_vars = function(self)
            return { vars = { self.config.mayhem, self.config.mayhem_scale, self.config.void_suit_spawn } }
        end,
        loc_vars = function(self)
            return MadLib.collect_vars(self.config.finisher_frequency, self.config.ante_win)
        end,
        apply = function(self, back)
            G.GAME.modifiers.rgmc_deck      = true  -- music activated
            G.GAME.modifiers.rgmc_lunacy    = true
            G.GAME.mayhem = 10
        end,
        calculate = function(self, card, context)
        end
    }
}
