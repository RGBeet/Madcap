return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key     = "sangria",
        atlas   = 'decks',
        pos     = MLIB.coords(0,2),
        config = {
            starting_suits = {'rgmc_goblets','rgmc_towers'}, -- new suits!
            starting_suits_doubles = true -- 2 of each suit/rank combo
        },
        apply = function(self)
            Madcap.Funcs.init_deck('sangria', {
                finishers       = { 'bl_rgmc_final_moon' } -- force Macchiato Moon
            })
            G.GAME.Exotic = true -- Exotic Suits show up!
            Madcap.Funcs.set_subhand('dark',true)
        end
    }
}
