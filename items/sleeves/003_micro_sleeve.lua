return {
    categories = {
        'Decks',
        'Sleeves',
    },
    data = {
        object_type 	= "Sleeve",
        atlas   		= 'sleeves',
        pos     		= MLIB.coords(0,4),
		key 			= "micro_sleeve",
		config 			= Madcap.DeckConfigs.micro.sleeve,
		loc_vars 		= function(self)
            local key, vars
            if self.get_current_deck_key() == "b_rgmc_micro" then
                key = self.key .. "_dd"
                self.config = MadLib.deep_copy(Madcap.DeckConfigs.micro.sleeve_plus)
            else
                key = self.key
                self.config = MadLib.deep_copy(Madcap.DeckConfigs.micro.sleeve)
            end
            vars = { self.config.hand_size, self.config.hand_play_limit, self.config.ante_scaling }
            return { key = key, vars = vars }
		end,
		apply = function(self) -- Start of the run
			G.GAME.modifiers.rgmc_deck = true
            
			if not self.config.double_deck then Madcap.DeckFuncs.micro.apply(self) end
            -- these configs don't automatically apply? idk why.
            G.GAME.starting_params.hand_size =  G.GAME.starting_params.hand_size + self.config.hand_size
            G.GAME.starting_params.ante_scaling =  G.GAME.starting_params.ante_scaling * self.config.ante_scaling
            MadLib.event({
			    func = function()
				    SMODS.change_play_limit(self.config.hand_play_limit)
				    return true
			    end
		    })
		end,
		unlock_condition 	= { deck = "Micro Deck", stake = 1 },
    }
}
