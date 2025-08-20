return {
    categories = {
        'New Suits'
    },
    data = {
        object_type = 'Blind',
        key     = 'rust',
        atlas   = "blinds",
        pos     = MLIB.coords(25),
        min_ante = 3,
        boss_colour = HEX('A28345'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v) v:is_suit('rgmc_daggers') end) > 4 or Madcap.Data.devmode
        end,
        debuff = { suit = 'rgmc_daggers' },
    }
}
