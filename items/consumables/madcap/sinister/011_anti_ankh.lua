return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_ankh',
        atlas   = 'sinister',
        pos 	= MLIB.coords(1,0),
        cost 	= 2,
        can_use = function(self, card)
            return G.jokers and #G.jokers.cards > 0
        end,
        use 	= function(self, card, area, copier)
            local chosen_joker = pseudorandom_element(G.jokers.cards, 'ankh_choice')
            MadLib.simple_event(function()
                -- make joker
                local copied_joker = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition)
                copied_joker:start_materialize()
                copied_joker:add_to_deck()
                if copied_joker.edition then copied_joker:set_edition(copied_joker.edition, true) end
                -- add stickers
                copied_joker.ability.eternal 		= true
                copied_joker.ability.rgmc_engraved 	= true
                G.jokers:emplace(copied_joker)
                G.jokers.config.card_limit = lenient_bignum(G.jokers.config.card_limit + 1)
                return true
            end)
        end
    }
}
