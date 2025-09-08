return {
    categories = {
        'Unfinished Content',
        'Luxury Points'
    },
    data = {
        object_type = "Joker",
        key     = 'jackpot',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 9,
        config = {
            extra = { rank = 'Jack', odds = 20, luxury = 2, luxury_mod = 1, failed_rolls = 0, max_failed_rolls = 3 },
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'jackpot')
            return MadLib.collect_vars(localize(card.ability.extra.rank or 'Jack', 'ranks'),
                _numer,
                _denom,
                number_format(card.ability.extra.luxury),
                number_format(card.ability.extra.luxury_mod),
                number_format(card.ability.extra.max_failed_rolls),
                number_format(card.ability.extra.failed_rolls))
        end,
        calculate = function(self, card, context)
            if 
                context.individual 
                and context.cardarea == G.hand 
                and not context.end_of_round
                and MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.rank or 'Jack'].id)
            then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                elseif SMODS.pseudorandom_probability(card, 'jackpot', 1, card.ability.extra.odds) then -- roll succeed! :)
                    local payout = card.ability.extra.luxury
                    card.ability.extra.luxury = 0
                    return { rgmc_luxury_pts = payout }
                else -- roll failed :(
                    card.ability.extra.failed_rolls = card.ability.extra.failed_rolls + 1
                    -- +1
                    if card.ability.extra.failed_rolls >= card.ability.extra.max_failed_rolls then
                        card.ability.extra.failed_rolls = 0
                        card.ability.extra.luxury = card.ability.extra.luxury + card.ability.extra.luxury_mod 
                    end
                    return { message = localize("k_upgrade_ex") }
                end
            end
        end,
        demicoloncompat = false,
    }
}
