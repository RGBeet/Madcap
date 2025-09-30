return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "jade",
        atlas = 'seals',
        pos = MLIB.coords(0,2),
        badge_colour    = HEX("226F4C"),
        config = { seal_odds = 1 }, -- starts at 1 in 1, then goes to 1 in 2, and so forth.
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, self.config.seal_odds, 'jade')
            return MadLib.collect_vars(number_format(math.max(_denom - _numer, 1)), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                card.ability.seal_odds = 1
            end
            if
                context.main_scoring
                and context.cardarea == G.play
                and SMODS.pseudorandom_probability(card, 'jade', 1, card.ability.seal_odds or 2 )
            then
                --draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
                card.ability.jade_active = true
                card.ability.seal_odds = (card.ability.seal_odds or 1) + 1
                --tell("Jade Seal activated!")
            end
        end,
    }
}
