-- 1 in 3 chance to spawn a Spectral if held in hand at end of round
return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "cream",
        atlas = 'seals',
        pos = MLIB.coords(0,3),
        badge_colour = HEX("DF6622"),
        config = {
            extra = { odds = 3 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, self.config.extra.odds, 'cream_seal')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if context.end_of_round and context.cardarea == G.hand and not context.game_over and SMODS.pseudorandom_probability(card, 'cream_seal', 1, self.config.extra.odds) then
                local new_card = (not SMODS.pseudorandom_probability(card, 'cream_seal', 1, self.config.extra.odds))
                    and MadLib.get_random_card("Spectral")
                    or MadLib.get_random_card("Spectral")
                new_card:add_to_deck()
                table.insert(G.consumeables, new_card)
                G.consumeables:emplace(new_card)
            end
        end,
    }
}
