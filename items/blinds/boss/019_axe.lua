return {
    categories = {
        'New Suits'
    },
    data = {
        object_type = 'Blind',
        key     = 'axe',
        atlas   = "blinds",
        pos     = MLIB.coords(24),
        min_ante = 3,
        boss_colour = HEX('56C39F'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v) v:is_suit('rgmc_blooms') end) > 4 or Madcap.Data.devmode
        end,
        debuff = { suit = 'rgmc_blooms' },
    }
}
