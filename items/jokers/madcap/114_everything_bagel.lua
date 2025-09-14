-- Give $3 if hand has 3+ unscored cards
return {
    categories = {
        'Unfinished Content'
    },
    data = {
        object_type = "Joker",
        key     = 'everything_bagel',
        atlas   = 'jokers',
        pos     = MLIB.coords(11,3),
        rarity  = 1,
        cost    = 6,
        config = {
            extra = { chips = 5, rounds_remaining = 5 },
            immutable = { combos = {} }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.chips),
                number_format(card.ability.extra.chips * #card.ability.immutable.combos),
                number_format(card.ability.extra.rounds_remaining),
                { MadLib.get_warning_colour(card.ability.extra.rounds_remaining / 5) })
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and not context.blueprint then
                local rank = SMODS.Ranks[context.other_card.base.value].card_key
                local suit = SMODS.Suits[context.other_card.base.suit].card_key
                local combination = rank..'_'..suit

                if not MadLib.list_matches_one(card.ability.immutable.combos, function(v)
                    return combination == v
                end) then
                    table.insert(card.ability.immutable.combos, combination)
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS
                    }
                end
            end
            if
                (context.forcetrigger or context.joker_main)
                and #card.ability.immutable.combos > 0
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddChips, 
                    card, card.ability.extra.chips * #card.ability.immutable.combos)
            end
            -- Food Joker end logic
            Madcap.Funcs.food_joker_round_end(card)
        end,
        demicoloncompat = true
    }
}
