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
                    v:is_suit('rgmc_voids') 
                end) > 4 or Madcap.Data.devmode
        end,
        debuff = { suit = 'rgmc_lanterns' },
    }
}
