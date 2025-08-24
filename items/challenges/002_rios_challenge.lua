Madcap.ChallengeDecks = { }

Madcap.ChallengeDecks['rios_challenge'] = {}
MadLib.loop_func({ 'A','A','K','K','Q','Q','9','8','7','6','5','4','3' }, function(rank)
    MadLib.loop_func( { 'H','S','D','C' }, function(suit)
        table.insert(Madcap.ChallengeDecks['rios_challenge'], {r = rank, s = suit})
    end)
end)

return {
    data = {
        object_type = "Challenge",
        key     = 'rios_challenge',
        stake   = "stake_blue",
        rules = {
            custom = {
                { id = 'rgmc_rule_rio' }, -- aces, queens, and kings are 3X more likely to appear in standard packs?
            },
        },
        jokers = {
            { id = 'j_rgmc_legend_rio', eternal = true },
        },
        deck = {
            type    = "Challenge Deck",
            cards   = Madcap.ChallengeDecks['rios_challenge']
        },
    }
}
