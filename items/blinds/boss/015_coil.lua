-- Played cards have a 1 in 2 chance to return to hand
return {
    data = {
        object_type = 'Blind',
        key     = 'coil',
        atlas   = "blinds",
        pos     = MLIB.coords(14),
        boss_colour = HEX('F4EFF6'),
        min_ante = 2,
        mult    = 2.5,
        loc_vars = function(self, info_queue, blind)
            if not G.GAME.MADCAP then return MadLib.collect_vars(1, 2) end
            local numer, denom = Madcap.Funcs.fix_probabilities(SMODS.get_probability_vars(self, 1, 2, 'coil'))
            return MadLib.collect_vars(numer, denom)
        end,
        calculate = function(self, blind, context)
            if 
                not G.GAME.blind.disabled 
                and context.scoring_hand 
                and context.final_scoring_step 
            then
                MadLib.loop_func(context.scoring_hand, function(v)
                    if SMODS.pseudorandom_probability(self, 'coil', 1, 2) then return end
                    v.rgmc_coil = true
                    -- do the thing
                    MadLib.simple_event(function()
                        v:juice_up(0.3,0.3)
                        return true
                    end, 0.5, 'after')
                end)
            end
        end,
    }
}
