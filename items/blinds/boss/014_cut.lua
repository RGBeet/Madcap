-- If score exceeds 4/3 Blind requirements, cut blind by 1/2 and lose $5
return {
    data = {
        object_type = 'Blind',
        key     = 'cut',
        atlas   = "blinds",
        pos     = MLIB.coords(13),
        boss_colour = HEX('8857C1'),
        min_ante = 2,
        config = { extra = -5 },
        loc_vars = function(self, info_queue, blind)
            if G.GAME.blind then
                local max_chips = MadLib.multiply(MadLib.multiply(self.mult, 1.25), get_blind_amount(G.GAME and G.GAME.round_resets.ante or 1))
                return MadLib.collect_vars(
                    number_format(max_chips),
                    number_format(blind and blind.ability.extra or -5)
                )
            else
                return MadLib.collect_vars("4/3X Blind", number_format(-5))
            end
        end,
        in_pool = function(self)
            return Madcap.Data.devmode or MadLib.compare_numbers(MadLib.subtract(G.GAME.dollars, MadLib.multiply(self.config.extra * 3)), G.GAME.bankrupt_at)
        end,
        calculate = function(self, blind, context)
            if 
                not G.GAME.blind.disabled 
                and context.rgmc_total_score 
            then
                local new_total = MadLib.add(G.GAME.chips, context.rgmc_total_score)
                local max_chips = MadLib.multiply(MadLib.multiply(self.mult, 1.25), get_blind_amount(G.GAME and G.GAME.round_resets.ante or 1))
                if MadLib.compare_numbers(new_total, max_chips) > 0 then
                    G.GAME.chips = math.floor(MadLib.divide(new_total, 2))
                    MadLib.manipulate_chips_mult(0,0)
                    MadLib.simple_event(function()
                        ease_dollars(self.config.extra)
                        return true
                    end, 1, 'after')
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
