return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "umber",
        atlas = 'seals',
        pos = MLIB.coords(1,0),
        badge_colour = HEX("DF6622"),
        config = {
            extra = { draw_cards = 2 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(MadLib.clamp(self.config.extra.draw_cards, 2, 10)))
        end,
        calculate = function(self, card, context)
            if context.discard and (context.other_card and context.other_card == card) then
                G.FUNCS.draw_from_deck_to_hand(MadLib.clamp(self.config.extra.draw_cards, 2, 10) + 1)
                --tell("Umber Seal activated!")
            end
        end,
    }
}
