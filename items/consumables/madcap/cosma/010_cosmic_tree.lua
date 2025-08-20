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
        config	= { extra = { money_a = 2, money_b = 2} },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(math.ceil(card.ability.extra.money_a or 2), math.ceil(card.ability.extra.money_b or 2))
        end,
        can_use = function(self, card)
            return G.deck and G.deck.cards
        end,
        use = function(self, card, area, copier)
            local suits, ranks 	= Madcap.Funcs.get_num_suits_and_ranks(G.playing_cards)
            local rank_cash 	= math.floor(#ranks/3) * card.ability.extra.money_a
            local suit_cash 	= math.floor(#suits/2) * card.ability.extra.money_b
            local base 			= card.ability.extra.money or 2
            ease_dollars(rank_cash + suit_cash)
        end
    }
}
