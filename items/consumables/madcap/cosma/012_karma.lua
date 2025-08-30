function MadLib.get_full_nominal(card)
    local rank = MadLib.get_value_from_id(card:get_id())
    if (not rank) or SMODS.has_no_rank(card) then return -99 end
    return rank and rank.nominal + (rank.face_nominal or 0)
end

return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "karma",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,1),
        cost 	= 6,
        config	= { select = 2, extra = 2 },
        loc_vars = function(self, info_queue, card)
            local selection = math.ceil(MadLib.clamp(card.ability.select, 1, (G.hand and #G.hand.cards/2 or 4) * 2))
            return MadLib.collect_vars(selection, number_format(math.abs(card.ability.extra)))
        end,
        can_use = function(self, card)
            return G.hand and #G.hand.cards > 1
        end,
        use = function(self, card, area, copier)
            -- targets cards with no enhancement
            local selection = math.ceil(MadLib.clamp(card.ability.extra, 1, #G.hand.cards/2 * 2))
            local high = MadLib.shuffle_sort_list(G.hand.cards, selection, function(v)
                return true
            end, function(a,b)
                return MadLib.get_full_nominal(a) > MadLib.get_full_nominal(b)
            end)
            tell(tostring(#high) .. ' in high')

            local low = MadLib.shuffle_sort_list(G.hand.cards, selection, function(v)
                return true
            end, function(a,b)
                return MadLib.get_full_nominal(a) < MadLib.get_full_nominal(b)
            end)
            tell(tostring(#low) .. ' in low')

            MadLib.loop_func(high, function(v)
                MadLib.simple_event(function()
                    play_sound('card3', math.random()*0.2 + 0.9, 0.35)
                    v:highlight(true)
                    v:flip()
                    return true
                end, 0.1, 'after')
                MadLib.simple_event(function()
                    assert(SMODS.modify_rank(v, -card.ability.extra))
                    return true
                end, 0.1, 'after')
                MadLib.simple_event(function()
                    v:flip()
                    return true
                end, 0.1, 'after')
            end)
            MadLib.loop_func(low, function(v)
                MadLib.simple_event(function()
                    play_sound('card3', math.random()*0.2 + 0.9, 0.35)
                    v:highlight(true)
                    v:flip()
                    return true
                end, 0.1, 'after')
                MadLib.simple_event(function()
                    assert(SMODS.modify_rank(v, card.ability.extra))
                    return true
                end, 0.1, 'after')
                MadLib.simple_event(function()
                    v:flip()
                    return true
                end, 0.1, 'after')
            end)

            MadLib.loop_func(MadLib.get_combined_list(high,low), function(v)
                MadLib.simple_event(function()
                    v:juice_up(0.3,0.3)
                    return true
                end, 0.2, 'after')
                MadLib.simple_event(function()
                    v:highlight(false)
                    return true
                end, 0.2, 'after')
            end)
            Madcap.Funcs.set_last_cosma(self)
        end
    }
}
