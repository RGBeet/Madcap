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
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
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
                if SMODS.pseudorandom_probability(card, 'red_button', 1, card.ability.extra.odds) then

                else -- game over man!
            
                    -- remove chips
                    MadLib.simple_event(function()
                        G.GAME.chips = 0
                        G.GAME.blind.chips = 0
                        return true
                    end, 2.0, 'after')
                    
                    -- remove hand cards
                    if G.hand.cards and #G.hand.cards > 0 then
                        MadLib.loop_func(G.hand.cards, function(v)
                            MadLib.simple_event(function()
                                v:remove()
                                return true
                            end, 0.08, 'after')
                        end)
                    end
                    
                    -- remove deck cards
                    if G.deck.cards and #G.deck.cards > 0 then
                        MadLib.loop_func(G.deck.cards, function(v)
                            MadLib.simple_event(function()
                                v:remove()
                                return true
                            end, 0.06, 'after')
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
