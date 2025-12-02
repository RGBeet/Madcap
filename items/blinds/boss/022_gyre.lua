return {
    data = {
        object_type = 'Blind',
        key     = 'gyre',
        atlas   = "blinds",
        pos     = MLIB.coords(28),
        min_ante = 3,
        mult = 1.618,
        boss_colour = HEX('943534'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        set_blind = function(self, reset, silent)
            print(MadLib.RankTypes.Fibonacci)
        end,
        recalc_debuff = function(self, card, from_blind)
            if card.area ~= G.jokers and not G.GAME.blind.disabled then
                if
                    not SMODS.has_no_rank(card)
                    and MadLib.has_fib_rank(card)
                then
                    return true
                end
                return false
            end
        end,
    }
}
