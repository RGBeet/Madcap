function Madcap.Funcs.set_last_cosma(self)
    G.GAME.last_cosma_tarot = self.key
    print(self.key)
end

return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "demise",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,0),
        cost 	= 6,
        config	= { odds = 3 },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(self, 1, card.ability.odds, 'demise')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom), localize{ type = 'name_text', key = G.GAME.rgmc_demise_card or 'c_rgmc_demise', set = 'CosmaTarot' })
        end,
        can_use = function(self, card)
            return #G.consumeables.cards < G.consumeables.config.card_limit
        end,
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            local card = nil
            --select a random cosma tarot from 1-21. Has a 1 in 200 chance to give Sleeping Ships instead.

            
            if SMODS.pseudorandom_probability(card, 'demise', 1, 100) then
                card = create_card("CosmaTarot", G.consumeables, nil, nil, true, true, "c_rgmc_sleeping_ships")
            elseif SMODS.pseudorandom_probability(card, 'demise', 1, card.ability.extra.odds) and G.GAME.rgmc_demise_card then
                card = create_card('CosmaTarot', G.consumeables, nil, nil, nil, nil, G.GAME.rgmc_demise_card, 'demise')
            else
                card = create_card("CosmaTarot", G.consumeables)
            end

            if card then
                play_sound('timpani')
                card:add_to_deck()
                G.consumeables:emplace(card)
            end
            
            used_tarot:juice_up(0.3, 0.5)
        end
    }
}
