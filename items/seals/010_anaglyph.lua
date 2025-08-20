return {
    categories = {
        'Seals',
    },
    data = {
        object_type = "Seal",
        key = "anaglyph",
        atlas = 'seals',
        pos = MLIB.coords(2,1),
        badge_colour = HEX("39474A"),
        config = { extra = { odds = 3 } },
        loc_vars = function(self, info_queue, seal)
            local _numer, _denom = SMODS.get_probability_vars(seal, 1, self.config.extra.odds, 'anaglyph')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if context.end_of_round and context.cardarea == G.hand and not context.game_over and SMODS.pseudorandom_probability(card, 'anaglyph_seal', 1, self.config.extra.odds) then
                MadLib.simple_event(function()
                    add_tag(Tag('tag_double'))
                    return true
                end, 0.00, 'after')
                --tell("Anaglyph Seal activated!")
            end
        end,
    }
}
