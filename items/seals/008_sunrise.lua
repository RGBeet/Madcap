return {
    categories = {
        'Seals',
        'Parallel Suits'
    },
    data = {
        object_type = "Seal",
        key = "sunrise",
        atlas = 'seals',
        pos = MLIB.coords(1,3),
        badge_colour = HEX("C1A769"),
        loc_vars = function(self, info_queue, seal)
            return {vars={}}
        end,
        calculate = function(self, card, context)
            -- if held at end of round, convert to parallel/base suit
            if context.discard and (context.other_card and context.other_card == card) then
                local to_suit = MadLib.suit_get_counterpart_lightdark(card.base.suit)
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
