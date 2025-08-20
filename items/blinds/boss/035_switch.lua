function Madcap.Funcs.boss_switch_revert(k,v)
end

function Madcap.Funcs.boss_switch_end(self,silent)
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
            return G.playing_cards and #MadLib.get_ranks_from_cards(G.playing_cards,true) > 1 or Madcap.Data.devmode
        end,
        set_blind = function(self, reset, silent)
            -- initialize the list
            G.GAME.temp['rgmc_flip'] = {}
            local list = {}
        end,
        defeat = Madcap.Funcs.boss_flip_end,
        disable = Madcap.Funcs.boss_flip_end,
    }
}
