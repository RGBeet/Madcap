return {
    categories = {
        'New Suits'
    },
    data = {
        object_type = 'Blind',
        key     = 'sword',
        atlas   = "blinds",
        pos     = MLIB.coords(1),
        boss_colour = HEX('435B8C'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v) v:is_suit('rgmc_towers') end) > 4 or Madcap.Data.devmode
        end,
        debuff = { suit = 'rgmc_towers' },
    }
}
