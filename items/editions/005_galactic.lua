function Madcap.Funcs.get_galactic_chips()
    local poker_hand 	= G.GAME.last_played_hand or 'High Card'
    local hand_chips 	= G.GAME and G.GAME.hands[poker_hand].chips or 5
    local hand_level 	= G.GAME and G.GAME.hands[poker_hand].level or 1
    local total 		= math.floor(hand_chips / 2) * hand_level
    return total, poker_hand, hand_chips, hand_level
end

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
            local total
            local poker_hand
            local hand_chips
            local hand_level
            total, poker_hand, hand_chips, hand_level = Madcap.Funcs.get_galactic_chips()
            return MadLib.collect_vars(poker_hand, number_format(hand_chips), number_format(hand_level), number_format(total))
        end,
        calculate = function(self, card, context)
            if 
                context.post_joker or
                (context.main_scoring and context.cardarea == G.play) 
            then
                -- get the data for the last played poker hand
                local total = Madcap.Funcs.get_galactic_chips()
                return { chips = total }
            end
        end,
    }
}
