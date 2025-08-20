return {
    data = {
        object_type = 'Blind',
        key     = 'din',
        atlas   = "blinds",
        pos     = MLIB.coords(32),
        min_ante = 3,
        config = { extra = 1 },
        boss_colour = HEX('454E4D'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        set_blind = function(self, reset, silent)
            if not G.GAME.blind.disabled then
                Madcap.Funcs.ease_mayhem(self.config.extra)
                return true
            end
        end,
        disable = function(self)
            Madcap.Funcs.ease_mayhem(-self.config.extra)
        end,
        defeat = function(self, silent)
            if not G.GAME.blind.disabled then
                Madcap.Funcs.ease_mayhem(-self.config.extra)
                return true
            end
        end,
    }
}
