return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "bronze",
        atlas = 'seals',
        pos = MLIB.coords(0,2),
        badge_colour    = HEX("226F4C"),
        config = { odds = 1 }, -- starts at 1 in 1, then goes to 1 in 2, and so forth.
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(self.config.extra.odds or 0))
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                self.config.extra.odds = 1
            end
            if context.main_scoring and context.cardarea == G.play then
                --draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
                card.ability.jade_active = true
                self.config.extra.odds = (self.config.extra.odds or 1) + 1
                --tell("Jade Seal activated!")
            end
        end,
    }
}
