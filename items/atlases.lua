
local card = {px = 71, py = 95}

function create_atlas(key, path, px, py)
	if not (px and py) then
		print("MADCAP - Atlas "..key.." not working!")
	end
	return { 
		object_type = "Atlas",
		key=key,
		path=path,
		px=px or 71,
		py=py or 95
	}
end

-- Card atlas
function create_card_atlas(key, path)
	return create_atlas(key, path, card.px, card.py)
end

-- Animated atlas
function create_anim_atlas(key, path, frms, px, py)
	local atlas = create_atlas(key, path, px, py)
	atlas["frames"] = frms or 21
	return atlas
end

-- Square Atlas
function create_square_atlas(key, path, size)
	return create_atlas(key, path, size, size)
end

-- 34x34 atlas
function create_blind_atlas(key, path, size, frms)
	return {
		object_type = "Atlas",
		key = key,
		atlas_table = "ANIMATION_ATLAS",
		path = path,
		px = size or 34,
		py = size or 34,
		frames = frms or 21
	}
end

local atlases = {
	create_card_atlas('placeholder', 'placeholder.png'),
	create_card_atlas('jokers', 'jokers.png'),
	create_card_atlas('jokers_legendary', 'jokers_legendary.png'),
	-- custom ranks, base suits
	create_card_atlas('new_ranks', 'new_ranks.png'),
	create_card_atlas('new_ranks_hc', 'new_ranks_hc.png'),
	-- custom suits, base ranks
	create_card_atlas('new_suits', 'new_suits.png'),
	create_card_atlas('new_suits_hc', 'new_suits_hc.png'),
	create_square_atlas('ui_suits', 'ui_suits.png', 18),
	create_square_atlas('ui_suits_hc', 'ui_suits_hc.png', 18),
	create_card_atlas('consumables', 'consumeables.png'),
	create_card_atlas('vouchers', 'vouchers.png'),
	create_card_atlas('enhance', 'enhancements.png'),
	create_card_atlas('seals', 'seals.png'),
	create_square_atlas('modicon', 'modicon.png', 32),
	create_square_atlas('tags', 'tags.png', 34),
	create_blind_atlas('blinds', 'blinds.png', 34, 21),
	create_card_atlas('stickers', 'stickers.png'),
	create_card_atlas('decks', 'decks.png'),
	create_card_atlas('cryptid_decks', 'cryptid_decks.png'),
	--create_card_atlas('stickers', 'stickers.png'),
	--create_square_atlas('stakes', 'stakes.png', 29),
	--create_card_atlas('sleeves', 'sleeves.png'),
}

return {
    name = "Atlases",
    init = function() print("Atlases!") end,
    items = atlases
}
