return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = 'Consumable',
        set     = "CosmaTarot",
        key 	= "past_lives",
        atlas   = "cosma",
        pos 	= MLIB.coords(1,3),
        cost 	= 6,
        config	= { extra = 1, jokers = 1 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra))
        end,
        can_use = function(self, card)
            return G.GAME.dead_jokers and #G.GAME.dead_jokers > 0 -- at least one dead joker
        end,
        use = function(self, card, area, copier)
            local selection = MadLib.shuffle_sort_list(G.GAME.dead_jokers, self.config.jokers or 1, function(v)
                return string.sub(v, 1, 2) == 'j_' -- is a joker
            end)
            local _key = pseudorandom_element(selection, pseudoseed('past_lives'))
            Madcap.Funcs.ease_mayhem(self.config.extra and -self.config.extra or -1, true)
            MadLib.simple_event(function()
                local _joker = MadLib.create_joker(_key)
                return true
            end, 0.2, 'after')
        end
    }
}
