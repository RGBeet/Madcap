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
            extra = { bonus_suit = MadcapConfig['New Suits'] and 'rgmc_towers' or 'Clubs' }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(localize(card.ability.extra.bonus_suit, 'suits_plural'), card.ability.extra.xmult_mod, card.ability.extra.x_mult, { G.C.SUITS[card.ability.extra.bonus_suit] })
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

            if (context.cardarea == G.play and (context.other_card and context.other_card.bobby_khan)) or context.forcetrigger then
                local target = not context.forcetrigger
                    and context.other_card
                    or pseudoshuffle(MadLib.get_list_matches(G.hand.cards, function(v)
                        return MadLib.has_suit_in_list(v, MadLib.SuitTypes.Light)
                    end), pseudoseed('rgmc_bobby_khan'))[1]

                local dark_cards = MadLib.get_list_matches(G.hand.cards, function(v) for _,k in pairs(MadLib.SuitTypes.Dark) do if v:is_suit(k) then return true end; end end)
                local value = not MadLib.has_rank_in_list(MadLib.RankTypes.Irregular)
                    and target.base.nominal
                    or 10 -- fallback
                value = math.floor(MadLib.clamp(value,0,50) / #dark_cards)
                MadLib.simple_event(function()
                    target:start_dissolve({G.C.RED}, nil, 1.6)
                    return true
                end, 1.0, 'after')
                MadLib.loop_func(dark_cards, function (v)
                    MadLib.simple_event(function()
                        delay(0.1)
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
