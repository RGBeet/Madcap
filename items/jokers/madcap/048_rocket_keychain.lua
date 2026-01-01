--TODO: get proper loc_vars for planet
return {
    data = {
        object_type = "Joker",
        key     = 'rocket_keychain',
        atlas   = 'jokers',
        pos     = MLIB.coords(4,7),
        rarity  = 3,
        cost    = 10,
        config =  {
            extra = { level_factor = 1, target_hand = "High Card" }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.target_hand, 'poker_hands'),
                    number_format(card.ability.extra.level_factor),
                    localize(MadLib.get_most_played_hand(), 'poker_hands'))
        end,
        calculate = function(self, card, context)
            if context.checktrigger then
                return context.level_up_hand
                    and context.level_up_hand == card.ability.extra.target_hand
                    and context.other_card ~= card
            end
            if context.setting_blind then
                card.ability.extra.target_hand = MadLib.get_random_poker_hand()
                MadLib.simple_event(function()
                    play_sound((sound or 'tarot2'), 0.76, 0.4)
                    card:juice_up(0.3, 0.4)
                    return true
                end)
            end
            -- TODO: add this whenever target hand is leveled up
            if 
                (context.level_up_hand
                and context.level_up_hand == card.ability.extra.target_hand
                and context.other_card ~= card)
                or context.forcetrigger
            then
                card.ability.extra.target_hand = MadLib.get_random_poker_hand()
                SMODS.smart_level_up_hand(card, MadLib.get_most_played_hand(), nil, card.ability.level_factor or 1)
                delay(1.0)
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            card.ability.extra.target_hand = MadLib.get_random_poker_hand()
        end,
        demicoloncompat = true,
        quasicoloncheck = true
    }
}
