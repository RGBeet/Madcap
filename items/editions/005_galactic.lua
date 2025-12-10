function Madcap.Funcs.get_hand_data(hand)
    hand = hand or G.GAME.last_played_hand or 'High Card'
    return {
        hand    = hand,
        chips   = G.GAME and G.GAME.hands[hand].chips or 5,
        mult    = G.GAME and G.GAME.hands[hand].mult or 1,
        level 	= G.GAME and G.GAME.hands[hand].level or 1
    }
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
            local data = Madcap.Funcs.get_hand_data()
            return MadLib.collect_vars(data.hand, data.level, data.chips, data.mult)
        end,
        calculate = function(self, card, context)
            if 
                context.post_joker or
                (context.main_scoring and context.cardarea == G.play) 
            then
                local data = Madcap.Funcs.get_hand_data()
                return { 
                    chips   = data.chips,
                    mult    = data.mult,
                }
            end
        end,
    }
}
