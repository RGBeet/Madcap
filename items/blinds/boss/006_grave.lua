return {
    data = {
        object_type = 'Blind',
        key     = 'grave',
        atlas   = "blinds",
        pos     = MLIB.coords(5),
        dollars = 6,
        boss_colour = HEX('736B4E'),
        in_pool = function(self) 
            return true 
        end,
        calculate = function(self, blind, context)

            if context.pre_discard and not G.GAME.blind.disabled then
                MadLib.loop_func(G.hand.highlighted, function(v) 
                    MadLib.simple_event(function()
                        v:flip()
                        return true
                    end,0.15,'after')
                end)
                MadLib.loop_func(G.hand.highlighted, function(v) 
                    MadLib.simple_event(function()
                        SMODS.Stickers["rgmc_engraved"]:apply(v,true)
                        return true
                    end,0.00,'after')
                end)
                MadLib.loop_func(G.hand.highlighted, function(v) 
                    MadLib.simple_event(function()
                        v:flip()
                        return true
                    end,0.15,'after')
                end)
                delay(0.25)
                MadLib.loop_func(G.hand.highlighted, function(v) 
                    MadLib.simple_event(function()
                        v:juice_up()
                        return true
                    end,0.15,'after')
                end)
            end

            if context.discard and not G.GAME.blind.disabled then
                MadLib.loop_func(G.hand.highlighted, function(v) 
                    SMODS.Stickers["rgmc_engraved"]:apply(v,true) 
                end)
            end
        end,
    }
}
