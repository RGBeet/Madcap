return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'empowerer',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 6,
        config = { extra = { factor = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(G.GAME and G.GAME.potentias_used or 0))
        end,
    },
}
