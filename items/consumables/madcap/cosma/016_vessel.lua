return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "vessel",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,5),
        cost 	= 7,
        config	= { select = 2, extra = 1.25},
        can_use = function(self, card)
            return (G.jokers and #G.jokers.cards > 0)
                and (G.hand and #G.hand.cards > 1)
        end,
        use = function (self, card, area, copier)
            -- get 2 cards
            local valid = MadLib.shuffle_sort_list(G.jokers.cards, self.config.select or 2, function(v) return true end)
            pseudoshuffle(valid, pseudoseed('vessel_cards'))
            -- wiggle card
            MadLib.simple_event(function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end, 1.0, 'after')

            if valid and #valid > 1 then
                MadLib.loop_func(valid, function(v,i)
                    MadLib.simple_event(function()
                        Madcap.Funcs.mayhemize(v, {
                            force_values 	= true,
                            min_mult 		= self.config.extra or 1.25,
                            max_mult 		= self.config.extra or 1.25
                        }, false)
					    v:juice_up(0.3, 0.5)
                        return true
                    end, 0.8, 'after')
                end)
                MadLib.simple_event(function()
                    SMODS.Stickers['rgmc_positive']:apply(valid[1], true)
                    return true
                end, 1.0, 'after')
            end
            Madcap.Funcs.set_last_cosma(self)
        end
    }
}
