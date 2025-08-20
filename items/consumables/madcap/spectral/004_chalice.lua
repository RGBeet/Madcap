return {
    categories = {
        'New Suits'
    },
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "chalice",
        atlas   = "spectrals",
        pos     = MLIB.coords(0,7),
        cost    = 4,
        config  = { suit = 'rgmc_goblets' },
        can_use = function(self, card)
            return G.hand and #G.hand.cards > 0
        end,
        use = function(self, card, area, copier)
            Madcap.Funcs.set_special_suits(true) -- special suits achieved
            -- check light suit cards
            Madcap.Funcs.select_cards(self, card, copier, G.hand.cards, function(c)
                if not MadLib.has_suit_in_list(c,MadLib.SuitTypes.Light) or c.base.suit == card.ability.suit then return false end

                MadLib.simple_event(function()
                    SMODS.change_base(c, SMODS.Suits[card.ability.suit].value, pseudorandom_element(list, pseudoseed("chalice")))
                    return true
                end)
            end)
        end
    }
}
