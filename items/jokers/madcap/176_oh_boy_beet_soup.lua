return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'oh_boy_beet_soup',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 9,
        config = { 
            extra = { x_mult = 1.4 } 
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            if
                context.joker_main
                and G.hand
            then
                local light_suits = {}
                if MadLib.list_matches_all(G.hand.cards, function(v)
                    if v:has_light_suit() then
                        light_suits[v.base.suit] = true
                        return true
                    end
                    return false
                end) then
                    return { xmult = card.ability.extra.x_mult ^ #light_suits }
                end
            end
        end,
    },
}
