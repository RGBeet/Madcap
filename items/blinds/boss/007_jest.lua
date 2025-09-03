return {
    data = {
        object_type = 'Blind',
        key     = 'jest',
        atlas   = "blinds",
        pos     = MLIB.coords(6),
        mult    = 1.5,
        boss_colour = HEX('97CD69'),
        config  = { blind_mult = 2, add_antes = 1 },
        in_pool = function(self)
            return math.floor(G.GAME.round_resets.ante/G.GAME.win_ante) == math.floor(((G.GAME.round_resets.ante or 1) + self.config.add_antes) / G.GAME.win_ante)
        end,
        loc_vars = function(self, info_queue, blind)
            return {
                vars = {
                    self.config.blind_mult or 2,
                    self.config.add_antes or 1
                }
            }
        end,
        calculate = function (self, blind, context)
            if 
                not blind.disabled
                and context.end_of_round
                and not context.repetition
                and not context.individual 
                and (to_big(G.GAME.chips) > to_big(G.GAME.blind.chips) * blind.config.blind_mult) 
            then
                ease_ante(blind.debuff.add_antes) 
            end
        end
    }
}
