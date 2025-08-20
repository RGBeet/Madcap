return {
    categories = {
        'Seals'
    },
    data = {
        object_type = "Joker",
        key     = 'lady_liberty',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,5),
        rarity  = 1,
        cost    = 3,
        config  = {
            extra = { seals = 1 },
            immutable = { max_seals = 10 }
        },
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue({ set = "Other", key = "rgmc_patina_seal" })
            return MadLib.collect_vars(math.floor(math.min(card.ability.extra.seals, card.ability.immutable.max_seals)))
        end,
        calculate = function(self, card, context)
            if
                context.before
                and G.GAME.current_round.hands_played == 0  -- first round only!
            then
                local shuffled   = MadLib.shuffle_sort_list(context.scoring_hand, math.min(card.ability.extra.seals, card.ability.immutable.max_seals), function(v)
                    return not v.seal
                end)

                MadLib.loop_func(shuffled, function(v)

                end)

                MadLib.loop_check_func_limited(shuffled, function(v)
                    return not v.seal -- no seal
                end, function(v)
                    MadLib.seal_event(v,'rgmc_patina')
                end, card.ability.extra.seals)
            end
        end,
        demicoloncompat = true,
    },
}
