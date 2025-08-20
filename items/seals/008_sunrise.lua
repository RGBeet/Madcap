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
            if context.end_of_round and context.cardarea == G.hand and not context.game_over then
                local to_suit = MadLib.suit_get_counterpart_lightdark(card.base.suit)
                tell('Converting to ' .. to_suit)
                MadLib.simple_event(function()
                    card:highlight(true)
                end, 0.8, 'after')
                MadLib.simple_event(function()
                    card:flip()
                end, 0.8, 'after')
                MadLib.simple_event(function()
                    SMODS.change_base(c, SMODS.Suits[to_suit].value, _)
                end, 0.8, 'after')
                MadLib.simple_event(function()
                    card:flip()
                end, 0.8, 'after')
                MadLib.simple_event(function()
                    card:highlight(true)
                end, 0.8, 'false')
            end
        end
    }
}
