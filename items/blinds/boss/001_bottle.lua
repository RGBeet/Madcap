-- All Goblet suit playing cards are debuffed.
return {
    categories = {
        'New Suits'
    },
    data = {
        object_type = 'Blind',
        key     = 'bottle',
        atlas   = "blinds",
        pos     = MLIB.coords(0),
        boss_colour = HEX('DF463F'),
        in_pool = function(self) -- At least 5 Goblet suit cards.
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v) 
                    v:is_suit('rgmc_goblets') 
                end) > 4 or Madcap.Data.devmode
        end,
        debuff = { suit = 'rgmc_goblets' },
    }
}
