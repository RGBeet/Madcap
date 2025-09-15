return {
    data = {
        object_type = "Voucher",
        pos     = MLIB.coords(1,2),
        atlas   = 'vouchers',
        key     = "high_rise",
        cost    = 4,
        config = { extra = { retriggers = 1 }, immutable = { max_retriggers = 25 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(MadLib.clamp(card.ability.extra.retriggers, 1, card.ability.immutable.max_retriggers)))
        end,
        calculate = function (self, card, context)
            -- retrigger all held cards
            if
                context.repetition
                and context.cardarea == G.play
                and context.scoring_name == "High Card" -- has a scoring hand, of course
                and context.other_card == context.scoring_hand[1]
            then
                return {
                    card = context.other_card,
                    message = localize('k_again_ex'),
                    repetitions = MadLib.clamp(card.ability.extra.retriggers, 1, card.ability.immutable.max_retriggers),
                }
            end
        end
    }
}
