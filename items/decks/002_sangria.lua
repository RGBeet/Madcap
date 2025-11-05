return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key         = "sangria",
        atlas       = 'decks',
        pos         = MLIB.coords(0,2),
        config      = MadLib.deep_copy(Madcap.DeckConfigs.sangria.base),
        loc_vars    = function(self)
            return MadLib.collect_vars_colours(
                localize(self.config.starting_suits[1], 'suits_plural'),
                localize(self.config.starting_suits[2], 'suits_plural'),
                number_format(26),
                { 
                    G.C.SUITS[self.config.starting_suits[1]],
                    G.C.SUITS[self.config.starting_suits[2]]
                })
        end,
        apply = function(self)
            Madcap.Funcs.init_deck('merlot', { finishers = { 'bl_rgmc_final_moon' } })
            G.GAME.Exotic = true -- Exotic Suits show up!
            Madcap.Funcs.set_subhand('light',true)
        end
    }
}
