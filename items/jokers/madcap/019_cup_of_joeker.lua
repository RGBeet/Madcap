return {
    data = {
        object_type = "Joker",
        key =    'cup_of_joeker',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,7),
        rarity  = 1,
        cost    = 5,
        calculate = function(self, card, context)
            if context.checktrigger then
                return (context.end_of_round 
                    and not context.game_over
                    and G.GAME.current_round.hands_played == 0 
                    and context.cardarea == G.jokers)
                    and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
            end
            if 
                ((context.end_of_round 
                    and not context.game_over
                    and G.GAME.current_round.hands_played == 0
                    and context.cardarea == G.jokers)
                or context.forcetrigger)
                and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
            then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                MadLib.event({
                    func = (function()
                        MadLib.event({
                            func = function()
                                SMODS.add_card {
                                    set = 'Tarot',
                                    key_append = 'cup_o_joeker' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                }
                                G.GAME.consumeable_buffer = 0
                                play_sound('rgmc_mug_yep', 1, 0.6)
                                return true
                            end
                        })
                        SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                            context.blueprint_card or card)
                        return true
                    end)
                })
                return nil, true
            end
        end,
        demicoloncompat = true,
        quasicoloncheck = true,
    },
}
