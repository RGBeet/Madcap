return {
    categories = {
        'New Suits',
        'Mayhem'
    },
    data = {
        object_type = 'Blind',
        key     = 'spiral',
        atlas   = "blinds",
        pos     = MLIB.coords(22),
        min_ante = 3,
        boss_colour = HEX('5F579D'),
        in_pool = function(self)
            return G,playing_cards 
                and #MadLib.get_list_matches(G.playing_cards, function(v) 
                    return v:is_suit('rgmc_lanterns') 
                end) > 4
        end,
        debuff = { suit = 'rgmc_lanterns' },
    }
}
