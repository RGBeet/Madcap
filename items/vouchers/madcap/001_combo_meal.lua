return {
    data = {
        object_type = "Voucher",
        pos         = MLIB.coords(0,0),
        atlas       = 'vouchers',
        key 		= "combo_meal",
        cost 		= 6,
        config 		= { extra = 1.5, },
        redeem = function(self)
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra))
        end,
        calculate = function (self, card, context)
            if context.end_of_round and not context.game_over and context.main_eval then
                -- if you get overkill, you get a free tarot card
                local diff = math.abs(to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) -- difference between your chips and blind chips
                if to_big(diff) / to_big(G.GAME.blind.chips) >= to_big(1.5) then
                    tell('Good job!')
                    MadLib.simple_event(function()
                        local card_type = "Tarot"
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        local n = MadLib.get_random_card(card_type, G.consumeables, 'combo_meal')
                        play_sound('timpani')
                        n:add_to_deck()
                        G.consumeables:emplace(n)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end, 0.15, 'immediate')
                end
            end
        end,
    }
}
