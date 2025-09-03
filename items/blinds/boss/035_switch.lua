function Madcap.Funcs.boss_switch_end(self,silent)
    G.GAME.temp['rgmc_switch'] = MadLib.get_flipped_table(G.GAME.temp['rgmc_switch'])
    MadLib.loop_func(G.playing_cards, function(v)
        local _to = G.GAME.temp['rgmc_switch'][v.base.suit]
        if not _to then return end
        v.base.suit = _to
    end)
end

return {
    data = {
        object_type = 'Blind',
        key     = 'switch',
        atlas   = "blinds",
        pos     = MLIB.coords(37),
        min_ante = 5,
        config = { extra = 1 },
        boss_colour = HEX('F5C387'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_suits_from_cards(G.playing_cards) > 1 or Madcap.Data.devmode
        end,
        set_blind = function(self, reset, silent)
            -- initialize the list
            G.GAME.temp['rgmc_switch'] = {}
            local temp_list1, temp_list2 = {}, {}
            local suit_map = MadLib.get_suits_from_cards(G.playing_cards)
            MadLib.loop_table(rank_map, function(k,v) 
                table.insert(temp_list1, k)
                table.insert(temp_list2, k)
            end)
            pseudoshuffle(temp_list1, pseudoseed('switch' .. tostring(G.GAME.round_resets.ante)))
            MadLib.loop_func(temp_list1, function(k,i) 
                G.GAME.temp['rgmc_switch'][k] = temp_list2[i] -- from -> to
            end)
            MadLib.loop_func(G.playing_cards, function(v)
                local _to = G.GAME.temp['rgmc_switch'][v.base.suit]
                if not _to then return end
                v.base.suit = _to
            end)
            tell('Switch values done!')
        end,
        defeat = Madcap.Funcs.boss_switch_end,
        disable = Madcap.Funcs.boss_switch_end,
    }
}
