return {
    categories = {
        'Cosma Tarots'
    },
    data = {
        object_type = "Joker",
        key     = 'cosmamancer',
        atlas   = 'jokers',
        pos     = MLIB.coords(7,4),
        rarity  = 2,
        cost    = 7,
        config = { },
        loc_vars = function(self, info_queue, card)
            return { vars = {} }
        end,
        calculate = function(self, card, context)
            if (context.setting_blind or context.forcetrigger) and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                MadLib.simple_event(function()
                    local n_card = create_card("CosmaTarot", G.consumeables)
                    n_card:add_to_deck()
                    G.consumeables:emplace(n_card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end, 0.08, 'before')
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_plus_cosma"), colour = G.C.RGMC_COSMATAROT})
            end
        end,
        demicoloncompat = true,
    }
}
