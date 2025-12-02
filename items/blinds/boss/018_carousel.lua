local move_ref = Moveable.drag
function Moveable.drag(self, offset)
  if self.is and type(self.is) == "function" and self:is(Card) and self.area == G.jokers then
    if G and G.GAME and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled and G.GAME.blind.name == 'bl_rgmc_carousel' then
      return
    end
  end

  return move_ref(self, offset)
end

-- When the Carousel is defeated or disabled (Luchador/Chicot/etc.)
function Madcap.Funcs.boss_carousel_end(self,silent)
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
