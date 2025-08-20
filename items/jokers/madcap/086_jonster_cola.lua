return {
    categories = {
        'Unusual'
    },
    data = {
        object_type = "Joker",
        key     = 'jonster_cola',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,5),
        rarity  = 'rgmc_unusual',
        cost    = 15,
        calculate = function(self, card, context)
            if ((context.selling_self and not context.blueprint) or context.forcetrigger) and type(Madcap.Funcs.safe_get(G.GAME, "MADCAP", "best_hand") or nil) == 'table' then
                local best_hand = G.GAME.best_hand
                local list = MadLib.get_combined_list(best_hand.play, best_hand.hand)
                local playing_round = (G.hand and #G.hand.cards > 0)
                MadLib.simple_event(function()
                    MadLib.simple_event(function()
                        if playing_round then
                            -- unhighlight everything
                            if #G.hand.highlighted > 0 then
                                MadLib.simple_event(function()
                                    G.hand:unhighlight_all()
                                    return true
                                end, 1.0, 'before')
                            end
                                -- put hands into the discard deck
                            MadLib.loop_func(G.hand.cards, function(v,i)
                                MadLib.simple_event(function()
                                    draw_card(G.hand,G.discard, i*100/#G.hand.cards,'down', nil, nil, 0.15)
                                    return true
                                end, 0.15, 'before')
                            end)
                        end
                        return true
                    end, 0.0, 'before')
                    -- shuffle the whole deck
                    MadLib.simple_event(function()
                        pseudoshuffle(G.deck.cards, pseudoseed('rgmc_jonster_cola'))
                        return true
                    end, 0.3, 'after')
                    -- do the recreating
                    MadLib.simple_event(function()
                        local all_cards = MadLib.dupe_from_card_info(list, function(n)
                            if playing_round then
                                G.hand:emplace(n)
                            else
                                G.deck:emplace(n)
                            end
                        end)
                        play_sound('rgmc_jonster_activate', 1, 0.5)
                        return true
                    end,0.0,'after')
                    -- effects
                    MadLib.simple_event(function()
                        playing_card_joker_effects(all_cards)
                        return true
                    end, 0.0, 'after')
                    return true
                end, 0.0, 'immediate')
                if context.forcetrigger then -- the jonster cola has been killed (make it explode later)
                    return MadLib.banana_remove(card)
                end
            end
        end,
        eternal_compat = false, -- dependent on selling
        demicoloncompat = true,
    }
}
