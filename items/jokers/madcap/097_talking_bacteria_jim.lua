return {
    categories = {
        'Gimmick',
    },
    data = {
        object_type = "Joker",
        key     = 'talking_bacteria_jim',
        atlas   = 'jokers',
        pos     = MLIB.coords(9,6),
        rarity  = 'rgmc_gimmick',
        cost    = 2,
        config = {
            extra = { odds = 2 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'talking_bacteria_jim')
            return MadLib.collect_vars(_numer, _denom)
        end,
        remove_from_deck = function(self, card, from_debuff)
            -- Remove all the mitosis stuff.
            MadLib.loop_func(G.playing_cards, function(v)
                if v.mitosis then v:start_dissolve() end
            end)
        end,
        calculate = function(self, card, context)
            if context.first_hand_drawn or context.forcetrigger then
                if SMODS.pseudorandom_probability(card, 'talking_bacteria_jim', 1, card.ability.extra.odds) then
                    MadLib.simple_event(function()
                        local hand_cards = MadLib.shuffle_sort_list(G.hand.cards, 1, function(v)
                            return not v.mitosis
                        end, function(a,b)
                            return a:get_points() > b:get_points()
                        end)
                        if hand_cards then
                            MadLib.simple_event(function()
                                local new_card = copy_card(hand_cards[1], nil, nil, self.playing_card)
                                new_card:add_to_deck()
                                table.insert(G.playing_cards, new_card)
                                G.hand:emplace(new_card)
                                new_card.area = G.hand
                                new_card.mitosis = true
                                play_sound('rgmc_pop', 1, 1)
                                return true
                            end, 1.0, 'after')
                        end
                        return true
                    end, 2.0, 'after')
                end
            end
            if context.pre_discard and SMODS.pseudorandom_probability(card, 'talking_bacteria_jim', 1, card.ability.extra.odds*2) then
                MadLib.simple_event(function()
                    play_sound('rgmc_bacteria_laugh', 1, 1)
                    return true
                end, 2.0, 'immediate')
                delay(0.3)
                MadLib.loop_func(G.playing_cards, function(v)
                    if v.mitosis then
                        MadLib.simple_event(function()
                            v:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end, 1.0, 'after')
                    end
                end)
            end
        end,
        demicoloncompat = true,
    }
}
