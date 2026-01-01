return {
    data = {
        object_type = "Joker",
        key     = 'ball_breaker',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,3),
        rarity  = 1,
        cost    = 3,
        config =  { extra = { chips = 0, chip_mod = 6, active = false } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.chip_mod), number_format(card.ability.extra.chips))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.joker_main
            end
            if
                context.cardarea == G.jokers
                and context.before
                and context.scoring_hand
            then
                if MadLib.list_matches_all(G.play.cards, function(v)
                    return MadLib.has_fib_rank(v)
                end) then
                    SMODS.scale_card(card, {
                        ref_table       = card.ability.extra,
                        ref_value       = "chips",
                        scalar_value    = "chip_mod",
                        message_key     = "a_chips",
                        message_colour  = G.C.CHIPS,
                    })
                end
                return nil, true
            end
            if context.joker_main or context.forcetrigger then
                return { chips = card.ability.extra.chips }
            end
        end,
        in_pool = function(self, args) -- At least one compatible card
            return MadLib.list_matches_one(G.playing_cards or {}, function(v)
                return MadLib.has_fib_rank(v)
            end)
        end,
        perishable_compat = false,
        demicoloncompat = true,
    },
}
