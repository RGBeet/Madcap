Madcap.Funcs.get_doom_bunny_value = function(a)
    return (a.config.center == G.P_CENTERS.m_wild and -10 or 0) + (a.edition and 5 or 0) + (a.seal and 2 or 0)
end

return {
    data = {
        object_type = "Joker",
        key     = 'doom_bunny',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,6),
        rarity  = 3,
        cost    = 10,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.individual
                and context.cardarea == G.play
                and context.other_card
                and #G.playing_cards > 1    -- does not work if you have only 1 card
                and SMODS.has_enhancement(context.other_card,'m_wild')
            end
            if
                context.individual
                and context.cardarea == G.play
                and context.other_card
                and #G.playing_cards > 1    -- does not work if you have only 1 card
            then
                -- wild card
                if SMODS.has_enhancement(context.other_card,'m_wild') then

                    -- Don't do a thing if the card is debuffed
                    if context.other_card.debuff then return { message = localize('k_debuffed'), colour = G.C.RED, card = card } end

                    -- Not the other card, and either not a wild card or a wild card with edition/seal
                    local from_card, to_card = context.other_card, MadLib.get_cards_from_shuffled_deck(
                        G.playing_cards, 1, function(v)
                            return context.other_card ~= v
                        end, function(a,b)
                            return Madcap.Funcs.get_doom_bunny_value(a) > Madcap.Funcs.get_doom_bunny_value(b)
                        end)[1]

                    MadLib.simple_event(function()
                        MadLib.copy_card_settings(from_card, to_card, {
                            ranks = true,
                            enhancements = false,
                            editions = true,
                            seals = true
                        })
                        from_card:juice_up(0.5, 0.5)
                        return true
                    end, 2.5, 'after')
                end
            end
        end,
        demicoloncompat = false,
        quasicoloncheck = true,
    }
}
