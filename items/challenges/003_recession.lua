Madcap.ChallengeDecks['recession'] = {}
MadLib.loop_func({ 'T','9','8','7','6','5','4','3','2' }, function(rank)
    MadLib.loop_func( { 'H','S','D','C' }, function(suit)
        table.insert(Madcap.ChallengeDecks['recession'], {r = rank, s = suit})
    end)
end)
MadLib.loop_func( { 'H','S','D','C' }, function(suit)
    table.insert(Madcap.ChallengeDecks['recession'], {r = '2', s = suit, e = 'm_gold' })
end)

return {
    data = {
        object_type = "Challenge",
        key     = 'recession',
        stake   = "stake_blue",
        rules = {
            custom = {
                { id = 'rgmc_rule_halved_interest' }, -- interest is halved
                { id = 'bankrupt_kill' }, -- going bankrupt kills you
            modifiers =
                {id = 'joker_slots', value = 1}, -- +1 joker slot
            },
        },
        jokers = {
            { id = 'j_bootstraps', edition = 'rgmc_luxury', eternal = true },
            { id = 'j_credit_card', edition = 'rgmc_luxury' },
        },
        deck = {
            type = "Challenge Deck",
            cards   = Madcap.ChallengeDecks['recession']
        },
    }
}
