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
        config	= { select = 3, extra = 2 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.select), number_format(card.ability.extra))
        end,
        can_use = function(self, card)
            return G.hand and
                #G.hand.cards > card.ability.select
                and #MadLib.get_list_matches(G.hand.cards, function(v)
                    return not SMODS.has_no_rank(v)
                    and not SMODS.has_no_suit(v)
                end) > self.config.select
        end,
        use = function(self, card, area, copier)

            -- Get list matches
            local seed = pseudoseed('maze')
            local valid = copy_table(G.hand.cards)
            pseudoshuffle(valid, seed)

            -- Get suits and ranks
            local shuffle_suits, shuffle_ranks = {}, {}
            local save_n = math.min(self.config.select, #G.hand.cards)
            MadLib.loop_func(valid, function(v,i)
                if not i > save_n then return end
                table.insert(shuffle_ranks, v.base.value)
                table.insert(shuffle_suits, v.base.suit)
            end)
            pseudoshuffle(shuffle_ranks, seed)
            pseudoshuffle(shuffle_suits, seed)

            local change_suits, change_ranks = 0, 0
            for i=save_n, #G.hand.cards do
                if G.hand.cards[i].base.value ~= shuffle_ranks[i-save_n+1] then change_ranks = change_ranks + 1 end
                if G.hand.cards[i].base.suit ~= shuffle_suits[i-save_n+1] then change_suits = change_suits + 1 end
            end

            --function Madcap.Funcs.use_cosma(self, card, area, copier, num_cards, check, func)
            Madcap.Funcs.use_cosma(self, card, area, copier, #change_cards, function(v,c,i)
                return (v.base.value ~= shuffle_ranks[i]) or (v.base.suit ~= shuffle_suits[i])
            end, function(v)
                assert(SMODS.change_base(v, shuffle_suits[i], shuffle_ranks[i]))
                v:juice_up(0.3, 0.5)
            end)
        end
    }
}
