return {
    categories = {
        'Decks',
        'Sleeves',
        'Mayhem',
    },
    data = {
        object_type = "Sleeve",
        atlas   = 'sleeves',
        pos     = MLIB.coord(1,0),
		key = "mayhem_sleeve",
		name = "Mayhem Sleeve",
		config = { },
		unlock_condition = { deck = "Mayhem Deck", stake = 1 },
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
