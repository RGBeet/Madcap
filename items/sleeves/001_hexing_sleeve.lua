function Madcap.Funcs.is_playing_card(card)
	return card and card.config.card_key and (card.ability.set == "Default" or card.ability.set == "Enhanced")
end

return {
    categories = {
        'Decks',
        'Sleeves',
        'New Suits'
    },
    data = {
        object_type = "Sleeve",
        atlas   	= 'sleeves',
        pos     	= MLIB.coords(0,1),
		key 		= "hexing_sleeve",
		name 		= "Hexing Sleeve",
		config 		= MadLib.deep_copy(Madcap.DeckConfigs.hexing.base),
		loc_vars = function(self)
			local key
			local config = {}
            if self.get_current_deck_key() == "b_rgmc_hexing" then
                key = self.key .. "_dd"
				config.double_deck = true
				-- will just add these instead
				config.starting_ranks = { '2', '3', '4', '5' }
				config.starting_suits = MadLib.deep_copy(Madcap.DeckConfigs.hexing.base.starting_suits)
            elseif self.get_current_deck_key() == "b_abandoned" then -- Substitutes 3/4/5 for J/Q/K
                key = self.key .. "_ad"
				config.starting_ranks = { '3', '4', '5', '6', '7', '8', '9', '10', 'Ace' }
				config.starting_suits = MadLib.deep_copy(Madcap.DeckConfigs.hexing.base.starting_suits)
            elseif self.get_current_deck_key() == "b_checkered" then -- Goblets/Towers -> Hearts/Spades
				config.starting_ranks = MadLib.deep_copy(Madcap.DeckConfigs.hexing.base.starting_ranks)
				config.starting_suits = { 'Hearts', 'Spades', 'Diamonds', 'Clubs', 'Hearts', 'Spades'}
                config.starting_suits[5] = "Hearts"
                config.starting_suits[6] = "Spades"
                key = self.key
            elseif self.get_current_deck_key() == "b_rgmc_merlot" then -- Goblets/Towers -> Blooms/Daggers
				config.starting_ranks = MadLib.deep_copy(Madcap.DeckConfigs.hexing.base.starting_ranks)
				config.starting_suits = { 'Hearts', 'Spades', 'Diamonds', 'Clubs', 'rgmc_blooms', 'rgmc_daggers'}
                config.starting_suits[5] = "rgmc_blooms"
                config.starting_suits[6] = "rgmc_daggers"
                key = self.key
			else
				config = MadLib.deep_copy(Madcap.DeckConfigs.hexing.base)
                key = self.key
            end
			self.config = config
            return { 
				key = key, 
				vars = {
					localize(config.starting_suits[5], 'suits_plural'),
					localize(config.starting_suits[6], 'suits_plural'),
					colours = {
						G.C.SUITS[config.starting_suits[5]],
						G.C.SUITS[config.starting_suits[6]]
					}
				} 
			}
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck = true
			if not self.config.double_deck then
				Madcap.Funcs.set_deck_at_start({
					starting_suits = self.config.starting_suits,
					starting_ranks = self.config.starting_ranks
				})
			else
				Madcap.Funcs.add_to_deck_at_start({
					add_suits = self.config.starting_suits,
					add_ranks = self.config.starting_ranks
				})
			end
		end,
		calculate = function(self, sleeve, context)
			if  
				sleeve.config.double_deck
				and (context.create_card or context.modify_playing_card) 
				and Madcap.Funcs.is_playing_card(context.card)
			then
				local card = context.card
				if not MadLib.list_matches_one(sleeve.config.starting_suits, function(v)
					return card:is_suit(v)
				end) then
					local new_suit = pseudorandom_element(sleeve.config.starting_suits, pseudoseed('hexing_sleeve'))
					assert(SMODS.change_base(card, new_suit, nil))
				end
			end
		end,
		unlock_condition = { deck = "Hexing Deck", stake = 1 },
    }
}
