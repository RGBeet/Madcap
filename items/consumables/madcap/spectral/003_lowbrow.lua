Madcap.LowbrowRanks = { "2", "3", "4", "5" }
if MadLib.RankIds['1'] then table.insert(Madcap.LowbrowRanks, MadLib.RankIds['1']) end

return {
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "lowbrow",
        atlas   = "spectrals",
        pos     = MLIB.coords(0,2),
        cost    = 4,
        config  = {
            extra = { odds = 4 }
        },
        can_use = function(self, card)
            return G.hand and #G.hand.cards > 0 -- has at least one card
        end,
        use = function(self, card, area, copier)
            MadLib.flip_cards(MadLib.get_cards_from_shuffled_deck(G.hand.cards, #G.hand.cards, function(c)
                return SMODS.pseudorandom_probability(card, 'lowbrow', 1, card.ability.extra.odds)
            end), function(c)
                MadLib.simple_event(function ()
                    SMODS.change_base(c, SMODS.Suits[c.base.suit].value, pseudorandom_element(list, pseudoseed('lowbrow'))) -- change da rank
                    return true
                end)
            end)
        end,
    }
}
