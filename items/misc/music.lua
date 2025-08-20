local list = {
    Madcap.Funcs.GetMusic('music_madcap_play',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_playing_blind()
		and not G.GAME.blind.boss
		and 2
	end, 0.8, true),
    Madcap.Funcs.GetMusic('music_madcap_shop',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and G.STATE == G.STATES.SHOP
		and 2
	end, 0.8, true),
    Madcap.Funcs.GetMusic('music_madcap_booster',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_choosing_card()
		and 2
	end, 0.8, true),
    Madcap.Funcs.GetMusic('music_madcap_celestial',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_choosing_celestial()
		and 2
	end, 0.8, true),
    Madcap.Funcs.GetMusic('music_madcap_boss',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_playing_blind()
		and Madcap.Funcs.get_boss_status() > 0 -- regular boss blind
		and 6
	end, 0.8, true),
    Madcap.Funcs.GetMusic('music_madcap_finisher',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_playing_blind()
		and Madcap.Funcs.get_boss_status() > 0
		and Madcap.Funcs.is_finisher_ante(ante)
		and 18
	end, 0.8, true),
    Madcap.Funcs.GetMusic('music_madcap_farocar',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and G.GAME.modifiers.rgmc_deck_farocar
		and 4
	end, 0.8, true),
}

return {
    name = "Music",
    init = function() print("Music!") end,
    items = list
}
