return {
    data = {
        object_type = "Joker",
        key =    'cup_of_joeker',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,7),
        rarity  = 1,
        cost    = 5,
        calculate = function(self, card, context)
            if (context.end_of_round and not context.game_over and context.cardarea == G.jokers) or context.forcetrigger then
                local new_card = MadLib.get_random_card("Tarot")
                new_card:add_to_deck()
                table.insert(G.consumeables, new_card)
                G.consumeables:emplace(new_card)

                MadLib.simple_event(function()
                    play_sound('rgmc_mug_yep', 1, 0.6)
                    card:juice_up(0.3, 0.4)
                    return true
                end, 0.3, 'immediate')
            end
        end,
        demicoloncompat = true
    },
}
