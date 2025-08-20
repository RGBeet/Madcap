return {
    data = {
        object_type = 'Blind',
        key     = 'final_moon',
        atlas   = "blinds",
        pos     = MLIB.coords(46),
        boss_colour = HEX('7D6E59'),
        config = { light_cards = true },
        in_pool = function(self)
            return true
        end,
        press_play = function(self)
            self.config.light_cards = not self.config.light_cards -- flip it!
        end,
        recalc_debuff = function(self, card, from_blind)
            return (card:has_light_suit() and self.config.light_cards)
                or (card:has_dark_suit() and not self.config.light_cards)
                or false
        end,
    }
}
