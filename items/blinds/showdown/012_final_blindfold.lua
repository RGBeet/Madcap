return {
    data = {
        object_type = 'Blind',
        key     = 'final_blindfold',
        atlas   = "blinds",
        pos     = MLIB.coords(15),
        dollars = 8,
        boss_colour = HEX('CFBB8F'),
        in_pool = function(self)
            return G.GAME.blinds_skipped and G.GAME.blinds_skipped > 0 or Madcap.Data.devmode
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(self.config.extra.mult_increase or 0.25)
        end,
        set_blind = function(self, reset, silent)
            if not G.GAME.blind.disabled then
                local blind_increase =  (1 + (G.GAME.blinds_skipped * self.config.extra.mult_increase))
                local new_amount = G.GAME.blind.chips * blind_increase
                tell_stat(blind_increase)
                if blind_increase > 1 then
                    tell("Ooh, now you've done it! You've increased the blind by X" .. tostring(blind_increase) .. "!!")
                    G.GAME.blind.triggered = true
                end
                G.GAME.rgmc_boss_blind_penalty = new_amount / G.GAME.blind.chips
                G.GAME.blind.chips = new_amount
                return true
            end
        end,
        disable = function(self, silent)
            if G.GAME and G.GAME.blind.disabled then
                G.GAME.blind.chips = G.GAME.blind.chips / (G.GAME.rgmc_boss_blind_penalty or 1)
                G.GAME.rgmc_boss_blind_penalty = nil
            end
        end,
        defeat = function(self, silent)
            G.GAME.rgmc_boss_blind_penalty = nil
        end,
    }
}
