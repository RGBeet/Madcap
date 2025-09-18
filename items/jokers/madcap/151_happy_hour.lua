return {
    categories = {
        'Unreleased',
        'Suits' -- requires new suits to load
    },
    data = {
        object_type = "Joker",
        key     = 'happy_hour',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { chips = 25, chip_mod = 5, base_chips = 25, suit = 'rgmc_goblets' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.chips),
                localize(card.ability.extra.suit, 'suits_singular'),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calculate = function(self, card, context)

            if context.setting_blind then
                card.ability.chips = card.ability.base_chips
                return {
                    colour = G.C.FILTER,
                    message = localize('k_reset')
                }
            end

            if 
                context.discard 
                and context.other_card:is_suit(card.ability.extra.suit)
                and to_big(card.ability.extra.chips) > to_big(card.ability.extar.chip_mod) 
            then
                card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                return {
                    colour = G.C.BLUE,
                    message = "-" .. number_format(card.ability.extra.chip_mod)
                }
            end

            if
                (context.individual
                and context.cardarea == G.hand
                and context.other_card:is_suit(card.ability.extra.suit))
                or context.forcetrigger
            then
                return { chips = card.ability.extra.chips }
            end
        end,
        demicoloncompat = true,
    },
}
