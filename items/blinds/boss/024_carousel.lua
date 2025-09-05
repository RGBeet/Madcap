return {
    data = {
        object_type = 'Blind',
        key     = 'carousel',
        atlas   = "blinds",
        pos     = MLIB.coords(23),
        min_ante = 3,
        boss_colour = HEX('953D63'),
        in_pool = function(self)
            return Madcap.Data.devmode or (G.jokers and #G.jokers.cards > 3)
        end,
        calculate = function(self, blind, context)
            if context.setting_blind and not G.GAME.blind.disabled then
                
                MadLib.loop_func(G.jokers.cards, function(v)
                    v.pinned = true
                end)

                MadLib.simple_event(function()
                    MadLib.number_func(4, function(i)
                        MadLib.simple_event(function()
                            G.jokers:shuffle('rgmc_carousel')
                            play_sound('cardSlide1', 0.85 + i*0.15)
                            return true
                        end, 0.8, 'after')
                    end, true)
                    return true
                end, 0.25, 'after')
            end

            if 
                (context.setting_blind or context.before) 
                and not G.GAME.blind.disabled 
            then

            end
        end,
        defeat = function(self, silent)
            
        end,
        disable = function(self, silent)
            
        end,
    }
}
