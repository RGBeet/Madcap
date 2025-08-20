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
                local vino_converts = MadLib.get_loop_func(context.pre_discard and G.hand.highlighted or G.hand.cards, function(v)
                    return not SMODS.has_enhancement(v, 'm_rgmc_vino')
                        and SMODS.pseudorandom_probability(self, 'final_vino', 1, 4)
                end)
                MadLib.flip_cards(anim, function(v)
                    v.ability.vino_boss = true -- marked by this blind
                    v:set_ability(G.P_CENTERS['m_rgmc_vino'])
                end, nil, function(v)
                    MadLib.simple_event(function()
                        v:juice_up()
                        return true
                    end)
                end)
            end
        end,
        defeat = function(self, silent)
            MadLib.loop_func(G.playing_cards, function(v)
                v.ability.vino_boss = nil
            end)
        end,
        disable = function(self, silent)
            -- revert vino cards converted this round
            MadLib.loop_func(G.playing_cards, function(v)
                if SMODS.has_enhancement(v, 'm_rgmc_vino') and v.ability.vino_boss then
                    if v.area ~= G.hand then
                        v:set_ability(G.P_CENTERS.c_base)
                    else
                        table.insert(anim, v)
                    end
                    v.ability.vino_boss = nil
                end
            end)
            -- do animation for hand cards
            MadLib.flip_cards(anim, function(v)
                v:set_ability(G.P_CENTERS.c_base)
            end, nil, function(v)
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end)
            end)
        end,
    }
}
