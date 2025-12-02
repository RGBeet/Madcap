function Madcap.Funcs.has_nonstandard_cards(cards,percentage)
    return #MadLib.get_list_matches(cards, function(v)
        return not MadLib.list_matches_one(MadLib.SuitTypes.Base, function(v2) return v2 == v.base.suit end)
            or not MadLib.list_matches_one(MadLib.RankTypes.Base, function(v2) return v2 == v.base.value end)
    end) > #cards * (percentage or 0.5)
end

return {
    categories = { 'Parallel Suits' },
    data = {
        object_type = 'Blind',
        key     = 'final_horn',
        atlas   = "blinds",
        pos     = MLIB.coords(45),
        boss_colour = HEX('DA9100'),
        in_pool = function(self)
            return (G.playing_cards 
                and Madcap.Funcs.has_nonstandard_cards(G.playing_cards, 0.5)) 
                or Madcap.Data.devmode
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            return G.GAME.blind.disabled 
                and not Madcap.Funcs.has_nonstandard_cards(G.hand.cards, 1)
        end,
    }
}
