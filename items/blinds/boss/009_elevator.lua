return {
    data = {
        object_type = 'Blind',
        key     = 'elevator',
        atlas   = "blinds",
        pos     = MLIB.coords(8),
        mult    = 1.5,
        dollars = 6,
        boss_colour = HEX('A9473A'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
                return not v:is_rankless()
            end) > (#G.playing_cards / 4) or Madcap.Data.devmode
        end,
        loc_vars = function(self, info_queue, blind)
            if not G.GAME.MADCAP then return MadLib.collect_vars(1, 6) end
            local numer, denom = Madcap.Funcs.fix_probabilities(SMODS.get_probability_vars(self, 1, 4, 'elevator'))
            return MadLib.collect_vars(numer, denom)
        end,
        calculate = function(self, blind, context)
            if context.final_scoring_step and not G.GAME.blind.disabled and SMODS.pseudorandom_probability(self, 'elevator', 1, 4) then
                MadLib.flip_cards(context.scoring_hand, function(v) 
                    assert(SMODS.modify_rank(v, 1)) 
                end)
            end
        end
    }
}
