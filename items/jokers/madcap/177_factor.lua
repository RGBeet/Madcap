function Madcap.Funcs.get_factor_joker_value(card)
    local jokers = (G.jokers and #G.jokers.cards) or 0
    local mult   = card.ability.extra.x_mult or 1
    local sine01    = (math.sin((G.GAME.round - 0.75) * (2 * math.pi / 5)) + 1) / 2
    local floor     = math.max(0, 1 - ((jokers - 1) / 7))
    local peak      = jokers * mult
    local amplitude = math.max(0, peak - floor)   -- force visible waviness when peak == floor
    local y         = floor + sine01 * amplitude
    return y
end

--

return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'factor',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 5,
        config = { extra = { x_mult = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(Madcap.Funcs.get_factor_joker_value(card)),
                number_format(G.GAME.rounds or 0),
                number_format(G.jokers and #G.jokers.cards or 0),
                number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return { xmult = Madcap.Funcs.get_factor_joker_value(card)}
            end
        end,
    },
}
