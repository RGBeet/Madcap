function Madcap.Funcs.get_lowest_suit(area)
	local suits, min_value = {}, #area+1
	local retval = nil
	MadLib.loop_func(area, function(v)
		suits[v.base.suit] = suits[v.base.suit] and suits[v.base.suit]+1 or 0
	end)
	MadLib.loop_func(suits, function(v)
		if v < min_value then
			retval = k
			min_value = v
		end
	end)
	return retval
end

return {
    data = {
        object_type = "Joker",
        key 	= 'finity_hoop',
		atlas 	= 'jokers_finity',
        pos 		= MLIB.coords(1,0),
		soul_pos  	= MLIB.coords(1,1),
		rarity = 'finity_showdown',
		demicoloncompat = false,
		config =  { },
		loc_vars = function(self, info_queue, card)
			local suit = G.playing_cards and get_lowest_suit(G.playing_cards) or "Clubs"
			return MadLib.collect_vars(localize(suit, 'suits_plural'))
		end,
		calculate = function(self, card, context)
		end
    }
}
