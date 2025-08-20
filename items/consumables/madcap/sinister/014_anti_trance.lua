return {
    categories = {
        'Sinister Cards',
    },
    data = {
        object_type = 'Consumable',
        set     = "AntiSpectral",
        key		= 'anti_trance',
        atlas   = 'sinister',
        pos 	= MLIB.coords(1,3),
        cost 	= 2,
        config	= { extra = 3 },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra, localize(MadLib.get_most_played_hand(), 'poker_hands'))
        end,
        can_use = function(self, card)
            return G.GAME.hands[MadLib.get_most_played_hand()].level > (self.config.extra or 3)
        end,
        use 	= function(self, card, area, copier)
            -- level down most played poker hand
            local most_played = MadLib.get_most_played_hand()
            local least_played_num = most_played.played
            -- get # of least played
            MadLib.loop_func_table(G.GAME.hands, function(k,v)
                if v.played < least_played_num then least_played_num = v.played end
            end)
            -- get possible candidates
            local level_up_hands = MadLib.get_cards_from_shuffled_deck(G.GAME.hands, math.min(self.config.extra,#G.GAME.hands), function(v)
                return v.played == least_played_num
            end, function(v)
                return math.random() < 0.5 -- coin flip
            end)
            -- add levels
            MadLib.loop_func(level_up_hands, function(v)
                MadLib.do_level_up(card, v, 1)
            end)
            -- get 3 of the least played poker hands, add the levels ala decant
        end
    }
}
