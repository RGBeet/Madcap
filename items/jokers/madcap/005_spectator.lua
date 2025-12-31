local calc_func = function(self, card, context)
    if context.joker_main then
        -- mark the scoring cards
        local cards = 0
        MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = true end)
        -- do the jiggle
        MadLib.loop_func(context.full_hand, function(v)
            if not v.not_spectator then
                cards = cards + 1
                MadLib.simple_event(function()
                    v:juice_up()
                    return true
                end, 0.75, 'after')
            end
        end)
        MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = nil end)
        -- do the mult
        local amt = MadLib.multiply(cards, card.ability.extra.mult)
        if MadLib.is_positive_number(amt) then
            return { mult = card.ability.extra.mult }
        end
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = true end)
            local cards = MadLib.loop_func(context.full_hand, function(v)
                return v.not_spectator
            end)
            MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = nil end)
            return cards > 0
        end
        if context.forcetrigger then
            local cards = 0
            MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = true end)
            -- do the jiggle
            MadLib.loop_func(context.full_hand, function(v)
                if not v.not_spectator then
                    cards = cards + 1
                    MadLib.simple_event(function()
                        v:juice_up()
                        return true
                    end, 0.75, 'after')
                end
            end)
            MadLib.loop_func(context.scoring_hand, function(v) v.not_spectator = nil end)
            -- do the mult
            local amt = MadLib.multiply(cards, card.ability.extra.mult)
            if MadLib.is_positive_number(amt) then
                return { mult = card.ability.extra.mult }
            end
        end
        return calc_func_ref(self, card, context)
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'spectator',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,4),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { mult_mod = 3 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.mult_mod))
        end,
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
