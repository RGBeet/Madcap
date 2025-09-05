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
                return MadLib.collect_vars(
                    number_format(2 * get_blind_amount(G.GAME and G.GAME.round_resets.ante or 1)),
                    number_format(blind and blind.ability.extra or -5)
                )
            else
                return MadLib.collect_vars("2X Blind", number_format(-5))
            end
        end,
        in_pool = function(self)
            return Madcap.Data.devmode or to_big(G.GAME.dollars - self.config.extra*3) > to_big(G.GAME.bankrupt_at)
        end,
        calculate = function(self, blind, context)
            if not G.GAME.blind.disabled and context.rgmc_total_score then
                local new_total = G.GAME.chips + context.rgmc_total_score
                if to_big(new_total) > to_big(self.mult * get_blind_amount(G.GAME.round_resets.ante)) then
                    G.GAME.chips = math.floor(new_total / 2)
                    MadLib.manipulate_chips_mult(0,0)
                    MadLib.simple_event(function()
                        ease_dollars(blind.config.extra)
                        return true
                    end, 1,'after')
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
