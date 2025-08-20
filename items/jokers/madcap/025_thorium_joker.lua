-- thorium joker conversions
Madcap.ThoriumJokerConversions = {
    ['2'] = '5',
    ['3'] = '8',
    ['4'] = '7',
    ['5'] = '2',
    ['6'] = '9',
    ['7'] = '4',
    ['8'] = '3',
    ['9'] = '6'
}

return {
    data = {
        object_type = "Joker",
        key     = 'thorium_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,4),
        rarity  = 1,
        cost    = 5,
        config =  {
            extra = { odds = 3 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'thorium_joker')
            return MadLib.collect_vars(number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.play
                and context.individual
                and context.other_card
                and context.scoring_hand
                and SMODS.pseudorandom_probability(card, 'thorium_joker', 1, card.ability.extra.odds)
            then
                -- if new rank doesnt exist, it shows up nil
                local new_rank = Madcap.ThoriumJokerConversions[tostring(context.other_card:get_id())]
                if new_rank then
                    MadLib.flip_cards({ context.other_card }, function(c)
                        SMODS.change_base(c, _, new_rank) -- change da rank
                        play_sound((sound or 'tarot2'), 0.76, 0.4)
                    end, nil, function(c)
                        c:juice_up()
                    end)
                end
            end
        end,
        demicoloncompat = false, -- all cards in scored hand have a 1 in 3 chance (WIP)
    },
}
