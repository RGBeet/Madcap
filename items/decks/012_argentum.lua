return {
    categories = {
        'Decks',
        'Luxury Points'
    },
    data = {
        object_type = "Back",
        key     = "argentum",
        atlas   = 'decks',
        pos     = MLIB.coords(2,3),
        config  = { rgmc_luxury_pts = 10 },
        loc_vars = function(self, info_queue, back)
            return { vars = { self.config.rgmc_luxury_pts } }
        end,
        apply = function(self, back)
            G.GAME.starting_params.rgmc_luxury_pts = self.config.dollars
        end,
    }
}
