return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key         = "hexing",
        atlas       = 'decks',
        pos         = MLIB.coords(0,1),
		config      = MadLib.deep_copy(Madcap.DeckConfigs.hexing.base),
        loc_vars    = function(self)
            return MadLib.collect_vars_colours(
                localize(self.config.starting_suits[5], 'suits_plural'),
                localize(self.config.starting_suits[6], 'suits_plural'),
                { 
                    G.C.SUITS[self.config.starting_suits[5]],
                    G.C.SUITS[self.config.starting_suits[6]]
                })
        end,
        apply = function(self)
            Madcap.Funcs.init_deck('hexing', { finishers = { 'bl_rgmc_final_chimes' }})
            G.GAME.Exotic = true -- Exotic Suits show up!
        end
    }
}
