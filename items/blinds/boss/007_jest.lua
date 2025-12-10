-- If Blind score surpasses 2X Blind Requirements, skip an ante.
return {
    data = {
        object_type = 'Blind',
        key     = 'jest',
        atlas   = "blinds",
        pos     = MLIB.coords(6),
        mult    = 1.5,
        boss_colour = HEX('97CD69'),
        config  = { blind_mult = 2, add_antes = 1 },
        in_pool = function(self) -- Prevents the boss effect from skipping final antes.
            return math.floor(G.GAME.round_resets.ante/G.GAME.win_ante) == math.floor(((G.GAME.round_resets.ante or 1) + self.config.add_antes) / G.GAME.win_ante)
        end,
        loc_vars = function(self, info_queue, blind)
            local max_chips = MadLib.multiply(G.GAME.blind.chips, self.config.blind_mult or 2)
            local ante_sign = (not MadLib.is_negative_number(self.config.add_antes)) and '+' or ''
            return MadLib.collect_vars(max_chips, ante_sign .. number_format(self.config.add_antes or 1))
        end,
        calculate = function (self, blind, context)
            if 
                not blind.disabled
                and context.end_of_round
                and not context.repetition
                and not context.individual
                and MadLib.compare_numbers(G.GAME.chips, MadLib.multiply(G.GAME.blind.chips, self.config.blind_mult or 2)) > 0
            then
                ease_ante(self.config.add_antes)
            end
        end
    }
}
