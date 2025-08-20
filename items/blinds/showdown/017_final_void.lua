return {
    data = {
        object_type = 'Blind',
        key     = 'final_void',
        atlas   = "blinds",
        pos     = MLIB.coords(20),
        dollars = 9,
        boss_colour = HEX('5C5C5C'),
        in_pool = function(self)
            return G.playing_cards and #MadLib.get_list_matches(G.playing_cards,function(v)
                return v.edition and v.edition.negative
            end) > (#G.playing_cards / 2) or Madcap.Data.devmode
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            return (not G.GAME.blind.disabled) and not MadLib.list_matches_one(cards, function(v)
                if v.edition and v.edition.negative then
                    G.GAME.blind:wiggle() -- nuh uh!
                    G.GAME.blind.triggered = true
                    return true
                else
                    return false
                end
            end)
        end
    }
}
