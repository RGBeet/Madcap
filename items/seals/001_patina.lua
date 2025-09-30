return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "patina",
        atlas = 'seals',
        pos = MLIB.coords(0,0),
        badge_colour    = HEX("49AB9A"),
        config = { extra = { seal_odds = 4, seal_rolls = 10 } }, -- 3 in 4 chance to move forward 1
        loc_vars = function(self, info_queue, seal)
            local _numer, _denom = SMODS.get_probability_vars(seal, 1, self.config.extra.seal_odds, 'patina')
            return MadLib.collect_vars(number_format(math.max(_denom - _numer, 1)), number_format(_denom), number_format(self.config.extra.seal_rolls))
        end,
    }
}
