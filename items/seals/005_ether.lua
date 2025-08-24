-- 1 in 3 chance to spawn a Spectral if held in hand at end of round
return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "ether",
        atlas = 'seals',
        pos = MLIB.coords(0,3),
        badge_colour = HEX("EBE8BD"),
        config = { extra = { odds = 3 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, self.config.extra.odds, 'ether_seal')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if
                (context.end_of_round and context.cardarea == G.hand and not context.game_over)
                and SMODS.pseudorandom_probability(card, 'ether_seal', 1, self.config.extra.odds)
            then
                local new_card
                local soul_chance = (not SMODS.pseudorandom_probability(card, 'get_soul', 1, 100))

                if soul_chance then
                    new_card = MadLib.get_random_card("Spectral")
                else
                    new_card = MadLib.get_random_card("Spectral")
                end

                new_card:add_to_deck()
                table.insert(G.consumeables, new_card)
                G.consumeables:emplace(new_card)
            end
        end,
    }
}
