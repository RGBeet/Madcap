-- Prevents adjacent consumables from being used?

function MadLib.get_adjacent_cards(card)
    if not (card and card.area) then return end
    local index = -1
    for i = 1, #card.area.cards do
        if card.area.cards[i] == card then index = i; break; end
    end
    return { card.area.cards[index - 1], card.area.cards[index + 1] }
end

return {
    data = {
        object_type = "Sticker",
        key     = "rgmc_toxic",
        atlas   = 'stickers',
        pos     = MLIB.coords(1,1),
        badge_colour = HEX('A154EB'),
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(0))
        end,
        calculate = function(self, card, context)
            if
                context.joker_main
                or (context.main_scoring and (context.cardarea == G.play or context.cardarea == G.hand))
            then
                MadLib.loop_func(MadLib.get_adjacent_cards(card), function(v)
                    if v == nil then return end
                    card_eval_status_text(v, "extra", nil, nil, nil, { message = localize("k_debuffed") })
                    SMODS.debuff_card(v, true, card.config.center.key)
                end)
            end

            if context.after then
                MadLib.loop_func(card.area.cards, function(v)
                    if not (v.ability.debuff_sources and v.ability.debuff_sources[card.config.center.key]) then return end
                    SMODS.debuff_card(v, false, card.config.center.key)
                end)
            end
        end,
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_toxic = true
        end,
    }
}
