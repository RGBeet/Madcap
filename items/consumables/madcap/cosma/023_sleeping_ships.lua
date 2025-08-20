return {
    categories = {
        'Cosma Tarots',
        'Unusual'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "sleeping_ships",
        atlas   = "cosma",
        pos 		= MLIB.coords(2,2),
        soul_pos	= MLIB.coords(2,3),
        config = { immutable = { jokers = 1 } },
        can_use 	= function(self, card)
            return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
        end,
        hidden = true, -- Hard as hell to get
        use 	= function(self, card, area, copier)
            for i=1,card.ability.immutable.jokers do
                -- Create an Unusual Joker
                MadLib.simple_event(function()
                    play_sound("timpani")
                    local card = create_card("Joker", G.jokers, nil, "rgmc_unusual", nil, nil, nil, "rgmc_sleeping_ships")
                    --check_for_unlock { type = 'spawn_legendary' }
                    card:set_edition({ negative = true })
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:juice_up(0.3, 0.5)
                    return true
                end, 0.4, 'after')
            end
        end
    }
}
