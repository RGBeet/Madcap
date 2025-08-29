return {
    categories = {
        'Decks',
        'Subhands',
        'Spatia Planets'
    },
    data = {
        object_type = "Back",
        key     = "beetroot",
        atlas   = 'decks',
        pos     = MLIB.coords(2,3),
        config = { likeliness = 3 },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.likeliness } }
        end,
        apply = function (self, back)
            G.GAME.madcap_content_rate = 15 * self.config.likeliness
        end
    }
}
