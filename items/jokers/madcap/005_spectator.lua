return {
    data = {
        object_type = "Joker",
        key     = 'spectator',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,4),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { mult_mod = 3, mult = 0 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.mult_mod))
        end,
        calculate = function(self, card, context)

            -- Before scoring, count the unscored cards.
            if
                context.cardarea == G.jokers
                and context.before
                and not context.blueprint
            then
                local cards = 0
                MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = true end)

                MadLib.loop_func(context.full_hand, function(v)
                    if not v.not_spectator then
                        cards = cards + 1
                        MadLib.simple_event(function()
                            v:juice_up()
                            return true
                        end, 0.5, 'after')
                    end
                end)

                MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = nil end)

                card.ability.extra.mult = cards * card.ability.extra.mult_mod or 0
            end

            if
                context.joker_main
                and card.ability.extra.mult > 0
            then
                return { mult = card.ability.extra.mult }
            end
        end,
        demicoloncompat = true,
    },
}
