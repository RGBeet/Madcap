function Madcap.Funcs.pendulum_end(self, silent)
    MadLib.loop_func({ G.jokers, G.hand }, function(v,_)
        if v and (#v.cards > 0) then
            MadLib.flip_cards(v.cards, function(c)
                c:set_debuff(false)
            end, nil, function(c)
                c:juice_up(0.3, 0.3)
            end)
        end
    end)
    return true
end

return {
    data = {
        object_type = 'Blind',
        key     = 'pendulum',
        atlas   = "blinds",
        pos     = MLIB.coords(29),
        min_ante = 3,
        boss_colour = HEX('A65096'),
        config = { left_side = false },
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        calculate = function (self, blind, context)
            if not G.GAME.blind.disabled and (context.setting_blind or context.after) and not context.end_of_round then
                if not context.setting_blind then
                    blind.config.left_side = (not blind.config.left_side)
                    G.GAME.blind.triggered = true
                end
                MadLib.loop_func({ G.jokers, G.hand }, function(v,_)
                    if v and (#v.cards > 0) then
                        local num = math.ceil(math.max(2, #v.cards)/2)
                        MadLib.loop_func(v.cards, function(c,i)
                            MadLib.simple_event(function()
                                c:set_debuff(blind.config.left_side and i < num or i > num)
                                c:juice_up(0.3, 0.3)
                                return true
                            end,0.08,'after')
                            return true
                        end)
                    end
                end)
            end
        end,
        defeat = function(self, silent)
            if not G.GAME.blind.disabled then return Madcap.Funcs.pendulum_end(self, silent) end
        end,
        disable = Madcap.Funcs.pendulum_end(self, silent),
    }
}
