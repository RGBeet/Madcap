return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'commedia',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        eternal_compat      = false,
        perishable_compat   = false,
        config = {
            immutable = { new_cost = -15 },
            extra = { mult = 30 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.mult), number_format(math.abs(card.ability.immutable.new_cost)))
        end,
        calculate = function(self, card, context)
            if
                context.forcetrigger or
                (context.cardarea == G.jokers and context.joker_main)
            then
                return { mult = card.ability.extra.mult }
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            card.cost = card.ability.immutable.new_cost
            card:set_cost()
        end,
        demicoloncompat = true
    },
}
