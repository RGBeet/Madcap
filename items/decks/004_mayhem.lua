return {
    categories = {
        'Decks',
        'Mayhem'
    },
    data = {
        object_type = "Back",
        key     = "mayhem",
        atlas   = 'decks',
        pos     = MLIB.coords(1,0),
        config  = { mayhem = 50, mayhem_scale = 2, void_suit_spawn = 2 },
        loc_vars = function(self)
            return { vars = { self.config.mayhem, self.config.mayhem_scale, self.config.void_suit_spawn } }
        end,
        apply = function(self, back)
            G.GAME.modifiers.rgmc_deck = true  -- music activated
            G.GAME.starting_params.add_mayhem = self.config.mayhem
        end,
    }
}
