return {
    data = {
        object_type = 'Blind',
        key     = 'factor',
        atlas   = "blinds",
        pos     = MLIB.coords(26),
        min_ante = 3,
        boss_colour = HEX('A28345'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        recalc_debuff = function(self, card, from_blind)
            if not G.GAME.blind.disabled and card.area ~= G.jokers and MadLib.check_pattern_rank(MadLib.is_prime, card) then
                card:set_debuff(true)
                return true
            else
                return false
            end
        end,
    }
}
