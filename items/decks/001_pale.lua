function Madcap.Funcs.get_pale_score(card)
    if not card then return -1 end
    local edition   = (card.edition and 10) or 0
    return edition
end

Madcap.DeckFuncs['pale'] = {
    calculate = function(self, card, context)
        if context.setting_blind then
            local seed = pseudoseed('rgmc_pale_deck_'..tostring(G.GAME.round_resets.ante))
            local number = math.floor(#G.playing_cards/4)
            local shuffle = MadLib.shuffle_sort_list(G.playing_cards, number, function(v,k)
                return not (v.edition and v.edition.negative)
            end, function(a,b)
                return Madcap.Funcs.get_pale_score(a) > Madcap.Funcs.get_pale_score(b)
            end)
            MadLib.loop_func(shuffle, function(c)
                c.pale_deck = true
                c:set_temp_sticker('rgmc_twinkling', true, 1)
                c:set_edition({ negative = true }, true, true)
            end)
            MadLib.loop_func(MadLib.list_pick_range(shuffle, number+1, #shuffle), function(c)
                c.pale_deck = nil
            end)
        end
    end
}

return {
    categories = {
        'Decks'
    },
    data = {
        object_type = "Back",
        key     = "pale",
        atlas   = 'decks',
        pos     = MLIB.coords(0,0),
        config  = { hand_size = -3, hands = -1 },
        loc_vars = function(self)
            MadLib.collect_vars(self.config.hand_size, self.config.hands, (G.GAME and G.GAME.MADCAP) and math.floor(#G.playing_cards/4) or 13)
        end,
        apply = function(self)
            Madcap.Funcs.init_deck('pale', {
                force_chance    = 7,         -- 1 in 7 to get The Force, turns into 1 in 1 at Ante 7
                force_awakened  = false,     -- forces The Force until beaten
                finishers       = { 'bl_rgmc_final_void' } -- force Midnight Void
            })
        end,
        calculate = Madcap.DeckFuncs['pale'].calculate,
    }
}
