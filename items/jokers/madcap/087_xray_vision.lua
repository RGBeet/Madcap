return {
    categories = {
        'Unusual'
    },
    data = {
        object_type = "Joker",
        key     = 'xray_vision',
        atlas   = 'jokers',
        pos     = MLIB.coords(8,6),
        rarity  = 'rgmc_unusual',
        cost    = 12,
        config = {
            extra = { odds = 3, drawn_cards = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'xray_vision')
            return MadLib.collect_vars(
                number_format(_numer),
                number_format(_denom),
                number_format(card.ability.extra.drawn_cards or 1))
        end,
        calculate = function(self, card, context)
            if (context.drawing_cards and (context.amount and context.amount > 0) and (SMODS.drawn_cards and #SMODS.drawn_cards > 0) and SMODS.pseudorandom_probability(card, 'xray_vision', 1, card.ability.extra.odds)) or context.forcetrigger then
                local target = G.hand
                if not target then return false end
                MadLib.simple_event(function()
                    play_sound('rgmc_blip', 1, 0.5)
                    return true
                end, 0.5, 'after')
                local cards_to_draw = math.min((card.ability.extra.drawn_cards or 1), G.deck.config.card_limit-1, target.config.card_limit-1)
                local best = MadLib.shuffle_sort_list(G.deck.cards, cards_to_draw, function(v) return true end, function(a,b) return MadLib.get_card_total_value(a) > MadLib.get_card_total_value(b) end)
                local worst = MadLib.shuffle_sort_list(target.cards, cards_to_draw, function(v) return true end, function(a,b) return MadLib.get_card_total_value(a) < MadLib.get_card_total_value(b) end)
                MadLib.simple_event(function()
                    -- draw best card
                    if best then  MadLib.loop_func(best, function(v,i) draw_card(G.deck, target, i*100/#best, 'up', nil, v) end) end
                    return true
                end, 1.0, 'after')
                MadLib.simple_event(function()
                    if worst then MadLib.loop_func(worst, function(v,i) draw_card(target, G.deck, i*100/#worst, 'down', nil, v) end) end
                    return true
                end, 1.0, 'after')
            end
        end,
        demicoloncompat = true,
    }
}
