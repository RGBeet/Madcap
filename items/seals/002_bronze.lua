return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "bronze",
        atlas = 'seals',
        pos = MLIB.coords(0,1),
        badge_colour    = HEX("754D42"),
        config = { seal_odds = 5, seal_rolls = 10 }, -- 4 in 5 chance to move back 1
        loc_vars = function(self, info_queue, seal)
            local _numer, _denom = SMODS.get_probability_vars(seal, 1, self.config.seal_odds, 'bronze')
            return MadLib.collect_vars(number_format(math.max(_denom - _numer, 1)), number_format(_denom), number_format(seal.ability.seal_rolls))
        end,
    }
}
