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
		config 		= MadLib.deep_copy(Madcap.DeckConfigs.sangria.base),
		loc_vars = function(self)
			local key
			local config 	= MadLib.deep_copy(Madcap.DeckConfigs.sangria.base)
			local nf		= 13
            if self.get_current_deck_key() == "b_rgmc_sangria" then
                key = self.key .. "_dd"
				config.double_deck = true
			elseif self.get_current_deck_key() == "b_rgmc_hexing" then -- 9*6 -> 9*8
                key = self.key .. "_pl"
				nf = 9
			elseif self.get_current_deck_key() == "b_checkered" then -- Hearts, Spades, Goblets, Towers
                key = self.key .. "_pl"
				config.special_deck = 'checkered'
			elseif self.get_current_deck_key() == "b_abandoned" then -- 13*6 -> 10*6
				nf = 10
			elseif self.get_current_deck_key() == "b_rgmc_merlot" then -- Blooms, Daggers, Goblets, Towers
                key = self.key .. "_pl"
				config.special_deck = 'merlot'
			else
                key = self.key
			end
			local vars 		= {
				localize(config.starting_suits[1], 'suits_plural'),
				localize(config.starting_suits[2], 'suits_plural'),
                number_format(nf),
				colours = {
					G.C.SUITS[config.starting_suits[1]],
					G.C.SUITS[config.starting_suits[2]]
				}
			}
			self.config = config
            return { 
				key = key, 
				vars = vars
			}
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck = true
			if self.config.special_deck then -- change every other card
				if 
					self.config.special_deck == 'checkered'
					or self.config.special_deck == 'merlot'
				then
					MadLib.event({
						func = function()
							for i=1, #G.playing_cards do
								local v = G.playing_cards[i]
								--print(i%2==0 and "YES" or "NO")
								if i%2==0 then
									if v:has_light_suit() then
										v:change_suit('rgmc_goblets')
									elseif v:has_dark_suit() then
										v:change_suit('rgmc_towers')
									end
								end
							end
							return true
						end,
					})
				end
			elseif not self.config.double_deck then -- change ever card
            	G.GAME.Exotic = true
				MadLib.event({
					func = function()
						for _, v in pairs(G.playing_cards) do
							if v:has_light_suit() then
								v:change_suit('rgmc_goblets')
							elseif v:has_dark_suit() then
								v:change_suit('rgmc_towers')
							end
						end
						return true
					end,
				})
			else
				-- idk man
			end
		end,
		unlock_condition = { deck = "Sangria Deck", stake = 1 },
    }
}
