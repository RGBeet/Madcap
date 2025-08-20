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
            extra = { level_ups = 1, target_hand = "High Card" }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.target_hand, 'poker_hands'),
                    number_format(card.ability.extra.level_ups),
                    localize(MadLib.get_most_played_hand(), 'poker_hands'))
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                card.ability.extra.target_hand = MadLib.get_random_poker_hand()
                MadLib.simple_event(function()
                    play_sound((sound or 'tarot2'), 0.76, 0.4)
                    card:juice_up(0.3, 0.4)
                    return true
                end)
            end

            if context.forcetrigger then
                -- get most played poker hand
            end
        end,
        demicoloncompat = false, -- TODO: add level up most played poker hand
    }
}
