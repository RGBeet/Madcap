return {
    categories = {
        'Unreleased',
    },
    data = {
        object_type = "Joker",
        key     = 'funeral_for_a_friend',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 11,
        config = { 
            extra = { 
                x_mult      = 1,
                xmult_mod   = 0.2, 
                rank        = 'Jack'
            },
            immutable = {
                suits_destroyed  = {},
                max_suits        = 7
            }
        },
        loc_vars = function(self, info_queue, card)
            local full_vars = {
                [7]         = number_format(card.ability.extra.x_mult),
                [8]         = localize(card.ability.extra.rank,'ranks'),
                [9]         = number_format(card.ability.extra.xmult_mod),
                [10]        = number_format(#(card.ability.immutable.suits_destroyed or {})),
                [11]        = number_format(card.ability.immutable.max_suits),
                ['colours'] = {}
            }
            for i = 1,6 do
                local suit = (card.ability.immutable.suits_destroyed or {})[i]
                full_vars[i] = suit and localize(card.ability.extra.suit, 'suits_plural') or '???'
                full_vars['colours'][i] = suit and G.C.SUITS[suit] or G.C.INACTIVE
            end

            return { vars = full_vars }
        end,
        calculate = function(self, card, context)
            if context.destroying_card then
                --print("destroying card")
                --print(context.destroying_card)
            end

            if context.destroy_card then
                --print("destroy card")
                --print(context.destroy_card)
            end

            if -- destroyed card is a Jack
                context.destroying_card
                and MadLib.is_rank(context.destroying_card, SMODS.Ranks[card.ability.extra.rank].id)
            then
                local suits = MadLib.get_suits_from_cards(G.playing_cards or {})
                MadLib.loop_func(suits, function(v)
                    if not context.destroying_card:is_suit(v) then return false end
                    if
                        MadLib.list_matches_all(card.ability.immutable.suits_destroyed, function(v2)
                            return v ~= card.ability.immutable.suits_destroyed[i]
                        end)
                    then
                        card.ability.immutable.suits_destroyed[#card.ability.immutable.suits_destroyed+1] = v
                    end
                    return true
                end)
                if #card.ability.immutable.suits_destroyed > card.ability.immutable.max_suits then
                    MadLib.simple_event(function()
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        MadLib.event({
                            trigger = 'after',
                            delay = 0.8,
                            blockable = false,
                            func = function()
                                local ncard = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_rgmc_love_lies_bleeding")
                                ncard:add_to_deck()
                                ncard:set_edition(card.edition)
                                G.jokers:emplace(ncard)
                                return true
                            end
                        })
                        return true
                    end)
                    MadLib.simple_event(function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true
                    end, 0.3, 'after', false)
                end
            end
        end,
    },
}
