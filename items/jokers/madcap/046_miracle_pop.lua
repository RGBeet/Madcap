-- If Goblets are disabled, it uses Diamonds instead.
local secondary_suit = (MadcapConfig['New Suits'] ~= false) and 'rgmc_goblets' or 'Diamonds'
return {
    data = {
        object_type = "Joker",
        key     = 'miracle_pop',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,5),
        rarity  = 3,
        cost    = 8,
        config  = {
            extra = { chips = 0, chip_mod = 5, suits = { "Hearts", secondary_suit } }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suits[1], 'suits_singular'),
                localize(card.ability.extra.suits[2], 'suits_singular'),
                number_format(card.ability.extra.chip_mod),
                number_format(card.ability.extra.chip_mod * 2),
                number_format(card.ability.extra.chips),
                number_format(G.hand and #G.hand.cards or 0),
                number_format((G.hand and #G.hand.cards > 1)
                    and math.floor(card.ability.extra.chips / #G.hand.cards) or 0), {
                        G.C.SUITS[card.ability.extra.suits[1]],
                        G.C.SUITS[card.ability.extra.suits[2]]
                    })
        end,
        calculate = function(self, card, context)
            if
                (context.cardarea == G.play
                    and context.other_card
                    and not context.blueprint)
                or context.forcetrigger
            then
                if -- hearts and goblets
                    context.other_card:is_suit(card.ability.extra.suits[1])
                    or context.other_card:is_suit(card.ability.extra.suits[2])
                then
                    local upgrade =
                        context.other_card:is_suit(card.ability.extra.suits[2])
                        and card.ability.extra.chip_mod * 2
                        or  card.ability.extra.chip_mod

                    return MadLib.get_detailed_upgrade_data(MadLib.ScoreKeys.AddChips, card, upgrade)
                end
            end

            -- selling divides the chips among the cards
            if context.selling_self then
                local div = math.floor(card.ability.extra.chips/#G.hand.cards)
                MadLib.loop_func(G.hand.cards, function(v)
                    MadLib.simple_event(function()
                        v.ability.perma_bonus = v.ability.perma_bonus + div
                        v:juice_up(0.3, 0.4)
                        return true
                    end, 0.4, 'immediate')
                end)
            end
        end,
        eternal_compat = false,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
