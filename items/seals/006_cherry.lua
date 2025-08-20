return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Seal",
        key = "cherry",
        atlas = 'seals',
        pos = MLIB.coords(1,1),
        badge_colour = HEX("B8304B"),
        calculate = function(self, card, context)
            if context.setting_blind then card.cherry_active = nil end
            if
                context.main_scoring
                and context.cardarea == G.play
                and (card and not card.ability.cherry_active)
            then
                MadLib.simple_event(function()
                    card.cherry_active = true
                    card:juice_up(0.3,0.3)
                    play_sound('tarot2', 1.2, 0.4)
                    return true
                end, 0.4, 'after')
            end
        end,
    }
}
