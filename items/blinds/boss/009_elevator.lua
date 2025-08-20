return {
    data = {
        object_type = 'Blind',
        key     = 'elevator',
        atlas   = "blinds",
        pos     = MLIB.coords(8),
        mult    = 1.5,
        dollars = 6,
        boss_colour = HEX('423894'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
                return not v:is_rankless()
            end) > (#G.playing_cards / 4) or Madcap.Data.devmode
        end,
        loc_vars = function(self, info_queue, blind)
            local _numer, _denom = SMODS.get_probability_vars(self, 1, 6, 'elevator')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, blind, context)
            if context.final_scoring_step and not G.GAME.blind.disabled and SMODS.pseudorandom_probability(self, 'elevator', 1, 6) then
                MadLib.flip_cards(context.scoring_hand, function(v) assert(SMODS.modify_rank(v, 1)) end)
            end
        end
    }
}
