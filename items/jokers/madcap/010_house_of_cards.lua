local calc_func = function(self, card, context)
    if context.pre_discard then
        card.ability.immutable.increase = MadLib.clamp(card.ability.immutable.increase+1, 0, card.ability.immutable.odds)
            MadLib.simple_event(function()
                card:juice_up()
                return true
            end, 0, 'after')
    end

    if
        context.cardarea == G.jokers
        and (context.before or context.forcetrigger)
    then
        SMODS.scale_card(card, {
			ref_table       = card.ability.extra,
			ref_value       = "chips",
			scalar_value    = "chip_mod",
			message_key     = "a_chips",
			message_colour  = G.C.CHIPS,
		})

        if context.joker_main and MadLib.is_positive_number(card.ability.extra.chips) then
            return { chips = card.ability.extra.chips }
        end

        if 
            context.end_of_round 
            and context.game_over == false
            and context.main_eval 
            and not context.blueprint 
        then
            if SMODS.pseudorandom_probability(card, 'house_of_cards', 1 + card.ability.immutable.increase, card.ability.immutable.odds) then
                local new_chips = math.floor(MadLib.divide(card.ability.extra.chips, 2))
                card.ability.immutable.increase = 0
                card.ability.extra.chips = new_chips
                return {
                    message = number_format(new_chips),
                    colour = G.C.FILTER,
                    message_card = card
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.GREEN,
                    message_card = card
                }
            end
        end
    end    
end

if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then -- Check
            return context.cardarea == G.jokers and context.before
        end
        return calc_func_ref(self, card, context)
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'house_of_cards',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,9),
        rarity  = 1,
        cost    = 3,
        config = {
            immutable = { odds = 6, increase = 0 }, -- if this was mutable, it would ruin the card
            extra = {
                chip_mod = 6,
                chips = 0
            }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, MadLib.add(1, card.ability.immutable.increase), card.ability.immutable.odds, 'house_of_cards')
            return MadLib.collect_vars(number_format(card.ability.extra.chip_mod),
                number_format(_numer),
                number_format(_denom),
                number_format(card.ability.extra.chips))
        end,
        calculate = calc_func,
        perishable_compat   = false,
        demicoloncompat     = true,
    },
}
