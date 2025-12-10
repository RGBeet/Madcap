return {
    data = {
        object_type = 'Blind',
        key     = 'final_target',
        atlas   = "blinds",
        pos     = MLIB.coords(19),
        mult    = 1.75,
        dollars = 8,
        boss_colour = HEX('D22A49'),
        in_pool = function(self)
            return true
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(MadLib.divide(1, self.debuff.chip_window)))
        end,
        calculate = function(self, card, context)
            if not G.GAME.blind.disabled and context.rgmc_total_score then
                local chip_window   = MadLib.divide(1, self.debuff.chip_window)
                local minimum       = MadLib.multiply(G.GAME.blind.chips, chip_window)
                local maximum       = MadLib.multiply(G.GAME.blind.chips, MadLib.add(chip_window, 1))
                local new_total     = MadLib.add(G.GAME.chips, context.rgmc_total_score)
                if 
                    MadLib.compare_numbers(new_total, maximum) > 0 
                    or MadLib.compare_numbers(new_total, minimum) < 0
                then
                    G.GAME.chips = 0
                    MadLib.manipulate_chips_mult(0,0)
                    MadLib.simple_event(function()
                        G.GAME.blind:wiggle() -- nuh uh!
                        G.GAME.blind.triggered = true
                        return true
                    end, 1)
                end
            end
        end,
    }
}
