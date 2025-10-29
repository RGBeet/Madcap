return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'wario_de_mambo',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 9,
        config = { 
            immutable = { index = 0 },
            extra = {
                poker_hands     = { nil, nil, nil, nil },
                luxury_points   = 5
            } 
        },
        loc_vars = function(self, info_queue, card)
            local hands     = {}
            local colours   = {}
            if card.ability.extra.poker_hands[1] ~= nil then
                for i=1,4 do hands[#hands+1] = localize(card.ability.extra.poker_hands[i], 'poker_hands') end
            else -- for collection?
                for i=1,4 do hands[#hands+1] = localize(MadLib.get_random_poker_hand(), 'poker_hands') end
            end
            for i=1,4 do
                local j = card.ability.immutable.index
                colours[#colours+1] = (i>j and G.C.FILTER)
                or (i==j+1 and G.C.ATTENTION)
                or G.C.GREEN
            end
            return MadLib.collect_vars_colours(hands[1], hands[2], hands[3], hands[4], card.ability.extra.luxury_points, colours)
        end,
        
        add_to_deck = function(self, card, from_debuff)
            for i=1,4 do
                card.ability.extra.poker_hands[i] = MadLib.get_random_poker_hand()
            end
        end,
        calculate = function(self, card, context)

            if context.joker_main or context.forcetrigger then
                if
                    next(context.poker_hands[card.ability.extra.poker_hands[card.ability.immutable.index + 1]])
                    or context.forcetrigger
                then
                    card.ability.immutable.index = card.ability.immutable.index < 3 and (card.ability.immutable.index + 1) or 0
                    if card.ability.immutable.index == 0 then
                        return {
                            rgmc_luxury_pts = card.ability.extra.luxury_points
                        }
                    else
                        return { 
                            message = number_format(card.ability.immutable.index) .. '/4'
                        }
                    end
                else
                    card.ability.immutable.index = 0
                    return {
                        message = localize('k_reset'),
                        colour = G.C.FILTER
                    }
                end
            end
        end,
        demicoloncompat = true,
    },
}
