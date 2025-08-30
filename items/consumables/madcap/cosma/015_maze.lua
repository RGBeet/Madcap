function Madcap.Funcs.flip_and_do(all_cards,affected_cards,func,speed)
    speed = speed or 1
    MadLib.loop_func(all_cards,function(v, i)
        MadLib.simple_event(function()
            v:highlight(true)
            play_sound('card3', math.random()*0.2 + 0.9, 0.35)
            return true
        end, 0.1/speed, 'after')
        MadLib.simple_event(function()
            v:highlight(false)
            return true
        end, 0.1/speed, 'after')
    end)
    
    -- up
    MadLib.loop_func(all_cards,function(v, i)
        MadLib.simple_event(function()
            play_sound('card3', math.random()*0.2 + 0.9, 0.35)
            v:highlight(true)
            v:flip()
            return true
        end, 0.1/speed, 'after')
    end)
    
    -- change
    MadLib.loop_func(affected_cards,function(v, i)
        MadLib.simple_event(function()
            func(v,card,i)
            return true
        end, 0.05/speed, 'after')
        MadLib.simple_event(function()
            v:juice_up(0.3, 0.5)
            return true
            end, 0.50/speed, 'after')
        end)
    
    -- down
    MadLib.loop_func(all_cards,function(v, i)
        MadLib.simple_event(function()
            v:highlight(false)
            v:flip()
            return true
        end, 0.25/speed, 'after')
    end)
end


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
        can_use = function(self, card)
            return G.hand and
                #G.hand.cards > 0
                and #MadLib.get_list_matches(G.hand.cards, function(v)
                    return not SMODS.has_no_rank(v) and not SMODS.has_no_suit(v)
                end)
        end,
        use = function(self, card, area, copier)

            -- Get list matches
            local valid = MadLib.get_list_matches(G.hand.cards, function(v)
                return not SMODS.has_no_rank(v) and not SMODS.has_no_suit(v)
            end)
            
            pseudoshuffle(valid, pseudoseed('maze_cards'))

            -- Get suits and ranks
            local shuffle_suits, shuffle_ranks = {}, {}
            MadLib.loop_func(valid, function(v)
                table.insert(shuffle_ranks, v.base.value)
                table.insert(shuffle_suits, v.base.suit)
            end)
            local card_ref = MadLib.deep_copy(G.hand.cards)
            
            pseudoshuffle(shuffle_ranks, pseudoseed('maze_ranks'))
            pseudoshuffle(shuffle_suits, pseudoseed('maze_suits'))

            Madcap.Funcs.flip_and_do(G.hand.cards,valid,function(v, card, i)
                local new_suit = shuffle_suits[i]
                local new_rank = shuffle_ranks[i]
                SMODS.change_base(v, new_suit, new_rank)
            end)

            Madcap.Funcs.set_last_cosma(self)
        end
    }
}
