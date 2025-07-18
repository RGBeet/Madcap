local atlases = {
	-- the faithful M:
	MadLib.create_atlas('placeholder', 'placeholder.png'),
	-- the jonklers
	MadLib.create_atlas('jokers', 'jokers.png'),
	MadLib.create_atlas('jokers_legendary', 'jokers_legendary.png'),
	-- custom ranks, base suits
	MadLib.create_atlas('new_ranks', 'new_ranks.png'),
	MadLib.create_atlas('new_ranks_hc', 'new_ranks_hc.png'),
	-- custom suits, base ranks
	MadLib.create_atlas('new_suits', 'new_suits.png'),
	MadLib.create_atlas('new_suits_hc', 'new_suits_hc.png'),
	MadLib.create_square_atlas('ui_suits', 'ui_suits.png', 18),
	MadLib.create_square_atlas('ui_suits_hc', 'ui_suits_hc.png', 18),
	-- consumables
	MadLib.create_atlas('consumables', 'consumeables.png'),
	MadLib.create_atlas('cosma_tarots', 'cosma_tarots.png'),
	MadLib.create_atlas('anti_spectrals', 'anti_spectrals.png'),
	MadLib.create_atlas('aversion', 'aversion.png'),
	--
	MadLib.create_atlas('vouchers', 'vouchers.png'),
	MadLib.create_atlas('enhance', 'enhancements.png'),
	MadLib.create_atlas('seals', 'seals.png'),
	MadLib.create_square_atlas('modicon', 'modicon.png', 32),
	MadLib.create_square_atlas('spam', 'spam_joker.png', 95),
	MadLib.create_square_atlas('tags', 'tags.png', 34),
	MadLib.create_square_atlas('antags', 'antags.png', 34),
	MadLib.create_atlas('decks', 'decks.png'),
	MadLib.create_atlas('deck_lunacy', 'deck_lunacy.png'),
	MadLib.create_atlas('planets', 'planets.png'),
	MadLib.create_blind_atlas('blinds', 'blinds.png', 21),
	MadLib.create_blind_atlas('blinds_chaotic', 'blinds_chaotic.png', 21),
	-- yummy yummy decks!
	MadLib.create_atlas('cryptid_decks', 'cryptid_decks.png'),
	MadLib.create_atlas('stickers', 'stickers.png'),
	MadLib.create_atlas('boosters', 'boosters.png'),
	--MadLib.create_atlas('stickers', 'stickers.png'),
	--MadLib.create_square_atlas('stakes', 'stakes.png', 29),
	--MadLib.create_atlas('sleeves', 'sleeves.png'),
}

return {
    name = "Atlases",
    init = function() print("Atlases!") end,
    items = atlases
}
