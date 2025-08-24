function Madcap.Funcs.get_num_suits_and_ranks(cards)
	local rank_map, suit_map 	= {}, {}
	local rank_list, suit_list	= {}, {}
		MadLib.loop_func(cards, function(v)
			if not rank_map[v.base.value] then
				rank_map[v.base.value] = true
				table.insert(rank_list,v.base.suit)
			end
			if not suit_map[v.base.suit] then
				suit_map[v.base.suit] = true
				table.insert(suit_list,v.base.suit)
			end
		end)
	return rank_list, suit_list
end

return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "cosmic_tree",
        atlas   = "cosma",
        pos 	= MLIB.coords(0,9),
        cost 	= 7,
        config	= { extra = { dollars = 2} },
        loc_vars = function(self, info_queue, card)
            local total_money = 0
            if G.playing_cards then
                local suits, ranks 	= Madcap.Funcs.get_num_suits_and_ranks(G.playing_cards)
                local rank_cash 	= math.floor(#ranks/3) * card.ability.extra.dollars
                local suit_cash 	= math.floor(#suits/2) * card.ability.extra.dollars
                total_money         = rank_cash + suit_cash
            end
            return MadLib.collect_vars(number_format(math.ceil(card.ability.extra.dollars)), number_format(math.ceil(card.ability.extra.dollars)), number_format(total_money))
        end,
        can_use = function(self, card)
            return G.deck and G.deck.cards
        end,
        use = function(self, card, area, copier)
            local suits, ranks 	= Madcap.Funcs.get_num_suits_and_ranks(G.playing_cards)
            local rank_cash 	= math.floor(#ranks/3) * card.ability.extra.dollars
            local suit_cash 	= math.floor(#suits/2) * card.ability.extra.dollars
            ease_dollars(rank_cash + suit_cash)
        end
    }
}
