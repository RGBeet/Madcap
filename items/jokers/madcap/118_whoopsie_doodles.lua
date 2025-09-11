return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'whoopsie_doodles',
        atlas   = 'jokers',
        pos     = MLIB.coords(11,7),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { x_mult = 0.5, x_chips = 1.5, rounds_remaining = 8 },
            immutable = { max_rounds = 8 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.x_chips),
                number_format(card.ability.extra.rounds_remaining),
                { MadLib.get_warning_colour(card.ability.extra.rounds_remaining / card.ability.immutable.max_rounds) })
        end,
        calculate = function(self, card, context)
            if context.joker_main and G.GAME.current_round.hands_played == 0 then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.MultiMult, card, card.ability.extra.x_mult)
            end
            Madcap.Funcs.food_joker_round_end(card)
        end,
        demicoloncompat = true
    }
}
