return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_ouija',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,7),
        cost 	= 2,
        config	= { extra = 0.5 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra * 100)
        end,
        can_use = function(self, card)
            return MadLib.list_matches_one(G.playing_cards, function(v)
                return not v:is_rankless() -- has a suit
            end)
        end,
        use 	= function(self, card, area, copier)
		local _ranks = {}
            MadLib.loop_func_table(MadLib.get_ranks_from_cards(G.playing_cards), function(k,v) table.insert(_ranks,k) end)
            local _pick = pseudorandom_element(_suit,pseudoseed('rgmc_anti_ouija'))
            local selection = MadLib.shuffle_sort_list(G.playing_cards, #G.playing_cards, function(v)
                return v:get_id() == _pick
            end, prioritize_vulnerable_cards)
            MadLib.number_func(math.ceil(#selection * self.config.extra ), function(i)
                local _card = selection[i]
                local _first_dissolve = nil
                MadLib.simple_event(function()
                    _card:start_dissolve(nil, _first_dissolve)
                    _first_dissolve = true
                    return true
                end, 0.08, 'after')
            end)
        end
    }
}
