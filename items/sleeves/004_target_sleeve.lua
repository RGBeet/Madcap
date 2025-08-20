return {
    categories = {
        'Decks',
        'Sleeves',
        'Sinister Cards'
    },
    data = {
        object_type = "Sleeve",
        atlas   = 'sleeves',
        pos     = MLIB.coord(0,3),
		key = "target_sleeve",
		name = "Target Sleeve",
		config = { },
		unlock_condition = { deck = "Target Deck", stake = 1 },
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
