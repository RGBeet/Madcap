return {
    data = {
        object_type = 'Blind',
        key     = 'carousel',
        atlas   = "blinds",
        pos     = MLIB.coords(23),
        min_ante = 3,
        boss_colour = HEX('5F579D'),
        in_pool = function(self)
            return Madcap.Data.devmode or (G.jokers and #G.jokers.cards > 3)
        end,
        calculate = function(self, blind, context)
            if context.setting_blind and not G.GAME.blind.disabled then
                Madcap.CheckJokerOrder = true
                MadLib.simple_event(function()
                    MadLib.number_func(4, function(i)
                        MadLib.simple_event(function()
                            G.jokers:shuffle('rgmc_carousel')
                            play_sound('cardSlide1', 0.85 + i*0.15)
                            return true
                        end)
                        delay(0.25*i)
                    end, true)
                    return true
                end, 0.25, 'after')
            end
            if context.break_positions and not G.GAME.blind.disabled then
                MadLib.simple_event(function()
                    G.hand:change_size(-1)
                    blind.ability.penalty = (blind.ability.penalty or 0) + 1
                    G.GAME.blind:wiggle()
                    G.GAME.blind.triggered = true
                    return true
                end)
                delay(1.0)
            end
        end,
        defeat = function(self, silent)
            Madcap.CheckJokerOrder = true
            G.hand:change_size(blind.ability.penalty)
            self.config.penalty = 0
        end,
        disable = function(self, silent)
            Madcap.CheckJokerOrder = false
            G.hand:change_size(blind.ability.penalty)
            self.config.penalty = 0
        end,
    }
}
