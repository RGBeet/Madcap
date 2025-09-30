return {
    categories = {
        'Gimmick',
        'Spam'
    },
    data = {
        object_type = "Joker",
        key     = 'spam',
        atlas   = 'rgmc_spam',
        rarity  = 'rgmc_gimmick',
        cost    = 4,
        pos     = {x = 0, y = 0},
        config = {
            extra = { mult = 13, chips = 37, odds = 3, numer_factor = 0.1 },
            immutable = { mode = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
            return MadLib.collect_vars(
                number_format(card.ability.extra.mult),
                localize('rgmc_spam'),
                number_format(card.ability.extra.chips),
                localize('rgmc_maps'),
                number_format(_numer ^ (1 + (card.ability.numer_factor or 0))),
                number_format(_denom)
            )
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                local sound_effect = math.random(1,3)
                return {
                    message = localize("rgmc_spam_ex"),
                    chip_mod = lenient_bignum(card.ability.extra.chips),
                    mult_mod = lenient_bignum(card.ability.extra.mult),
                    sound = 'rgmc_spam'..tostring(sound_effect),
                }
            end
            if Madcap.Funcs.banana_context(context) then
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'spam', true)
                numerator = (1 + (card.ability.numer_factor or 0))
                local result = pseudorandom('spam') < numerator / denominator
                SMODS.post_prob = SMODS.post_prob or {}
                SMODS.post_prob[#SMODS.post_prob+1] = {
                    pseudorandom_result = true,
                    result = result,
                    trigger_obj = card,
                    numerator = numerator,
                    denominator = denominator,
                    identifier = 'spam'
                }
                if result then
                    G.GAME.spams_eaten = (G.GAME.spams_eaten or 0) + 1
                    MadLib.event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            MadLib.event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    card:remove()
                                    return true
                                end
                            })
                            return true
                        end
                    })
                    return { message = { "!!" }, colour = G.C.RED, }
                else
                    return { message = { localize('k_safe_ex') }, colour = G.C.GREEN, }
                end
            end
        end,
        demicoloncompat = true,
    }
}
