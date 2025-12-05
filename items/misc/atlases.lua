local con	= 'consumables/'
local mis	= 'misc/'

local create = MadLib.create_atlas
local crtsqr = MadLib.create_square_atlas
local crtbld = MadLib.create_blind_atlas
local crtanim = MadLib.create_anim_atlas

local atlases = {
	-- the faithful M:
	create('placeholder', 	mis..'placeholder.png'),
	crtsqr('modicon', 		mis..'modicon.png', 32),
	-- the jonklers
	create('jokers', 			'jokers/base_jokers.png'),
	create('jokers_legendary', 	'jokers/legendary.png'),
	crtsqr('spam', 				'jokers/spam.png', 95),
	-- consumeables
	create('tarots', 		con..'tarot.png'),
	create('spectrals', 	con..'spectral.png'),
	create('planets', 		con..'planet.png'),
	create('cosma', 		con..'cosma.png'),
	create('sinister', 		con..'sinister.png'),
	create('spatia', 		con..'spatia.png'),
	create('potentia', 		con..'potentia.png'),
	-- deck stuff
	create('decks', 		'decks/base_decks.png'),
	create('deck_lunacy', 	'decks/lunacy.png'),
	-- misc stuff
	create('seals', 		mis..'seals.png'),
	create('tags', 			mis..'tags.png',34,34),
	create('antags', 		mis..'antags.png',34,34),
	create('seals', 		mis..'seals.png'),
	create('enhancements', 	mis..'enhancements.png'),
	create('stickers', 		mis..'stickers.png'),
	create('boosters', 		mis..'boosters.png'),
	create('vouchers', 		mis..'vouchers.png'),
	crtsqr('stakes', 			mis..'stakes.png', 29),
	create('stake_stickers', 	mis..'stake_stickers.png'),
	crtsqr('ui_suits', 		mis..'ui_suits.png', 18),
	crtsqr('ui_suits_hc', 	mis..'ui_suits_hc.png', 18),
	crtbld('blinds', 			'blinds/bl_base.png', 21),
	crtbld('blinds_chaotic', 	'blinds/bl_chaotic.png', 21),
	crtanim('luxury_shoppe_sign', 	mis..'luxury_shoppe_sign.png', 4, 113, 57),
	crtanim('impound_shop_sign', 	mis..'impound_shop_sign.png', 4, 113, 57),
	--crtsqr('stakes', 'stakes.png', 29),
}


local suits			= { 'bs', 'ns' }
local ranks			= { 'br', 'nr', 'hr', 'ur' }
local contrasts		= { 'lc', 'hc' }

MadLib.loop_grid(suits, ranks, function(_s,_r)
	if _s == 'bs' and _r == 'br' then return end -- no need for this lol
	MadLib.loop_func(contrasts, function(_c)
		local atlas_id = _s .. '_'.. _r .. '_' .. _c
		tell('Loading atlas ' .. atlas_id .. '...')
		table.insert(atlases, create(atlas_id, 'cards/' .. _s .. '_'.. _r .. '_' .. 'lc' .. '.png'))
	end)
end)



--[[
	TODO:

	- bunco suits 			+ madcap ranks / OL ranks
	- paperback suits 		+ madcap ranks / OL ranks
	- unstable ranks		+ madcap suits / OL ranks

	- entropy suit			+ madcap ranks / OL ranks
	- minty 3s				+ madcap ranks / OL ranks
	- entropy rank			+ madcap suits / OL ranks
	- royal family ranks	+ madcap suits / OL ranks

	- pure madcap ranks (aiko)
	- pure madcap suits (aiko)

]]

local add_atlases = function(add)
	MadLib.loop_func(add, function(v) table.insert(atlases, v) end)
end


local unstable_enabled = next(SMODS.find_mod("UnStable"))

if unstable_enabled then
	add_atlases({
		create('ns_unstb_ex_lc', 'cards/crossmod/ns_unstb_ex_lc.png'),
		create('ns_unstb_ex_hc', 'cards/crossmod/ns_unstb_ex_lc.png'),
		create('ns_unstb_ex2_lc', 'cards/crossmod/ns_unstb_ex2_lc.png'),
		create('ns_unstb_ex2_hc', 'cards/crossmod/ns_unstb_ex2_lc.png'),
	})
end


local load_crossmod_ranks = function(sprites,mp)
	MadLib.loop_func(sprites, function(spr)
		local id_full = mp..'_'..spr..'_'
		tell_stat('id',id_full)
		add_atlases({
			create(id_full..'lc', 'cards/crossmod/'..id_full..'lc.png'),
			create(id_full..'hc', 'cards/crossmod/'..id_full..'lc.png')
		})
	end)
end
-- Fleurons/Halberds suits
if next(SMODS.find_mod("Bunco")) then
	load_crossmod_ranks({'hr','nr','ur'}, 'bunc')
end

-- Stars/Crowns suits
if PB_UTIL then
	load_crossmod_ranks({'hr','nr','ur'}, 'paperback')
end

-- Pure Suits and rank
if next(SMODS.find_mod("aikoyorisshenanigans")) then
	add_atlases({
		create('akyrs_pure', 'cards/akyrs_pure.png')
	})
end

-- Mod stuff not related to suits or ranks
if next(SMODS.find_mod("CardSleeves")) then
	add_atlases({
		create('sleeves', 'decks/sleeves.png', 73, 95)
	})
end

-- Partner API
if next(SMODS.find_mod("partner")) then
	add_atlases({
		create('partners', 'crossmod/partners.png', 46, 58)
	})
end

-- More Fluff
if next(SMODS.find_mod("MoreFluff")) then
	local mf = 'more_fluff/mf_'
	add_atlases({
		create('mf_colours', 		mf..'colours.png'),
		create('mf_lunacy', 		mf..'lunacy.png'),
		create('mf_enhancements', 	mf..'enhancements.png'),
		create('mf_jokers', 		mf..'jokers.png'),
		crtsqr('mf_rotarots', 		mf..'rotarots.png', 107),
	})
end

-- TOGA
if MadLib.mod_loaded('TOGAPack') then
	local t = 'toga/toga_'
	add_atlases({
		create('toga_jokers', 		t..'jokers.png'),
		create('toga_mail', 		t..'mail.png', 95, 71),
	})
end

-- Cryptid
if next(SMODS.find_mod("Cryptid")) then
	local cry = 'cryptid/cry_'
	add_atlases({
		create('cry_decks',			cry..'decks.png'),
		create('cry_jokers', 		cry..'jokers.png')
	})
end

add_atlases({
	create('crossmod_rotumbrals', 'crossmod/rotumbrals.png', 95, 71)
})

return {
    name = "Atlases",
    init = function() print("Atlases!") end,
    items = atlases
}
