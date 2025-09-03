function Madcap.Funcs.check_pattern_rank(_func, _card)
    return _card and _func and _func(math.floor(_card.base.nominal) or false) or false
end

return {
    data = {
        object_type = 'Blind',
        key     = 'figure',
        atlas   = "blinds",
        pos     = MLIB.coords(27),
        min_ante = 3,
        boss_colour = HEX('A65096'),
        in_pool = function(self)
            return Madcap.Data.devmode
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            local pass = MadLib.list_matches_all(cards, function(v)
                return SMODS.has_no_rank(card)
                    or SMODS.Ranks[MadLib.get_value(v)].nominal < 10
            end) or G.GAME.blind.disabled
            if not pass then
                G.GAME.blind:wiggle() -- nuh uh!
                G.GAME.blind.triggered = true
            end
            return not pass
        end,
    }
}
