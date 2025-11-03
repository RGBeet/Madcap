return {
    data = {
        object_type = "Joker",
        key         = 'legend_bobby',
        atlas       = 'jokers_legendary',
        pos         = MLIB.legend(4,false),
        soul_pos    = MLIB.legend(4,true),
        rarity      = 4,
        cost        = 17,
        config =  {
            extra = { bonus_suit = MadcapConfig['New Suits'] and 'rgmc_towers' or 'Clubs', bonus_value = 2 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(localize(card.ability.extra.bonus_suit, 'suits_plural'), card.ability.extra.bonus_value, { G.C.SUITS[card.ability.extra.bonus_suit] })
        end,
        add_to_deck = function(self, card, from_debuff)
            -- Make the Bobby Khan noise (it's a reference to the source material.)
            play_sound('rgmc_ominous', 0.8, 0.8)
        end,
        calculate = function(self, card, context)

            if context.before and context.scoring_hand then
                local scored_light_cards = MadLib.get_list_matches(context.scoring_hand, function (v)
                    for _,k in pairs(MadLib.SuitTypes.Light) do
                        if v:is_suit(k) then return true end
                    end
                    return false
                end)
                MadLib.loop_func(scored_light_cards, function (v) v.bobby_khan = true end)
            end

            if context.final_scoring_step then
                local value = 0
                local marked_cards = MadLib.get_list_matches(context.scoring_hand, function(v)
                    if v.bobby_khan then
                        value = value + not MadLib.has_rank_in_list(v, MadLib.RankTypes.Irregular) and v.base.nominal or 10 -- fallback
                    else
                        return false
                    end
                end)
                SMODS.destroy_cards(marked_cards, nil, nil, true)
                local dark_cards = MadLib.get_list_matches(G.hand.cards, function(v) for _,k in pairs(MadLib.SuitTypes.Dark) do if v:is_suit(k) then return true end; end; end)
                value = value / #dark_cards
                MadLib.loop_func(dark_cards, function (v)
                    MadLib.simple_event(function()
                        v.ability.perma_bonus = (v.ability.perma_bonus or 0) + (v:is_suit(card.ability.extra.bonus_suit) and (value * 2) or value)
                        v:juice_up(0.5, 0.5)
                        play_sound("timpani")
                        return true
                    end, 1.0, 'after')
                end)
            end

            if context.forcetrigger then
                local held_light_cards = MadLib.get_list_matches(G.hand.cards, function (v)
                    for _,k in pairs(MadLib.SuitTypes.Light) do
                        if v:is_suit(k) then return true end
                    end
                    return false
                end)
                local random_hand_card = pseudorandom_element(held_light_cards, pseudoseed('bobby_khan'))
                local dark_cards = MadLib.get_list_matches(G.hand.cards, function(v) for _,k in pairs(MadLib.SuitTypes.Dark) do if v:is_suit(k) then return true end; end; end)
                local value = (MadLib.has_rank_in_list(random_hand_card, MadLib.RankTypes.Irregular) and random_hand_card.base.nominal or 10) / #dark_cards
                SMODS.destroy_cards(random_hand_card, nil, nil, true)
                MadLib.loop_func(dark_cards, function (v)
                    MadLib.simple_event(function()
                        v.ability.perma_bonus = (v.ability.perma_bonus or 0) + (v:is_suit(card.ability.extra.bonus_suit) and (value * 2) or value)
                        v:juice_up(0.5, 0.5)
                        play_sound("timpani")
                        return true
                    end, 1.0, 'after')
                end)
            end
        end,
        blueprint_compat = false,
        perishable_compat = false,
        demicoloncompat = true,
    }
}
