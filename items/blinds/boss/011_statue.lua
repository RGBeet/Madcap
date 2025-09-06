-- 1 in 4 chance to turn scored cards to stone
return {
    data = {
        object_type = 'Blind',
        key     = 'statue',
        atlas   = "blinds",
        pos     = MLIB.coords(10),
        mult = 2,
        dollars = 5,
        boss_colour = HEX('454E4D'),
        in_pool = function(self)
            return true
        end,
        loc_vars = function(self, info_queue, blind)
            if not G.GAME.MADCAP then return MadLib.collect_vars(1, 4) end
            local numer, denom = Madcap.Funcs.fix_probabilities(SMODS.get_probability_vars(blind, 1, 4, 'statue'))
            return MadLib.collect_vars(numer, denom)
        end,
        calculate = function(self, blind, context)
            if context.final_scoring_step and not G.GAME.blind.disabled then
                local stoned = {}
                MadLib.loop_func(context.scoring_hand, function(v)
                    if not SMODS.pseudorandom_probability(card, 'statue', 1, 4) then return end
                    table.insert(stoned,v)
                    MadLib.simple_event(function()
                        v:set_ability(G.P_CENTERS.m_stone)
                        v:juice_up()
                        return true
                    end, 0.1, 'after')
                end)
                if #stoned > 0 then
                    MadLib.simple_event(function()
                        play_sound('rgmc_concrete_scrape')
                        return true
                    end, 0.9, 'after')
                end
            end
        end,
    }
}
