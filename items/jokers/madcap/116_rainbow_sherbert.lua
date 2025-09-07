return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'rainbow_sherbert',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { 
                chips   = 75,
                mult    = 15,
                dollars = 5,
                x_mult  = 1.6,
                hands_left = 12
            },
            immutable = { mode = 1 }
        },
        loc_vars = function(self, info_queue, card)
            local current, colour
            if card.ability.immutable.mode == 1 then
                current = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
                colour = G.C.CHIPS
            elseif card.ability.immutable.mode == 2 then
                current = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
                colour = G.C.MULT
            elseif card.ability.immutable.mode == 3 then
                current = localize { type = 'variable', key = 'a_money', vars = { card.ability.extra.dollars } }
                colour = G.C.MONEY
            else
                current = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
                colour = G.C.MULT
            end
            return MadLib.collect_vars_colours(card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.dollars,
                card.ability.extra.x_mult, card.ability.extra.hands_left, current, { colour })
        end,
        calculate = function(self, card, context)
            if 
                context.after
                and not context.blueprint 
            then
                if card.ability.extra.hands_left - 1 < 1 then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.immutable.mode = card.ability.immutable.mode + 1
                end
            end
            if context.joker_main then
                local ret = {}
                if choice == 1 then
                    ret.chips = card.ability.extra.chips
                elseif choice == 2 then
                    ret.mult = card.ability.extra.mult
                elseif choice == 3 then
                    ret.dollars = card.ability.extra.dollars
                else
                    ret.xmult = card.ability.extra.x_mult
                end
                
                ret.message = number_format(card.ability.extra.hands_left)
                return ret
            end
        end,
        demicoloncompat = true
    }
}
