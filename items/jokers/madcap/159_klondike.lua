return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'klondike',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = { extra = { chips = 7, odds = 13 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'klondike')
            return MadLib.collect_vars(
                number_format(card.ability.extra.chips),
                number_format(_numer),
                number_format(_denom))
        end,
        calculate = function(self, card, context)
            if
                context.individual
                and context.cardarea == G.play
                and MadLib.list_matches_one(Madcap.Lists.Enhancements.Money, function(v,k)
                    return SMODS.has_enhancement(context.other_card, "m_"..v)
                end)
            then
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) +
                    card.ability.extra.chips
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
            
            if Madcap.Funcs.banana_context(context) then
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'klondike', true)
                numerator = (1 + (card.ability.numer_factor or 0))
                local result = pseudorandom('redd_dacca') < numerator / denominator
                SMODS.post_prob = SMODS.post_prob or {}
                SMODS.post_prob[#SMODS.post_prob+1] = {
                    pseudorandom_result = true,
                    result = result,
                    trigger_obj = card,
                    numerator = numerator,
                    denominator = denominator,
                    identifier = 'redd_dacca'
                }
                return result and MadLib.banana_remove(card) or { message = localize("k_safe_ex") }
            end
        end,
        demicoloncompat = false
    },
}
