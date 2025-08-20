return {
    categories = {
        'Editions',
        'Score'
    },
    data = {
        object_type = "Edition",
        key 	= 'galactic',
        shader 	= 'galactic',
        weight  = 2,
        in_shop = true,
        extra_cost = 6,
        config = {
            -- idk
        },
        sound = { sound = "rgmc_e_galactic", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self, info_queue)
            local poker_hand 	= G.GAME.last_played_hand or 'High Card'
            local hand_chips 	= G.GAME and G.GAME.hands[poker_hand].chips or 5
            local hand_level 	= G.GAME and G.GAME.hands[poker_hand].level or 1
            local total 		= math.floor(hand_chips/2 * hand_level)
            return MadLib.collect_vars(poker_hand,
                number_format(hand_chips),
                number_format(hand_level),
                number_format(total))
        end,
        calculate = function(self, card, context)
            -- get the data for the last played poker hand
            if Madcap.Funcs.edition_in_play(context,card) and G.GAME.last_played_hand then
                local total = math.floor(G.GAME.hands[poker_hand].chips/2 * G.GAME.hands[poker_hand].level)
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, card, total)
            end
        end,
    }
}
