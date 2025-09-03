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
                MadLib.flip_cards(context.scoring_hand, function(v)
                    SMODS.pseudorandom_probability(self, 'elevator', 1, 2)
                    v.rgmc_coil = true 
                end)
            end
        end,
    }
}
