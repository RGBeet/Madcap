Madcap.GigaBlacklist = { -- 4 cards or more!
    'Three of a Kind',
    'Pair',
}

return {
    categories = {
        'Decks',
    },
    data = {
        object_type = "Back",
        key     = "giga",
        atlas   = 'decks',
        pos     = MLIB.coords(2,0),
        config = { hand_size = 2, play_limit = 2, ante_scaling = 1.5, min_size = 4 },
        loc_vars = function(self)
            return MadLib.collect_vars(self.config.hand_size, self.config.play_limit, self.config.ante_scaling)
        end,
        apply = function(self, back)
            -- change the play limit
            MadLib.simple_event(function()
                SMODS.change_play_limit(self.config.play_limit)
                return true
            end, 0.7, 'after')

            MadLib.loop_func(Madcap.GigaBlacklist, function(h)
                if not G.GAME.hands[h] then return end
                G.GAME.hands[h].visible = false
            end)

            G.GAME.modifiers.poker_hand_blacklist   = Madcap.GigaBlacklist
            G.GAME.modifiers.min_hand_size          = self.config.min_size

            Madcap.Funcs.init_deck('giga', {
                finishers       = { 'bl_rgmc_final_blindfold' }, -- force ???
            })
        end,
    }
}
