local list = {
    Madcap.Funcs.GetMusic('music_madcap_play',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and 2
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_shop',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and G.shop
		and 3
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_booster',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_choosing_card()
		and 4
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_celestial',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_choosing_celestial()
		and 4
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_boss',function()
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
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
	return G.GAME
		and G.GAME.modifiers.rgmc_deck
		and Madcap.Funcs.is_playing_blind()
		and Madcap.Funcs.get_boss_status() > 0
		and Madcap.Funcs.is_finisher_ante(ante)
		and 18
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_farocar',function()
	return G.pack_cards
        and G.pack_cards.cards
        and G.pack_cards.cards[1]
        and G.pack_cards.cards[1].ability.set == "p_rgmc_oops_all_spam"
		and 4
	end, 0.8, true),

    Madcap.Funcs.GetMusic('music_madcap_lunacy',function()
	return G.GAME and G.GAME.rgmc_total_mayhem
		and 20
	end, 0.8, false, 1.0),
}

return {
    name = "Music",
    init = function() print("Music!") end,
    items = list
}
