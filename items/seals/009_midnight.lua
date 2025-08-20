return {
    categories = {
        'Seals',
        'Parallel Suits'
    },
    data = {
        object_type = "Seal",
        key = "midnight",
        atlas = 'seals',
        pos = MLIB.coords(2,0),
        badge_colour = HEX("8753E0"),
        loc_vars = function(self, info_queue, seal)
            return {vars={}}
        end,
        calculate = function(self, card, context)
            if context.discard and (context.other_card and context.other_card == card) then
                local to_suit = MadLib.suit_get_counterpart_basemodded(card.base.suit)
                if to_suit then
                    MadLib.simple_event(function()
                        card:highlight(true)
                        return true
                    end, 0.5, 'after')
                    MadLib.simple_event(function()
                        card:flip()
                        return true
                    end, 0.5, 'after')
                    MadLib.simple_event(function()
                        SMODS.change_base(card, to_suit, _)
                        card:flip()
                        play_sound('rgmc_flourish')
                        return true
                    end, 0.8, 'after')
                    MadLib.simple_event(function()
                        card:highlight(false)
                        return true
                    end, 0.5, 'after')
                end
            end
        end
    }
}
