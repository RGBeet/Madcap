local get_probability_vars_ref = SMODS.get_probability_vars
function SMODS.get_probability_vars(trigger_obj, base_numerator, base_denominator, identifier, from_roll)
    local numerator, denominator = get_probability_vars_ref(trigger_obj, base_numerator, base_denominator, identifier, from_roll)

    numerator = (type(numerator) == "string" or numerator == nil) and 1 or numerator
    denominator = (type(denominator) == "string" or denominator == nil) and 1 or denominator

    local guaranteed = nil
    local any_active = false

    MadLib.loop_func({
        G.play,
        G.hand,
        G.jokers,
        G.consumeables
    }, function(list)
        if any_active then return end
        MadLib.loop_func(list.cards, function(v)
            if
                any_active
                or not v.ability
            then
                return
            end
            if 
                v.ability.rgmc_shichi_active ~= nil 
                and v.ability.rgmc_shichi_active == true 
            then
                numerator   = 1
                denominator = 1
                v.ability.rgmc_shichi_active = false
            end
        end)

    end)

    return numerator, denominator
end

return {
    data = {
        object_type = "Sticker",
        key         = "rgmc_shichi",
        atlas       = 'stickers',
        pos         = MLIB.coords(3,3),
        badge_colour = HEX('C13445'),
        should_apply = false,
        apply = function(self, card, val)
            card.ability.rgmc_shichi         = true
            card.ability.rgmc_shichi_active  = false
        end,
        calculate = function(self, card, context)
            -- Ready to do shit
            if context.setting_blind then
                card.ability.rgmc_shichi_active = true
                return {
                    message = localize('k_reset'),
                    colour  = G.C.FILTER
                }
            end
        end
    }
}
