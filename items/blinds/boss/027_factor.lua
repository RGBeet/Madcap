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
            if 
                (not G.GAME.blind.disabled and card.area ~= G.jokers)
                and not SMODS.has_no_rank(card) 
                and MadLib.is_prime(math.floor(SMODS.Ranks[MadLib.get_value(card) or '8'].nominal))
            then
                card:set_debuff(true)
                return true
            end
            return false
        end,
    }
}
