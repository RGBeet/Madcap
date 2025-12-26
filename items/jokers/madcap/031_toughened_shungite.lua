-- thorium joker conversions
return {
    data = {
        object_type = "Joker",
        key     = 'toughened_shungite',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,0),
        rarity  = 2,
        cost    = 7,
        config =  {
            extra = { odds = 4, chips = 0, chip_mod = 15, suit = 'rgmc_towers' }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'toughened_shungite')
            return MadLib.collect_vars_colours(
                number_format(_numer),
                number_format(_denom),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chips),
                localize(Madcap.Funcs.get_joker_suit(card, 'rgmc_towers'), 'suits_singular'),
                { G.C.SUITS[Madcap.Funcs.get_joker_suit(card, 'rgmc_towers')] })
        end,
        calculate = function(self, card, context)
            -- scaling
            if
                context.cardarea == G.play
                and context.individual
            then
                if
                    context.other_card:is_suit(card.ability.extra.suit)
                    and SMODS.pseudorandom_probability(card, 'toughened_shungite', 1, card.ability.extra.odds)
                then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour  = G.C.MULT
                    }
                end
            end

            -- give the mult
            if
                (context.joker_main or context.forcetrigger)
                and card.ability.extra.chips > 0
            then
                return { chips = card.ability.extra.chips }
            end

            -- reset at end of ante
            if context.new_ante then
                card.ability.extra.chips = 0
                return {
                    message = localize('k_reset'),
                    colour  = G.C.FILTER
                }
            end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    },
    in_pool = function(self, args) -- "Exotic suits" enabled
        return G.GAME.Exotic
    end
}
