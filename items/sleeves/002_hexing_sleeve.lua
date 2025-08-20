return {
    categories = {
        'Decks',
        'Sleeves',
        'New Suits'
    },
    data = {
        object_type = "Sleeve",
        atlas   = 'sleeves',
        pos     = MLIB.coord(0,1),
		key = "hexing_sleeve",
		name = "Hexing Sleeve",
		config = { },
		unlock_condition = { deck = "Hexing Deck", stake = 1 },
		loc_vars = function(self)
			return { vars = {} }
		end,
		trigger_effect = function(self, args)
			-- nothing?
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck = true
		end,
		calculate = function(self, sleeve, context)
		end
    }
}
