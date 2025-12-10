-- Removes $1 per held card at end of blind
return {
    data = {
        object_type = 'Blind',
        key     = 'levy',
        atlas   = "blinds",
        pos     = MLIB.coords(4),
        mult    = 1.5,
        dollars = 8,
        boss_colour = HEX('3F8451'),
        config = { extra = 1 },
        in_pool = function(self)
            return not MadLib.is_broke()
        end,
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(self.config.extra or 1))
        end,
        calculate = function (self, blind, context)
            if
                not G.GAME.blind.disabled
                and context.end_of_round
                and not context.repetition
                and not context.individual
            then
                ease_dollars(#G.hand.cards * -self.config.extra)
                self.triggered = true
            end
        end
    }
}
