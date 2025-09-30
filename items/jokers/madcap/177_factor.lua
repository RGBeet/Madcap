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
        config = { extra = { mult = 20 } },
        loc_vars = function(self, info_queue, card)
            local equation = math.sin((G.GAME.round-1) * (math.pi/6)) * card.ability.extra.mult * (G.jokers and #G.jokers.cards or 0)
            return MadLib.collect_vars(number_format(card.ability.extra.mult),
                number_format(equation))
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local light_suits = {}
                if MadLib.list_matches_all(G.hand.cards, function(v)
                    if v:has_light_suit() then
                        light_suits[v.base.suit] = true
                        return true
                    end
                    return false
                end) then
                    return { mult = math.sin((G.GAME.round-1) * (math.pi/6)) * card.ability.extra.mult * (G.jokers and #G.jokers.cards or 0) }
                end
            end
        end,
    },
}
