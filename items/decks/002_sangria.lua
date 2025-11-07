return {
    categories = {
        'Decks',
        'New Suits'
    },
    data = {
        object_type = "Back",
        key         = "sangria",
        atlas       = 'decks',
        pos         = MLIB.coords(0,2),
        config      = {},
        loc_vars    = function(self)
            return MadLib.collect_vars_colours(
                localize('rgmc_goblets', 'suits_plural'),
                localize('rgmc_towers', 'suits_plural'),
                number_format(26),
                { 
                    G.C.SUITS['rgmc_goblets'],
                    G.C.SUITS['rgmc_towers']
                })
        end,
        apply = function(self)
            Madcap.Funcs.init_deck('merlot', { finishers = { 'bl_rgmc_final_moon' } })
            G.GAME.Exotic = true -- Exotic Suits show up!
            Madcap.Funcs.set_subhand('light',true)
            MadLib.event({
                func = function()
                    MadLib.loop_func(G.playing_cards, function(v)
                        if v.base.suit == 'Hearts' or v.base.suit == 'Diamonds' then
                            v:change_suit('rgmc_goblets')
                        elseif v.base.suit == 'Spades' or v.base.suit == 'Clubs' then
                            v:change_suit('rgmc_towers')
                        end
                    end)
                    return true
                end
            })
        end
    }
}
