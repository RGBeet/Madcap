
local calc_func = function(self, card, context)
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
end

-- Only add extra code if Overloaded or Cryptid requires it
if Overloaded or Cryptid then
    local calc_func_ref = calc_func
    calc_func = function(self, card, context)
        if context.checktrigger then -- Check
            return context.cardarea == G.play
                and MadLib.has_contexts(context, 'other_card', 'individual')
                and context.other_card.seal
        end
        if context.forcetrigger then -- Trigger
            local seals = {}
            MadLib.loop_func(G.playing_cards, function(v)
                if v.seal ~= nil then seals[#seals+1] = v.seal end
            end)
            if #seals == 0 then seals = { 'Red', 'Yellow', 'Blue', 'Purple' } end
            MadLib.loop_func(G.hand.cards, function(c)
                if not SMODS.pseudorandom_probability(card, 'vari_seala', 1, card.ability.extra.odds) then return end
                MadLib.seal_event(c, context.other_card.seal)
            end)
        end
        return calc_func_ref(self, card, context)
    end
end

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
            return MadLib.collect_vars(math.max(0,number_format(_numer)), number_format(_denom))
        end,
        calculate = calc_func,
        demicoloncompat = true,
        quasicoloncheck = true
    }
}
