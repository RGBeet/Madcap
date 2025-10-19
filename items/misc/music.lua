function Madcap.Funcs.GetMusic(_k, _select, _vol, _sync, _pitch)
    return {
		object_type = "Sound",
		key = _k,
		path = _k..'.ogg',
		volume = _vol or 0.8,
		select_music_track = _select,
		sync = _sync or true,
		pitch = _pitch,
	}
end

local can_play_madcap_music = function()
	return G.GAME and (G.GAME.modifiers.rgmc_deck or G.GAME.modifiers.rgmc_stake or G.GAME.modifiers.rgmc_sleeve)

end

local list = {
    Madcap.Funcs.GetMusic('music_madcap_play',function()
	return can_play_madcap_music() and 2
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_shop',function()
	return can_play_madcap_music()
		and G.shop
		and 3
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_booster',function()
	return can_play_madcap_music()
		and Madcap.Funcs.is_choosing_card()
		and 4
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_cosmaspatia',function()
	return can_play_madcap_music()
		and Madcap.Funcs.is_choosing_card_special()
		and 4
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_celestial',function()
	return can_play_madcap_music()
		and Madcap.Funcs.is_choosing_celestial()
		and 4
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_boss',function()
	return can_play_madcap_music()
		and Madcap.Funcs.get_boss_status() > 0 -- regular boss blind
		and 6
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_unusual',function()
		if G.jokers then
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i]
					and (G.jokers.cards[i].config.center.rarity == "rgmc_unusual"
					or G.jokers.cards[i].config.center.rarity == "rgmc_chaotic")
				then
					return 9999
				end
			end
		end
		return false
	end, 0.8, true),
    Madcap.Funcs.GetMusic('music_madcap_finisher',function()
	return can_play_madcap_music()
		and Madcap.Funcs.is_playing_blind()
		and Madcap.Funcs.get_boss_status() > 0
		and Madcap.Funcs.is_finisher_ante(ante)
		and 18
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_lunacy',function()
	return G.GAME.rgmc_total_mayhem
		and 2000
	end, 0.8, false, 1.0),

    Madcap.Funcs.GetMusic('music_madcap_chaotic_phase1',function()
	return G.GAME.rgmc_superboss == 1
		and 3000
	end, 0.8, false, 1.0),
}

return {
    name = "Music",
    init = function() print("Music!") end,
    items = list
}
