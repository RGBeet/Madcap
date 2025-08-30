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
            if
                context.cardarea == G.jokers
                and context.before
                and context.scoring_hand
            then
                if MadLib.list_matches_all(G.play.cards, function(v)
                    return MadLib.has_fib_rank(v)
                end) then -- WOW U GOT THE FIBONACCI!!
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    return {
                        message = localize("k_upgrade_ex"),
                    }
                end
            end
            if -- demicolon
                context.joker_main
                or context.forcetrigger
            then
                return {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
                    chip_mod = card.ability.extra.chips
                }
            end
        end,
        perishable_compat = false,
        demicoloncompat = true,
    },
}
