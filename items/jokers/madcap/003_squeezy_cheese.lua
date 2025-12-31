local calc_func = function(self, card, context)
    -- Most of this is handled in hooks
    if Madcap.Funcs.get_end_of_round(context) then
        return MadLib.food_joker_logic(card)
    end
    
    if context.after then
        card.ability.extra.xmult_store = 0
    end
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.forcetrigger then
            return { x_chips = MadLib.add(1, card.ability.extra.xchip_mod) }
        end
        if context.checktrigger then
            return context.joker_main and MadLib.is_positive_number(card.ability.extra.xmult_store)
        end
        return calc_func_ref(self, card, context)
    end
end

-- Might have a calculation issue.
return {
    data = {
        object_type = "Joker",
        key     = 'squeezy_cheeze',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,2),
        rarity  = 1,
        cost    = 4,
        config =  {
            extra = {
                x_chips          = 1,
                xchip_mod        = 0.2,
                xmult_mod        = 1,
                xmult_store      = 0,
                rounds_remaining = 8,
            }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                number_format(card.ability.extra.xchip_mod),
                number_format(card.ability.extra.xmult_mod),
                number_format(card.ability.extra.rounds_remaining))
        end,
        calculate = calc_func,
        demicoloncompat = true,
    },
}
