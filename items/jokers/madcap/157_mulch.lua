function Madcap.Funcs.get_high_and_low(cards)
    local high_rank, low_rank = nil, nil
    local high_nom, low_nom = -99, 99

    MadLib.loop_func(cards, function(v)
        local value = SMODS.Ranks[MadLib.get_value(v)]
        local nominal = value.nominal + value.face_nominal
        if high_nom < nominal then
            high_rank   = value
            high_nom    = nominal
        end
        if low_nom > nominal then
            low_rank    = value
            low_nom     = nominal
        end
    end)

    return high_rank, low_rank
end

return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'mulch',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config = {
            extra = { 
                ranks = { '7', '2' },
                poker_hand = 'Straight', 
                active = false 
            }
        },
        loc_vars = function(self, info_queue, card)
            local little_dog = false
            if G.hand then
                local high_rank, low_rank = Madcap.Funcs.get_high_and_low(G.hand.cards)
                little_dog = high_rank == (card.ability.extra.ranks[1] or '7')
                    and low_rank == (card.ability.extra.ranks[2] or '2')
            end
            return MadLib.collect_vars(
                localize(card.ability.extra.ranks[1] or '7', 'ranks'),
                localize(card.ability.extra.ranks[2] or '2', 'ranks'),
                localize(card.ability.extra.poker_hand, 'poker_hands'),
                little_dog and localize("k_active_ex") or localize("rgmc_inactive"))
        end,
        calculate = function(self, card, context)
        end,
        demicoloncompat = true
    },
}
