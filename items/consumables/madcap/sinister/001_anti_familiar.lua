return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key 	= 'anti_familiar',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,0),
        cost 	= 2,
        config	= { select = 0.5 },
        can_use = function(self, card)
            return G.playing_cards and MadLib.list_matches_one(list, function(v)
                return v:is_face()
            end)
        end,
        use = function(self, card, area, copier)
            local selection = MadLib.shuffle_sort_list(G.playing_cards, #G.playing_cards, function(v)
                return v:is_face() -- is face card
            end, prioritize_vulnerable_cards)
            -- removes up to 1/2 of face cards
            MadLib.number_func(math.ceil(#selection/2), function(i)
                local _card = selection[i]
                local _first_dissolve = nil
                MadLib.simple_event(function()
                    _card:start_dissolve(nil, _first_dissolve)
                    _first_dissolve = true
                end, 0.1, 'after')
            end)
        end
    }
}
