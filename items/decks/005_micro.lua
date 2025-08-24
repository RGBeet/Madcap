Madcap.MicroDeckList = { -- 4 cards or less!
    'High Card',
    'Pair',
    'Three of a Kind',
    'Two Pair',
    'Four of a Kind'
}

return {
    categories = {
        'Decks',
    },
    data = {
        object_type = "Back",
        key     = "micro",
        atlas   = 'decks',
        pos     = MLIB.coords(0,4),
        config = { hand_size = -3, play_limit = -1, ante_scaling = 0.5 },
        loc_vars = function(self)
            return MadLib.collect_vars(self.config.hand_size, self.config.play_limit, self.config.ante_scaling)
        end,
        apply = function(self, back)
            -- change the play limit
            MadLib.simple_event(function()
                SMODS.change_play_limit(self.config.play_limit)
                return true
            end, 0.7, 'after')
            MadLib.loop_func(G.handlist, function(h)
                if not MadLib.list_matches_one(Madcap.MicroDeckList, function(h2)
                    return h == h2
                end) then
                    G.GAME.hands[h].visible = false
                end
            end)
            Madcap.Funcs.init_deck('micro', {
                finishers       = { 'bl_rgmc_final_blindfold' }, -- force ???
                target_logic    = true
            })
            G.GAME.subhand_minimum = 4
        end,
    }
}
