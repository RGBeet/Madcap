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
        calculate = function(self, card, context)
            -- mark the cards
            if context.scoring_hand and context.before then
                MadLib.loop_func(context.scoring_hand, function (v,i)
                    if not v.debuff then v.rgmc_cross = true end
                end)
            end
            -- disable the cards the cards
            if context.cardarea == G.play and context.other_card then
                for k,v in pairs do
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            SMODS.debuff_card(_card, true, 'rgmc_cross')
                            _card.rgmc_cross = nil
                            _card:juice_up(0.3, 0.3)
                            return true
                        end,
                    }))
                end
            end
            -- enable the cards
            if context.playing_card_end_of_round and context.cardarea == G.hand then
                local debuffed = MadLib.get_loop_func(G.hand.cards, function (v,i)
                    return v.ability.rgmc_cross -- TODO: card.ability.debuff_sources[source] = debuff
                end)
                MadLib.loop_func(debuffed, function(v,i)
                    MadLib.simple_event(function()
                        v.ability.rgmc_cross = nil
                        SMODS.debuff_card(v, false, 'rgmc_cross')
                        v:juice_up(0.3, 0.3)
                        return true
                    end, 0.7, 'after')
                end)
            end
        end
    }
}
