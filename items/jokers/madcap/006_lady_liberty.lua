local calc_func = function(self, card, context)
    if
        (context.before
        and context.scoring_hand
        and G.GAME.current_round.hands_played == 0)
        or (context.forcetrigger and G.hand.cards)
    then
        local area = context.forcetrigger and G.hand.cards or context.scoring_hand or {}
        local n, max = 0, math.min(card.ability.extra.seals, card.ability.immutable.max_seals)
        local targets = {}

        for i=1, #area do
            if not area[i].seal then
                n = n + 1
                targets[n] = area[i]
                if not (n < max) then break end
            end
        end
        
        MadLib.loop_func(targets, function(v)
            MadLib.simple_event(function()
                v:set_seal('rgmc_patina', true)
                v:juice_up(0.3,0.3)
                play_sound('tarot2', 1.2, 0.4)
                return true
            end, 0.4, 'immediate')
        end)
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then
            return (context.before and context.scoring_hand and G.GAME.current_round.hands_played == 0)
        end
        return calc_func_ref(self, card, context)
    end
end

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
            --MadLib.add_to_queue({ set = "Other", key = "rgmc_patina_seal" })
            return MadLib.collect_vars(math.floor(math.min(card.ability.extra.seals, card.ability.immutable.max_seals)))
        end,
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    },
}
