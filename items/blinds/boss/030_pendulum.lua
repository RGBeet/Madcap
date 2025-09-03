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
        boss_colour = HEX('1F6570'),
        config = { left_side = false },
        in_pool = function(self)
            return (G.jokers and #G.jokers.cards > 1) or Madcap.Data.devmode
        end,
        calculate = function (self, blind, context)
            if 
                not G.GAME.blind.disabled 
                and (context.first_hand_drawn or context.final_scoring_step) 
                and not context.end_of_round 
            then
                if not context.first_hand_drawn then
                    blind.config.left_side = (not blind.config.left_side)
                    G.GAME.blind.triggered = true
                end
                local pitch = 1.00
                MadLib.loop_func({ G.jokers, G.hand }, function(v)
                    if v and (#v.cards > 0) then
                        local num = math.ceil(math.max(2, #v.cards)/2)
                        MadLib.loop_func(v.cards, function(c,i)
                            MadLib.simple_event(function()
                                local should_debuff = blind.config.left_side and (i < num) or (i > num)
                                SMODS.debuff_card(c, should_debuff, 'rgmc_pendulum')
                                if should_debuff then play_sound('timpani',pitch,0.6) end
                                c:juice_up(0.3, 0.3)
                                return true
                            end,0.1,'after')
                            pitch = pitch + (blind.config.left_side and 0.04 or -0.04)
                            return true
                        end)
                    end
                end)
            end
        end,
        defeat  = Madcap.Funcs.pendulum_end(self, silent),
        disable = Madcap.Funcs.pendulum_end(self, silent),
    }
}
