function MadLib.do_level_up(card,poker_hand,amt)
	update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
		handname = localize(poker_hand, "poker_hands"),
		chips = G.GAME.hands[poker_hand].chips,
		mult = G.GAME.hands[poker_hand].mult,
		level = G.GAME.hands[poker_hand].level,
	})
	level_up_hand(card, poker_hand, nil, amt or 1)
	update_hand_text(
		{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
		{ mult = 0, chips = 0, handname = "", level = "" }
	)
end

return {
    categories = {
        'Tags',
        'Mayhem',
    },
    data = {
        object_type = "Tag",
        key     = "decant",
        atlas   = "tags",
        pos     = MLIB.coords(1,1),
        config = { type = "new_blind_choice", extra = 5 },
        loc_vars = function(self, info_queue)
            local common_hand = G.GAME.MADCAP and MadLib.get_most_played_hand().key or "High Card"
            return MadLib.collect_vars(common_hand, number_format(self.config.extra))
        end,
        in_pool = function()
            local _levels = 0
            MadLib.loop_func(G.GAME.hands, function(v,i)
                _levels = _levels + (v.level - 1)
            end)
            return _levels > 5
        end,
        apply = function(self, tag, context)
            if context.type == self.config.type then
                local chosen_hands = {}
                tag:instayep('+', G.C.PURPLE, function()

                    -- Remove from X random hands
                    for i=1,self.config.extra do
                        MadLib.simple_event(function()
                            local _hands = MadLib.get_loop_func(G.GAME.hands, function(v,i)
                                return v.level > 1 and MadLib.get_item_index(v, chosen_hands) == -1
                            end)
                            local _visible = MadLib.loop_func(G.GAME.hands, function(v,i) return v.visible end)

                            if #hands < math.min(_visible, 5) then
                                _hands = MadLib.get_loop_func(G.GAME.hands, function(v,i) return v.level > 1 end)
                            end

                            local poker_hand = pseudorandom_element(_hands, pseudoseed('decant'))
                            MadLib.do_level_up(card,poker_hand,-1)
                            chosen_hands[#chosen_hands+1] = poker_hand
                            return true
                        end, 0.4, 'after')
                    end
                    -- Level up most played hand (that wasn't leveled down) X tiems
                    MadLib.simple_event(function()
                        local most_played = MadLib.get_highest_match(false,nil,nil,function(k,v)
                            return not chosen_hands[k] and v.played or -1
                        end)
                        MadLib.do_level_up(card,most_played,self.config.extra)
                        return true
                    end, 1.5, 'after')
                    return true
                end, 0.5)
                tag.triggered = true
                return true
            end
        end,
    }
}
