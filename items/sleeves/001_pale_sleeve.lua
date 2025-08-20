return {
    categories = {
        'Decks',
        'Sleeves',
    },
    data = {
        object_type = "Sleeve",
        atlas   = 'sleeves',
        pos     = MLIB.coord(0,0),
		key = "pale_sleeve",
		name = "Pale Sleeve",
		config = { hand_size = -2, hands = 	-1 },
		unlock_condition = { deck = "Pale Deck", stake = 1 },
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
