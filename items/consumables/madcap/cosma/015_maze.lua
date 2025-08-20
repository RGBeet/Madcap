return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "maze",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,4),
        cost 	= 6,
        config	= { select = 2, extra = 2 },
        can_use = function(self, card)
            return G.hand and #G.hand.cards > 0
        end,
        use = function(self, card, area, copier)
            local shuffled_deck = MadLib.shuffle_sort_list(G.hand.cards, nil, function(v)
                return not SMODS.has_no_rank(self) and not SMODS.has_no_suit(self)
            end, function(a,b)
                if math.random() < 0.5 then
                    return true
                else
                    return false
                end
            end)

            local shuffle_suits, shuffle_ranks = {}, {}
            local save_n = math.min(self.config.select, #G.hand.cards)
            for i = save_n+1, #G.hand.cards do -- for the first
                table.insert(shuffle_suits, shuffled_deck[i].base.suit)
                table.insert(shuffle_ranks, shuffled_deck[i].base.value)
            end

            -- shuffle everything
            pseudoshuffle(shuffle_ranks, pseudoseed('rgmc_maze'))
            pseudoshuffle(shuffle_suits, pseudoseed('rgmc_maze'))

            local change_cards = {}

            for i = save_n+1, #G.hand.cards do -- for the first
                table.insert(change_cards, G.hand.cards[i - save_n])
            end

            Madcap.Funcs.use_cosma(self, card, area, copier, #change_cards, function(v,card,i)
                return (v.base.value ~= shuffle_ranks[i]) or (v.base.suit ~= shuffle_suits[i])
            end, function(v)
                assert(SMODS.change_base(v, shuffle_suits[i], shuffle_ranks[i]))
                v:juice_up(0.3, 0.5)
            end)
        end
    }
}
