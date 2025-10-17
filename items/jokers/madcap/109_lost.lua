return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'lost',
        atlas   = 'jokers',
        pos     = MLIB.coords(10,8),
        rarity  = 1,
        cost    = 6,
        config = { extra = { antes_cleared = 0 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.antes_cleared)
        end,
        demicoloncompat = false, -- hell no
        calculate = function(self, card, context)
            if context.ante_change and context.ante_change ~= 0 then
                card.ability.extra.antes_cleared = card.ability.extra.antes_cleared + context.ante_change
                return {
                    message = (context.ante_change > 0 and "+" or "-") .. number_format(context.ante_change),
                    card    = card
                }
            end
            if
                context.end_of_round
                and context.game_over
                and context.main_eval
            then
                MadLib.event({
                    func = function()
                        -- remove the card
                        MadLib.event({
                            func = function()
                                if G.hand_text_area.blind_chips then G.hand_text_area.blind_chips:juice_up() end
                                if G.hand_text_area.game_chips then G.hand_text_area.game_chips:juice_up() end
                                play_sound('tarot1')
                                return true
                            end
                        })
                        -- Destroy all other cards, bypassing Eternal
                        MadLib.loop_func(G.jokers and G.jokers.cards or {}, function(v)
                            if v == card then return end
                            MadLib.event({
                                func = function()
                                    SMODS.destroy_cards(v, true, nil, true)
                                    return true
                                end
                            })
                        end)
                        -- Destroy all other cards, bypassing Eternal
                        MadLib.loop_func(G.consumeables and G.consumeables.cards or {}, function(v)
                            MadLib.event({
                                func = function()
                                    SMODS.destroy_cards(v, true, nil, true)
                                    return true
                                end
                            })
                        end)
                        -- Reset all playing cards
                        MadLib.event({
                            func = function()
                            MadLib.loop_func(G.playing_cards or {}, function(v)
                                if
                                    v.config.center == G.P_CENTERS.c_base
                                    and not v.edition
                                    and not v.seal
                                then
                                    return
                                end
                                v:set_ability(G.P_CENTERS.c_base)
                                v:set_edition(nil)
                                v:set_seal(nil)
                            end)
                            return true
                        end})
                        MadLib.event({
                            func = function()
                                if G.GAME.round_resets.ante ~= 1 then
                                    ease_ante(1-G.GAME.round_resets.ante)
                                end
                                if G.GAME.dollars ~= 0 then
                                    ease_dollars(4-G.GAME.dollars)
                                end
                                if G.GAME.rgmc_luxury_pts ~= 0 then
                                    ease_lp(-G.GAME.rgmc_luxury_pts)
                                end
                                return true
                            end
                        })
                        -- Next, destroy The Lost and create The Found
                        MadLib.event({
                            func = function()
                                SMODS.destroy_cards(card, true, nil, true)
                                return true
                            end
                        })
                        MadLib.event({
                            func = function()
                                local found = SMODS.add_card{
                                    key = 'j_rgmc_found',
                                    area = G.jokers,
                                }
                                found.ability.extra.mult = found.ability.extra.mult * (card.ability.extra.antes_cleared + 1)
                                return true
                            end
                        })
                    return true
                end})
                return {
                    message = localize('k_saved_ex'),
                    saved = 'ph_the_lost',
                    colour = G.C.RED
                }
            end
        end,
    }
}
