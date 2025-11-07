return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key         = "merlot",
        atlas       = 'decks',
        pos         = MLIB.coords(1,3),
        config      = {},
        loc_vars    = function(self)
            return MadLib.collect_vars_colours(
                localize('rgmc_blooms', 'suits_plural'),
                localize('rgmc_daggers', 'suits_plural'),
                number_format(26),
                { 
                    G.C.SUITS['rgmc_blooms'],
                    G.C.SUITS['rgmc_daggers']
                })
        end,
        apply = function(self)
            Madcap.Funcs.init_deck('merlot', { finishers = { 'bl_rgmc_final_moon' } })
            G.GAME.Exotic = true -- Exotic Suits show up!
            Madcap.Funcs.set_subhand('dark',true)
            MadLib.event({
                func = function()
                    MadLib.loop_func(G.playing_cards, function(v)
                        if v.base.suit == 'Hearts' or v.base.suit == 'Diamonds' then
                            v:change_suit('rgmc_blooms')
                        elseif v.base.suit == 'Spades' or v.base.suit == 'Clubs' then
                            v:change_suit('rgmc_daggers')
                        end
                    end)
                    return true
                end
            })
        end
    }
}
