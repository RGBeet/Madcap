function Madcap.Funcs.get_hand_data(hand)
    hand = hand or G.GAME.last_played_hand or 'High Card'
    return hand,
        G.GAME and lenient_bignum(G.GAME.hands[hand].chips or 5),
        G.GAME and lenient_bignum(G.GAME.hands[hand].mult or 1),
        G.GAME and lenient_bignum(G.GAME.hands[hand].level or 1)
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
            local hand, chips, mult, level = Madcap.Funcs.get_hand_data()
            return MadLib.collect_vars(hand, chips, mult, level)
        end,
        calculate = function(self, card, context)
            if context.post_joker or (context.main_scoring and context.cardarea == G.play)  then
                local hand = G.GAME.last_played_hand or 'High Card'
                return { 
                    chips   = lenient_bignum(G.GAME.hands[hand].chips),
                    mult    = lenient_bignum(G.GAME.hands[hand].mult),
                }
            end
        end,
    }
}
