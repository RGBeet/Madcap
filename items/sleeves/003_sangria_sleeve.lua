return {
    categories = {
        'Decks',
        'Sleeves',
        'New Suits'
    },
    data = {
        object_type = "Sleeve",
        atlas   = 'sleeves',
        pos     = MLIB.coord(0,2),
		key = "sangria_sleeve",
		name = "Sangria Sleeve",
		config = { },
		unlock_condition = { deck = "Sangria Deck", stake = 1 },
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
