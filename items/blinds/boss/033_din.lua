return {
    data = {
        object_type = 'Blind',
        key     = 'din',
        atlas   = "blinds",
        pos     = MLIB.coords(35),
        min_ante = 3,
        config = { extra = 1 },
        boss_colour = HEX('2E3231'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        set_blind = function(self, reset, silent)
            if not G.GAME.blind.disabled then
                Madcap.Funcs.ease_mayhem(self.config.extra)
                return true
            end
        end,
        loc_vars = function(self, info_queue, blind)
            if G.GAME.blind then
                return MadLib.collect_vars(number_format(1))
            else
                return MadLib.collect_vars(number_format(self.config.extra))
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
