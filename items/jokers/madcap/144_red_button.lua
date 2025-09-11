function Madcap.Funcs.force_save()
    MadLib.event({
        func = function()
            save_run()
            G.FILE_HANDLER.force = true
        return true
    end})
end

return {
    categories = {
        'Unfinished Content',
        'Gimmick Jokers'
    },
    data = {
        object_type = "Joker",
        key     = 'red_button',
        atlas   = 'jokers',
        pos     = MLIB.coords(14,3),
        rarity  = 'rgmc_gimmick',
        cost    = 1,
        config  = {
            extra = { odds = 5, dollars = 20 }
        },
        loc_vars = function(self, info_queue, card)
            local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'red_button')
            return MadLib.collect_vars(number_format(numer), 
                number_format(denom),
                number_format(card.ability.extra.dollars))
        end,
        calculate = function(self, card, context)
            -- Retrigger held/scored
            if 
                (context.selling_self and not context.blueprint)
                or context.forcetrigger -- sneaky sneaky!
            then
                Madcap.Funcs.force_save()
                if not SMODS.pseudorandom_probability(card, 'red_button', 1, card.ability.extra.odds) then
                    ease_dollars(card.ability.extra.dollars)
                else -- game over man!
                    -- remove chips
                    MadLib.simple_event(function()
                        G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.3, 0.3)
                        G.GAME.chips = 0
                        G.GAME.blind.chips = 0
                        play_sound('card1', 1)
                        return true
                    end, 2.0, 'after')
                    
                    local time = 0.5
                    
                    -- remove deck cards
                    if G.deck.cards and #G.deck.cards > 0 then
                        MadLib.loop_func(G.deck.cards, function(v)
                            MadLib.simple_event(function()
                                v:start_dissolve({ HEX("FF0000") }, nil, time)
                                return true
                            end, time, 'after')
                        end)
                    end

                    -- remove hand cards
                    if G.hand.cards and #G.hand.cards > 0 then
                        MadLib.loop_func(G.hand.cards, function(v)
                            MadLib.simple_event(function()
                                v:start_dissolve({ HEX("FF0000") }, nil, time)
                                return true
                            end, time, 'after')
                        end)
                    end
                    
                    -- now do the game over!
                    MadLib.simple_event(function()
                        if G.STAGE == G.STAGES.RUN then G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false end
                        return true
                    end, 1.0, 'after')
                end
            end
        end,
        demicoloncompat = true,
    }
}
