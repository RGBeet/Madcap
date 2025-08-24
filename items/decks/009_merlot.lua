return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key     = "merlot",
        atlas   = 'decks',
        pos     = MLIB.coords(1,3),
        config = {
            starting_suits = {'rgmc_blooms','rgmc_daggers'}, -- new suits!
            starting_suits_doubles = true -- 2 of each suit/rank combo
        },
        apply = function(self)
            Madcap.Funcs.init_deck('merlot', {
                finishers       = { 'bl_rgmc_final_moon' } -- force ???
            })
            G.GAME.Exotic = true -- Exotic Suits show up!
            Madcap.Funcs.set_subhand('dark',true)
        end
    }
}
