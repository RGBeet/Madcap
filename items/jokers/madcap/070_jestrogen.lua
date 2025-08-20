return {
    categories = {
        'Stickers' -- immutable
    },
    data = {
        object_type = "Joker",
        key     = 'jestrogen',
        atlas   = 'jokers',
        pos     = MLIB.coords(6,9),
        rarity  = 2,
        cost    = 7,
        config = {
            extra = {
                odds = 5, rank_old = "King", rank_new = "Queen", chip_mod = 20
            }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'jestrogen')
            return MadLib.collect_vars(_numer,
                _denom,
                card.ability.extra.rank_old,
                card.ability.extra.chip_mod,
                card.ability.extra.rank_new)
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.other_card and MadLib.get_card_value(context.other_card) == card.ability.extra.rank_old and SMODS.pseudorandom_probability(card, 'jestrogen', 1, card.ability.extra.odds) then
                local target = context.other_card
                MadLib.simple_event(function()
                    play_sound('rgmc_flourish', 1, 0.4)
                    target:set_rgmc_immutable(true)
                    target:juice_up()
                    target.ability.perma_bonus = (target.ability.perma_bonus or 0) + card.ability.extra.chip_mod
                    SMODS.change_base(target, _, card.ability.extra.rank_new)
                return true
                end, 0.2, 'immediate')
            end
            if context.forcetrigger then
                local targets = MadLib.get_card_from_shuffled_deck(G.hand.cards, 1, function(c)
                    return MadLib.get_card_value(c) == card.ability.extra.rank_old
                end)
                MadLib.loop_func(targets, function(v)
                    MadLib.simple_event(function()
                        play_sound('rgmc_flourish', 0.76, 0.4)
                        target:juice_up()
                        target.ability.perma_bonus = (target.ability.perma_bonus or 0) + card.ability.extra.chip_mod
                        SMODS.change_base(target, _, card.ability.extra.rank_new)
                    return true
                    end, 0.2, 'immediate')
                end)
            end
        end,
        demicoloncompat = true,
    }
}
