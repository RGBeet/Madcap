return {
    categories = {
        'Decks',
    },
    data = {
        object_type     = "Back",
        key             = "micro",
        atlas           = 'decks',
        pos             = MLIB.coords(0,4),
        config          = MadLib.deep_copy(Madcap.DeckConfigs.micro.base),
        loc_vars        = function(self)
            return MadLib.collect_vars(self.config.hand_size, self.config.hand_play_limit, self.config.ante_scaling)
        end,
        apply = Madcap.DeckFuncs.micro.apply
    }
}
