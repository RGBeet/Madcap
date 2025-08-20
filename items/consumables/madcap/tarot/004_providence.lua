Madcap.ProvidenceEditions = MadLib.get_list_matches(MadLib.PointValues.Editions, function(v) return v < 10 end)
return {
    data = {
        object_type = 'Consumable',
        set     = "Tarot",
        key     = "providence",
        atlas   = "tarots",
        pos     = MLIB.coords(0,3),
        cost    = 4,
        config = {
            extra = { odds = 4, max_cards	= 2 },
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(self, 1, card.ability.extra.odds, 'providence')
            return MadLib.collect_vars(_numer, _denom, (card.ability.extra.max_cards or 2))
        end,
        can_use = function(self, card)
            return G.hand and G.hand.cards and #G.hand.cards > 0 -- is there a hand of cards available?
        end,
        use = function(self, card, area, copier)
            if SMODS.pseudorandom_probability(card, 'providence', 1, card.ability.extra.odds) then
                local bestish = MadLib.shuffle_sort_list(G.hand.cards, math.min(card.ability.extra.max_cards, #G.hand.cards), function(v)
                    return not v.edition -- no edition
                end, function(a,b)
                    return (MadLib.get_card_total_value(a) + math.random()*8 - 4) > MadLib.get_card_total_value(b) -- goes for enhanced cards first
                end)
                MadLib.flip_cards(bestish, function(c)
                    c:set_edition(MadLib.get_weighted_edition(Madcap.ProvidenceEditions))
                end, nil, function(c)
                    c:juice_up(0.3, 0.3)
                end)
            end
        end,
    }
}
