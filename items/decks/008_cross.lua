Madcap.DeckFuncs['cross'] = {
    calculate = function(self, card, context)
        if context.scoring_hand and context.before then
            MadLib.loop_func(context.scoring_hand, function (v,i)
                if not v.debuff then v.rgmc_cross = true end
            end)
        end
        -- disable the cards the cards
        if
            context.cardarea == G.play
            and context.other_card
            and not context.other_card.debuff
            and context.other_card.rgmc_cross
        then
            context.other_card.rgmc_cross = nil
            local _card = context.other_card
            MadLib.simple_event(function()
                SMODS.debuff_card(_card, true, 'rgmc_cross')
                    play_sound('rgmc_laser')
                _card:juice_up(0.3, 0.3)
                return true
            end, 0.4, 'after')
        end

        -- enable the cards
        if context.end_of_round == true and context.game_over == false then
            MadLib.loop_func(G.hand.cards, function(v)
                if not (v.ability.debuff_sources and v.ability.debuff_sources['rgmc_cross']) then return end
                MadLib.simple_event(function()
                    SMODS.debuff_card(v, false, 'rgmc_cross')
                    v:juice_up(0.3, 0.3)
                    play_sound('rgmc_revert')
                    return true
                end, 0.7, 'after')
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = "!", colour = G.C.RED})
            end)
        end
    end
}

return {
    categories = {
        'Decks',
    },
    data = {
        object_type = "Back",
        key     = "cross",
        atlas   = 'decks',
        pos     = MLIB.coords(1,2),
        config = { hand_size = 1 },
        loc_vars = function(self)
            return MadLib.collect_vars(self.config.hand_size)
        end,
        apply = function(self, back)
            G.GAME.modifiers.rgmc_deck = true  -- music activated
            G.GAME.modifiers.rgmc_cross = true

        end,
        calculate = Madcap.DeckFuncs['cross'].calculate
    }
}
