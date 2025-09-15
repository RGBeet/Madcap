-- numer_factor is used to nerf the redd dacca slightly on crytid's beige deck
return {
    categories = {
        'OP Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'redd_dacca',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,1),
        rarity  = 1,
        cost    = 8,
        config = {
            extra = { e_mult = 1.2, odds = 200 },
            immutable = { numer_factor = 0.1 }
        },
        yes_pool_flag = "gros_michel_extinct", -- Gros Michel has been removed
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            return MadLib.collect_vars(
                    number_format(card.ability.extra.e_mult),
                    number_format(_numer ^ (1 + (card.ability.immutable.numer_factor or 0))),
                    number_format(_denom)
            )
        end,
        calculate = function(self, card, context)
            -- ^1.2 Mult
            if
                context.forcetrigger or
                (context.cardarea == G.jokers and context.joker_main)
            then
                return { emult = card.ability.extra.e_mult }
            end

            -- End of round
            if Madcap.Funcs.banana_context(context) then
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'redd_dacca', true)
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
        eternal_compat  = false,
        demicoloncompat = true,
    },
}
