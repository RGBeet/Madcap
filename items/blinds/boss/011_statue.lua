return {
    data = {
        object_type = 'Blind',
        key     = 'statue',
        atlas   = "blinds",
        pos     = MLIB.coords(10),
        mult    = 1.5,
        dollars = 6,
        mult    = 0,
        boss_colour = HEX('423894'),
        in_pool = function(self)
            return true
        end,
        rgmc_ante_start = function(self)
            G.GAME.blind.chips = Madcap.Funcs.get_sum_chips(self)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true
        end,
        set_blind = function(self, reset, silent)
            G.GAME.blind.chips = Madcap.Funcs.get_sum_chips(self)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.GAME.blind.triggered = true
            return true
        end,
        defeat = function(self, silent)
            -- no longer needed
            self.mult = 0
        end,
    }
}
