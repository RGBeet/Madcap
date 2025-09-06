-- When the Carousel is defeated or disabled (Luchador/Chicot/etc.)
function Madcap.Funcs.boss_carousel_end(self,silent)
    MadLib.loop_func(G.jokers.cards, function(v)
        if v.carousel_pinned then return end
        v.carousel_pinned = nil
        MadLib.simple_event(function()
            v.pinned = nil
            v:juice_up(0.3,0.3)
        end, 0.8, 'after')
    end)
end

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
            -- Setting blind
            if context.setting_blind and not G.GAME.blind.disabled then
                -- If a Joker is not already marked as Pinned, mark the Joker as Pinned.
                MadLib.loop_func(G.jokers.cards, function(v)
                    if v.pinned then return end
                    v.carousel_pinned = true
                    -- Show that the Joker is now marked as Pinned.
                    MadLib.simple_event(function()
                        v.pinned = true
                        v:juice_up(0.3,0.3)
                    end, 0.8, 'after')
                end)

                -- Shuffle the Jokers three times.
                MadLib.number_func(3, function(i)
                    MadLib.simple_event(function()
                        G.jokers:shuffle('rgmc_carousel')
                        play_sound('cardSlide1', 0.85 + i*0.15)
                        return true
                    end, 0.8, 'after')
                end, true)
            end
            -- Each hand
            if context.before and not G.GAME.blind.disabled then
                MadLib.number_func(1, function(i)
                    MadLib.simple_event(function()
                        G.jokers:shuffle('rgmc_carousel')
                        play_sound('cardSlide1', 0.85 + i*0.15)
                        return true
                    end, 0.8, 'after')
                end, true)
            end
        end,
        defeat  = Madcap.Funcs.boss_carousel_end,
        disable = Madcap.Funcs.boss_carousel_end,
    }
}
