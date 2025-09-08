return {
    categories = {
        'Unfinished Content',
        'Gimmick Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'spam_and_sausage',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 'rgmc_gimmick',
        cost    = 5,
        config  = {
            extra = { odds = 6, x_mult = 2 }
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'spam_and_sausage')
            return MadLib.collect_vars(number_format(numer), 
                number_format(denom),
                number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            -- Main stuff
            if context.joker_main or context.forcetrigger then
                return {
                    message = localize("rgmc_spam_ex"),
                    xmult   = lenient_bignum(card.ability.extra.mult),
                    func    = function()
                        local sound_effect = math.random(1, 4)
                        play_sound('rgmc_spam'..tostring(sound_effect), 1, 1)
                        return true
                    end
                }
            end
            -- End of round
            if Madcap.Funcs.banana_context(context) then
                if SMODS.pseudorandom_probability(card, 'spam_and_sausage', 1, card.ability.extra.odds) then
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
                                delay = 0.8,
                                blockable = false,
                                func = function()
                                    local spam_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_rgmc_spam")
                                    spam_card:add_to_deck()
                                    G.jokers:emplace(spam_card)
                                    return true
                                end
                            })
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
