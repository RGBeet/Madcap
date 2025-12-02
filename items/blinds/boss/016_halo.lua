return {
    categories = {
        'New Suits',
        'Mayhem'
    },
    data = {
        object_type = 'Blind',
        key     = 'halo',
        atlas   = "blinds",
        pos     = MLIB.coords(21),
        min_ante = 3,
        boss_colour = HEX('FAB06D'),
        in_pool = function(self)
            return G,playing_cards 
                and #MadLib.get_list_matches(G.playing_cards, function(v) 
                    return v:is_suit('rgmc_voids')
                end) > 4
        end,
        debuff = { suit = 'rgmc_voids' },
    }
}
