function Madcap.Funcs.get_lowest_rank(group, allow_faces)
	local min_value, lowest = 99, nil
	local ranks = MadLib.get_ranks_from_cards(G.playing_cards, true)
    print(ranks)
    --[[
    MadLib.

	for k, _ in pairs(ranks) do
		local pts = SMODS.Ranks[k].nominal
		if SMODS.Ranks[k].face_nominal > 0 and not allow_faces then pts = min_value-1 end
		if pts < min_value then
			lowest 	= k
			min_value 	= SMODS.Ranks[k].nominal + SMODS.Ranks[k].face_nominal
		end
	end]]
	return 'Ace'
end

return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key 	= 'anti_incantation',
        atlas   = 'sinister',
        pos 	= MLIB.coords(0,2),
        cost 	= 2,
        config	= { select = 0.75, min = 5 },
        loc_vars = function(self, info_queue, card)
            local lowest_rank = Madcap.Funcs.get_lowest_rank(G.playing_cards, false)
            local low_cards = MadLib.get_list_matches(G.playing_cards, function(v)
                return v:get_id() == SMODS.Ranks[lowest_rank].id
            end)
            local num_targets = (low_cards and #low_cards or 0) * card.ability.select
            return MadLib.collect_vars(card.ability.select*100, num_targets, localize(lowest_rank, 'ranks'))
        end,
        can_use = function(self, card)
            return G.playing_cards and #G.playing_cards > 0
        end,
        use 	= function(self, card, area, copier)
            local lowest_rank = Madcap.Funcs.get_lowest_rank(G.playing_cards, false) -- id key
            -- grabs all the cards with the lowest rank
            local low_cards = MadLib.get_list_matches(G.playing_cards, function(v)
                return v:get_id() == SMODS.Ranks[lowest_rank].id
            end)
            -- get the targets
            local num_targets = (low_cards and #low_cards or 0) * card.ability.select
            pseudoshuffle(low_cards)
            -- destroy the targets
            MadLib.number_func(num_targets, function(i)
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
