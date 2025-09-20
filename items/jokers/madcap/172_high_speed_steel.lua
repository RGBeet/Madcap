return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'high_speed_steel',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 9,
        config = { extra = { x_chips = 1.4 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.x_chips))
        end,
        calculate = function(self, card, context)
            if 
                context.individual
                and context.cardarea == G.hand
                and SMODS.has_enhancement(context.other_card, 'm_rgmc_wolfram')
            then
                return { xchips = card.ability.extra.x_chips }
            end
        end,
    },
}
