return {
    categories = {
        'New Suits'
    },
    data = {
        object_type = "Joker",
        key     = 'vibrant_tourmaline',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,6),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = { odds = 3, money = 0, money_mod = 1, suit = 'rgmc_blooms' }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suit, 'suits_singular'),
                number_format(_numer),
                number_format(_denom),
                number_format(card.ability.extra.money_mod),
                number_format(card.ability.extra.money),
                { G.C.SUITS[card.ability.extra.suit] })
        end,
        calc_dollar_bonus = function(self, card)
            if to_big(card.ability.extra.money) > to_big(0) then return lenient_bignum(card.ability.extra.money) end
        end,
        calculate = function(self, card, context)
            -- upgrade
            if
                context.cardarea == G.play
                and context.individual
                and context.other_card:is_suit(card.ability.extra.suit)
                and SMODS.pseudorandom_probability(card, 'vibrant_tourmaline', 1, card.ability.extra.odds)
            then
                card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour  = G.C.MULT
                }
            end

            -- add money
            if context.forcetrigger then
                return { dollars = card.ability.extra.money }
            end

            -- reset at end of ante
            if context.new_ante then
                card.ability.extra.money = 0
                return {
                    message = localize('k_reset'),
                    colour  = G.C.FILTER
                }
            end
        end,
        in_pool = function(self, args)
            return G.GAME.Exotic
        end,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
