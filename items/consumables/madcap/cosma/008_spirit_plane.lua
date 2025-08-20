return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "spirit_plane",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,7),
        cost 	= 5,
        config	= { select = 2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select))
        end,
        can_use = function(self, card)
            return (G.hand and G.hand.cards and #G.hand.cards > 1)
                and (G.GAME.blind_info and G.GAME.blind_info.suits_played)
        end,
        use = function (self, card, area, copier)
            -- targets cards with no enhancement
            local sorted_hand = MadLib.shuffle_sort_list(G.hand.cards, self.config.select or 2, nil, function(a,b)
                return (a:has_enhancement() and 0 or 1) > (b:has_enhancement() and 0 or 1)
            end)
            Madcap.Funcs.use_cosma(self, card, area, copier, 3, function(v)
                return true -- must have suit
            end, function(v, card)
                local _enhancement = pseudorandom_element(_enhancement, pseudoseed('spirit_plane')) -- pick a suit
                MadLib.simple_event(function()
                    v:set_ability(G.P_CENTERS[_enhancement.center.key])
                    return true
                end, 0.2, 'after')
            end)
        end
    }
}
