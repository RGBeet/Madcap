function Madcap.Funcs.get_three_trees_check(card, context)
    local sorted_hand = MadLib.shuffle_sort_list(context.scoring_hand, #context.scoring_hand, function(v)
        return not Card:is_suitless()
    end, function(a,b)
        local _a = MadLib.has_suit_in_list(a, MadLib.SuitTypes.Base, true) and 1 or 0
        local _b = MadLib.has_suit_in_list(b, MadLib.SuitTypes.Base, true) and 1 or 0
        return _a > _b
    end)
    local num_suits = 0
    MadLib.loop_table(MadLib.get_suits_from_cards(sorted_hand), function()
        num_suits = num_suits+1
    end)
    local dark_suit = MadLib.get_first_match_info(sorted_hand, function(v)
        return MadLib.has_suit_in_list(v, MadLib.SuitTypes.Dark, true)
    end, function(v)
        return v.base.suit
    end)
    local light_suit = MadLib.get_first_match_info(sorted_hand, function(v)
        return MadLib.has_suit_in_list(v, MadLib.SuitTypes.Light, true)
    end, function(v)
        return v.base.suit
    end)
    local modded_suit = MadcapConfig['Modded Suits'] and (MadLib.get_first_match_info(sorted_hand, function(v)
        return not MadLib.has_suit_in_list(v, MadLib.SuitTypes.Base, true)
            and v.base.suit ~= dark_suit
            and v.base.suit ~= light_suit
    end, function(v)
        return v.base.suit
    end)) or num_suits >= 3
    return modded_suit and dark_suit and light_suit
end

-- If Modded Suits are not enabled, Three Trees does not require a modded suit - just a light and dark.
return {
    data = {
        object_type = "Joker",
        key     = 'three_trees',
        atlas   = 'jokers',
        pos     = MLIB.coords(3,9),
        rarity  = 2,
        cost    = 6,
        config = {
            extra = { x_mult = 3, active = false }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.x_mult))
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.jokers
                and context.before and
                not context.blueprint
            then
                card.ability.extra.active = Madcap.Funcs.get_three_trees_check(card, context)
            end
            if context.checktrigger then
                return context.joker_main and card.ability.extra.active
            end
            if
                (context.joker_main and card.ability.extra.active)
                or context.forcetrigger
            then -- demicolon
                return { xmult = card.ability.extra.x_mult, card = card }
            end
        end,
        demicoloncompat = true,
        quasicoloncheck = true,
    }
}
