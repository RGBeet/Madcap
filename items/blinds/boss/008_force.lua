-- Must not play the most played poker hand (selected at start of blind)
return {
    data = {
        object_type = 'Blind',
        key     = 'force',
        atlas   = "blinds",
        pos     = MLIB.coords(7),
        mult    = 1.5,
        dollars = 6,
        boss_colour = HEX('47848B'),
        boss    = { min = 3 },
        loc_vars = function(self)
            return MadLib.collect_vars(localize(MadLib.get_most_played_hand(), 'poker_hands'))
        end,
        set_blind = function(self, reset, silent)
            -- Saves the most played hand from before the blind
            G.GAME.current_round.most_played_poker_hand = MadLib.get_most_played_hand()
        end,
        debuff_hand = function(self, cards, hand, handname, check)
            return handname == G.GAME.current_round.most_played_poker_hand
        end,
    }
}
