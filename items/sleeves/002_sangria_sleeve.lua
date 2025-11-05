return {
    categories = {
        'Decks',
        'Sleeves',
        'New Suits'
    },
    data = {
        object_type = "Sleeve",
        atlas   	= 'sleeves',
        pos     	= MLIB.coords(0,2),
		key 		= "sangria_sleeve",
		config = MadLib.deep_copy(Madcap.DeckConfigs.sangria.base),
		loc_vars = function(self)
			local key
			local config 	= MadLib.deep_copy(Madcap.DeckConfigs.sangria.base)
			local vars 		= {
				localize(config.starting_suits[1], 'suits_plural'),
				localize(config.starting_suits[2], 'suits_plural'),
                number_format(26),
				colours = {
					G.C.SUITS[config.starting_suits[1]],
					G.C.SUITS[config.starting_suits[2]]
				}
			}
            if self.get_current_deck_key() == "b_rgmc_sangria" then
                key = self.key .. "_dd"
				config.double_deck = true
				config.bypass_apply = false
				config.starting_suits = MadLib.deep_copy(Madcap.DeckConfigs.sangria.base.starting_suits)
				config.starting_suits_doubles = true
			elseif self.get_current_deck_key() == "b_rgmc_hexing" then -- 9*6 -> 9*8
                key = self.key .. "_pl"
				vars[3] = number_format(9)
				config.bypass_apply = true
				config.starting_suits = MadLib.deep_copy(Madcap.DeckConfigs.sangria.base.starting_suits)
				config.starting_suits_doubles = false
			elseif self.get_current_deck_key() == "b_checkered" then -- Hearts, Spades, Goblets, Towers
                key = self.key .. "_pl"
				vars[3] = number_format(13)
				config.starting_suits = {'rgmc_goblets', 'rgmc_towers', 'Hearts', 'Spades'}
				config.starting_suits_doubles = false
			elseif self.get_current_deck_key() == "b_abandoned" then -- 13*6 -> 10*6
				vars[3] = number_format(10)
				config.no_faces = true
				config.starting_suits = MadLib.deep_copy(Madcap.DeckConfigs.sangria.base.starting_suits)
				config.starting_suits_doubles = false
			elseif self.get_current_deck_key() == "b_rgmc_merlot" then -- Blooms, Daggers, Goblets, Towers
                key = self.key .. "_pl"
				vars[3] = number_format(13)
				config.starting_suits = {'rgmc_goblets', 'rgmc_towers', 'rgmc_blooms', 'rgmc_daggers'}
				config.starting_suits_doubles = false
			else
                key = self.key
				config.starting_suits = MadLib.deep_copy(Madcap.DeckConfigs.sangria.base.starting_suits)
				config.starting_suits_doubles = true
			end
			self.config = config
            return { 
				key = key, 
				vars = vars
			}
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck = true

			if self.config.bypass_apply then
				local _ranks = MadLib.deep_copy(MadLib.RankTypes.Base)
				if self.no_faces then -- remove J, Q, and K
					for i=1,3 do _ranks[10] = nil end
				end
				Madcap.Funcs.add_to_deck_at_start({
					add_suits 	= self.config.starting_suits,
					add_ranks 	= _ranks,
					times 		= 2
				})
			elseif not self.config.double_deck then
            	G.GAME.Exotic = true -- Exotic Suits show up!
				Madcap.Funcs.set_subhand('light',true)
				Madcap.Funcs.set_deck_at_start({
					starting_suits = self.config.starting_suits,
					starting_suits_doubles = true
				})
			else
				-- idk man
			end
		end,
		unlock_condition = { deck = "Sangria Deck", stake = 1 },
    }
}
