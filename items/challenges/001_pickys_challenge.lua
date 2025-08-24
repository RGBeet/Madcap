return {
    data = {
        object_type = "Challenge",
        key     = 'pickys_challenge',
        stake   = "stake_purple",
        rules = {
        custom = {
            { id = 'rgmc_rule_waveworx' }, -- all levels at 0 except straight
        },
        modifiers =
            {id = 'joker_slots', value = 1}, -- +1 joker slot
        },
        jokers = {
            { id = 'j_rgmc_legend_picky', eternal = true },
            { id = 'j_rgmc_waveworx', eternal = true },
        },
        deck = {
            type        = "Challenge Deck",
            no_ranks    = { 'Ace', '7' }
        },
    },
}
