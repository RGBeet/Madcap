return {
    data = {
        object_type = "Joker",
        key     = 'vari_seala',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 4,
        config =  {
            extra = { odds = 4 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vari_seala')
            return MadLib.collect_vars(math.max(0,number_format(_denom - _numer)), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.play
                and MadLib.has_contexts(context, 'other_card', 'individual')
                and context.other_card.seal
            then
                -- If roll is successful, loop through X random cards in shuffled hand
                if SMODS.pseudorandom_probability(card, 'vari_seala', 1, card.ability.extra.odds) then
                    local target = MadLib.shuffle_sort_list(G.hand.cards, 1, function(v) return true end)
                    MadLib.loop_func(target, function(c) MadLib.seal_event(c,context.other_card.seal) end)
                end
            end
        end,
        demicoloncompat = true,
    }
}
