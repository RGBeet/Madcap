function Madcap.Funcs.boss_flip_end(self,silent)
    G.GAME.temp['rgmc_flip'] = MadLib.get_flipped_table(G.GAME.temp['rgmc_flip'])
    MadLib.loop_func(G.playing_cards, function(v)
        local _to = G.GAME.temp['rgmc_flip'][v.base.value]
        if not _to then return end
        v.base.value = _to
    end)
end

return {
    data = {
        object_type = 'Blind',
        key     = 'flip',
        atlas   = "blinds",
        pos     = MLIB.coords(36),
        min_ante = 6,
        config = { extra = 1 },
        boss_colour = HEX('126EAF'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_ranks_from_cards(G.playing_cards,true) > 1 or Madcap.Data.devmode
        end,
        set_blind = function(self, reset, silent)
            -- initialize the list
            G.GAME.temp['rgmc_flip'] = {}
            local temp_list1, temp_list2 = {}, {}
            local rank_map = MadLib.get_ranks_from_cards(G.playing_cards)
            MadLib.loop_table(rank_map, function(k,v) 
                table.insert(temp_list1, k)
                table.insert(temp_list2, k)
            end)
            pseudoshuffle(temp_list1, pseudoseed('flip'))
            MadLib.loop_func(temp_list1, function(k,i) 
                G.GAME.temp['rgmc_flip'][k] = temp_list2[i] -- from -> to
            end)
            MadLib.loop_func(G.playing_cards, function(v)
                local _to = G.GAME.temp['rgmc_flip'][v.base.value]
                if not _to then return end
                v.base.value = _to
            end)
            tell('Flip values done!')
        end,
        defeat = Madcap.Funcs.boss_flip_end,
        disable = Madcap.Funcs.boss_flip_end,
    }
}
