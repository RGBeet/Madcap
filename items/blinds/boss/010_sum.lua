-- Used to get chip value for The Sum
function Madcap.Funcs.get_sum_chips(self)
    local chippies = 0
    for key, _ in pairs(G.GAME.round_resets.blind_choices) do
        local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[key]]
        local blind_key = bl.key
        if blind_key ~= self.key then chippies = chippies + get_blind_amount(G.GAME.round_resets.ante) * (bl.mult or 1) end
    end
    return chippies
end

-- Blind Requirement equals the sum of the previous Blind scores
return {
    data = {
        object_type = 'Blind',
        key     = 'sum',
        atlas   = "blinds",
        pos     = MLIB.coords(9),
        mult    = 1.5,
        dollars = 6,
        mult    = 0,
        boss_colour = HEX('423894'),
        in_pool = function(self)
            return true
        end,
        rgmc_ante_start = function(self)
            G.GAME.blind.chips = Madcap.Funcs.get_sum_chips(self)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true
        end,
        set_blind = function(self, reset, silent)
			Madcap.Funcs.build_up_blind_chips(Madcap.Funcs.get_ante_blind_chips(self))
			print('SUMMING TIME!')
			--local new_score = Madcap.Funcs.get_sum_chips(self)
			delay(2.0)
            G.GAME.blind.triggered = true
            return true
        end,
        defeat = function(self, silent)
            -- no longer needed
            self.mult = 0
        end,
    }
}
