
local mus_play = { -- Play music
	object_type = "Sound",
	key = "music_madcap_play",
	path = "music_madcap_play.ogg",
	volume = 0.8,
	select_music_track = function()
		return G.GAME
            and G.GAME.modifiers.rgmc_deck
            and RGMC.funcs.is_playing_blind()
            and not G.GAME.blind.boss
	end,
}

local mus_shop = { -- Shop music
	object_type = "Sound",
	key = "music_madcap_shop",
	path = "music_madcap_shop.ogg",
	volume = 0.8,
	select_music_track = function()
		return G.GAME
            and G.GAME.modifiers.rgmc_deck
            and G.STATE == G.STATES.SHOP
	end,
}

local mus_booster = { -- Booster music
	object_type = "Sound",
	key = "music_madcap_booster",
	path = "music_madcap_booster.ogg",
	volume = 0.8,
	select_music_track = function()
		return G.GAME
            and G.GAME.modifiers.rgmc_deck
            and RGMC.funcs.is_choosing_card()
	end,
}

local mus_celestial = { -- Celestial music
	object_type = "Sound",
	key = "music_madcap_celestial",
	path = "music_madcap_celestial.ogg",
	volume = 0.8,
	select_music_track = function()
		return G.GAME
            and G.GAME.modifiers.rgmc_deck
            and RGMC.funcs.is_choosing_celestial()
	end,
}

local mus_boss = { -- Boss Blind music
	object_type = "Sound",
	key = "music_madcap_boss",
	path = "music_madcap_boss.ogg",
	volume = 0.8,
	select_music_track = function()
		return G.GAME
            and G.GAME.modifiers.rgmc_deck
            and RGMC.funcs.is_playing_blind()
            and RGMC.funcs.get_boss_status() > 0 -- regular boss blind
	end,
}

local mus_finisher = { -- Finisher Blind music
	object_type = "Sound",
	key = "music_madcap_finisher",
	path = "music_madcap_finisher.ogg",
	volume = 0.8,
	select_music_track = function()
		return G.GAME
            and G.GAME.modifiers.rgmc_deck
            and RGMC.funcs.is_playing_blind()
            and RGMC.funcs.get_boss_status() == 2 -- finisher boss blind (on winning ante?)
            and RGMC.funcs.is_finisher_ante(ante)
	end,
}

local list = {
    mus_play,
    mus_shop,
    mus_booster,
    mus_celestial,
    mus_boss,
    mus_finisher
}

return {
    name = "Music",
    init = function() print("Music!") end,
    items = list
}
