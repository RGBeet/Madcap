return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key     = "hexing",
        atlas   = 'decks',
        pos     = MLIB.coords(0,1),
        config = {
            starting_suits = { 'Hearts', 'Spades', 'Diamonds', 'Clubs', 'rgmc_goblets', 'rgmc_towers' },
            starting_ranks = { '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'}
        },
        apply = function(self)
            Madcap.Funcs.init_deck('hexing', { finishers = { 'bl_rgmc_final_chimes' }})
        end
    }
}
