return {
    data = {
        object_type = "Joker",
        key     = 'supreme_with_cheese',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,9),
        rarity  = 1,
        cost    = 6,
        eternal_compat      = false,
        perishable_compat   = false,
        config = {
            extra = { x_mult = 2, rounds = 8 },
            immutable = { max_rounds = 8 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.rounds),
                { MadLib.get_warning_colour(card.ability.extra.rounds / card.ability.immutable.max_rounds) })
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.joker_main and G.GAME.current_round.hands_played == 0
            end
            if (context.joker_main and G.GAME.current_round.hands_played == 0) or context.forcetrigger then
                return { x_mult = card.ability.extra.x_mult }
            end
            if Madcap.Funcs.get_end_of_round(context) then
                return MadLib.food_joker_logic(card)
            end
        end,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
