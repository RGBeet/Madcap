return {
    categories = {
        'Enhancements',
        'Disenhancements',
        'Score'
    },
    data = {
        object_type = 'Blind',
        key     = 'final_vino',
        atlas   = "blinds",
        pos     = MLIB.coords(33),
        boss_colour = HEX('43B34D'),
        in_pool = function(self)
            return true
        end,
        loc_vars = function(self, info_queue, blind)
            local _numer, _denom = SMODS.get_probability_vars(self, 1, 4, 'final_vino')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function (self, blind, context)
            if
                not G.GAME.blind.disabled
                and (context.pre_discard or context.after)
            then
                local vino_converts = MadLib.get_loop_func(context.pre_discard and G.hand.highlighted, function(v)
                    return not SMODS.has_enhancement(v, 'm_rgmc_vino')
                        and SMODS.pseudorandom_probability(self, 'final_vino', 1, 4)
                end)
                MadLib.loop_func(vino_converts, function(v) 
                    MadLib.simple_event(function()
                        v:flip()
                        return true
                    end,0.15,'after')
                end)
                MadLib.loop_func(vino_converts, function(v) 
                    MadLib.simple_event(function()
                        -- Mark as converted by the blind (in case blind is disabled later?)
                        v.ability.vino_boss = true
                        v:set_ability(G.P_CENTERS['m_rgmc_vino'])
                        return true
                    end,0.00,'after')
                end)
                MadLib.loop_func(vino_converts, function(v) 
                    MadLib.simple_event(function()
                        v:flip()
                        return true
                    end,0.15,'after')
                end)
                delay(0.25)
                MadLib.loop_func(vino_converts, function(v) 
                    MadLib.simple_event(function()
                        v:juice_up()
                        return true
                    end,0.15,'after')
                end)
            end
        end,
        defeat = function(self, silent)
            MadLib.loop_func(G.playing_cards, function(v) v.ability.vino_boss = nil end)
        end,
        disable = function(self, silent)
            -- revert vino cards converted this round
            local vino_revert = {}
            MadLib.loop_func(G.playing_cards, function(v)
                if not (SMODS.has_enhancement(v, 'm_rgmc_vino') and v.ability.vino_boss) then return end
                if v.area ~= G.hand then
                    v:set_ability(G.P_CENTERS.c_base)
                else
                    table.insert(anim, v)
                end
                v.ability.vino_boss = nil
            end)
            MadLib.loop_func(vino_revert, function(v) 
                MadLib.simple_event(function()
                    v:flip()
                    return true
                end,0.15,'after')
            end)
            MadLib.loop_func(vino_revert, function(v) 
                MadLib.simple_event(function()
                    v:set_ability(G.P_CENTERS.c_base)
                    return true
                end,0.00,'after')
            end)
            MadLib.loop_func(vino_revert, function(v) 
                MadLib.simple_event(function()
                    v:flip()
                    return true
                end,0.15,'after')
            end)
            delay(0.25)
            MadLib.loop_func(vino_revert, function(v) 
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end,0.15,'after')
            end)
        end,
    }
}
