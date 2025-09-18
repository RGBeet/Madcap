return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'maple_donut',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        eternal_compat      = false,
        perishable_compat   = false,
        config = {
            extra = { x_numerator = 1.2, rounds_remaining = 5 },
            immutable = { max_rounds = 5 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.rounds_remaining),
                number_format(card.ability.extra.x_numerator),
                { MadLib.get_warning_colour(card.ability.extra.rounds_remaining / card.ability.immutable.max_rounds) })
        end,
        calculate = function(self, card, context)
            if context.mod_probability and not context.blueprint and not context.repetition then
                return { numerator = math.min(context.numerator * card.ability.extra.x_numerator, context.denominator) }
            end
            Madcap.Funcs.food_joker_round_end(card)
        end,
        demicoloncompat = false
    },
}
