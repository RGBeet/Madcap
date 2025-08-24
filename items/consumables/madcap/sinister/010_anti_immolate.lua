return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_immolate',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,9),
        cost 	= 2,
        config	= { extra = { add = 5, money = 10 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.add, card.ability.extra.money)
        end,
        can_use = function(self, card)
            return true
        end,
        use 	= function(self, card, area, copier)
            MadLib.simple_event(function()
                local _first_dissolve = nil
                local new_cards = {}
                MadLib.number_func(self.config.extra.add or 5, function(i)
                    new_cards[i] = create_playing_card(nil, G.deck)
                    new_cards[i]:set_ability(G.P_CENTERS.m_rgmc_vino)
                end)
                SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
                ease_dollars(-self.config.extra.money, true)
                return true
            end)
        end
    }
}
